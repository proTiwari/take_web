import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_functions.dart';
import '../helpers/enum.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  AuthService._();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // // register
  // Future registerUserWithEmailandPassword(
  //     String fullName, String email, String password) async {
  //   try {
  //     User user = (await firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password))
  //         .user!;
  //
  //     if (user != null) {
  //       // call our database service to update the user data.
  //       await DatabaseService(uid: user.uid).savingUserData(fullName, email);
  //       return true;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  static var instance = AuthService._();

  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserModel> getUserDetails() async {
    try {
      User currentUser = firebaseAuth.currentUser!;
      print(currentUser.uid);

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      return UserModel.fromSnap(documentSnapshot);
    } catch (e) {
      print("weojfwijefow");
      print(e.toString());
    }
    return UserModel();
  }

  //sign up authentication
  Future<EmailSignUpResults> signUpAuth({
    required String email,
    required String password,
  }) async {
    try {
      //create a new user with given email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //if given email is not null send email verification message
      if (userCredential.user!.email != null) {
        await userCredential.user!.sendEmailVerification();
        return EmailSignUpResults.signUpCompleted;
      }

      //if sign up is not completed for some reasons
      return EmailSignUpResults.signUpNotCompleted;
    } catch (e) {
      //if email already exists
      return EmailSignUpResults.emailAlreadyPresent;
    }
  }

  //login authentication
  Future<EmailSignInResults> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      //sign in user with email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //if email has been verified
      if (userCredential.user!.emailVerified) {
        return EmailSignInResults.signInCompleted;
      }

      //if email has not been verified
      else {
        final bool logOutResponse = await logOut();
        if (logOutResponse) {
          return EmailSignInResults.emailNotVerified;
        } else {
          return EmailSignInResults.unexpectedError;
        }
      }
    } catch (e) {
      //error in email and password authentication
      return EmailSignInResults.emailOrPasswordInvalid;
    }
  }

  //log user out of their acct
  Future<bool> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
