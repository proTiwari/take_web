import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserdetailpageModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for selleramount widget.
  TextEditingController? selleramountController;
  String? Function(BuildContext, String?)? selleramountControllerValidator;
  // State field(s) for propertyname widget.
  TextEditingController? propertynameController;
  String? Function(BuildContext, String?)? propertynameControllerValidator;
  // State field(s) for streetAddress widget.
  TextEditingController? streetAddressController;
  String? Function(BuildContext, String?)? streetAddressControllerValidator;
  // State field(s) for pincode widget.
  TextEditingController? pincodeController;
  String? Function(BuildContext, String?)? pincodeControllerValidator;
  // State field(s) for Name widget.
  TextEditingController? nameController;
  String? Function(BuildContext, String?)? nameControllerValidator;
  // State field(s) for Email widget.
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  // State field(s) for Phonenumber widget.
  TextEditingController? phonenumberController;
  String? Function(BuildContext, String?)? phonenumberControllerValidator;
  // State field(s) for Alternatephone widget.
  TextEditingController? alternatephoneController;
  String? Function(BuildContext, String?)? alternatephoneControllerValidator;
  // State field(s) for TextField widget.
  TextEditingController? textController9;
  String? Function(BuildContext, String?)? textController9Validator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    selleramountController?.dispose();
    propertynameController?.dispose();
    streetAddressController?.dispose();
    pincodeController?.dispose();
    nameController?.dispose();
    emailController?.dispose();
    phonenumberController?.dispose();
    alternatephoneController?.dispose();
    textController9?.dispose();
  }

  /// Additional helper methods are added here.

}
