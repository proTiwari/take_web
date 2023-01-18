import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../globar_variables/globals.dart' as globals;
import '../pages/list_property/list_provider.dart';

class LoadedImagePropertyEdit extends StatefulWidget {
  dynamic e;
  var city;
  var propertyId;
  BuildContext context;
  LoadedImagePropertyEdit(this.e, this.city, this.propertyId, this.context,
      {Key? key})
      : super(key: key);

  @override
  State<LoadedImagePropertyEdit> createState() =>
      _LoadedImagePropertyEditState();
}

class _LoadedImagePropertyEditState extends State<LoadedImagePropertyEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(570),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          widget.e == null
              ? Container()
              : Consumer<ListProvider>(builder: (context, provider, child) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image.network(
                          widget.e,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.circle,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 43,
                          )),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            showDialog<String>(
                              context: widget.context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(''),
                                content: globals.initlistimages.length == 1
                                    ? const Text(
                                        'Atleast one image is required!')
                                    : const Text(
                                        'Are you sure you want to delete this image?'),
                                actions: <Widget>[
                                  globals.initlistimages.length != 1
                                      ? TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('No'),
                                        )
                                      : const SizedBox(),
                                  TextButton(
                                    onPressed: () async {
                                      // ignore: use_build_context_synchronously
                                      print('hjjjjjjjjj');
                                      print(globals.initlistimages.length);
                                      if (globals.initlistimages.length != 1) {
                                        globals.initlistimages.remove(widget.e);
                                        provider.imagelistvalue =
                                            globals.initlistimages;
                                        provider.changeimagelist();
                                        // provider.imagelistvalue = globals.imageList;
                                        // provider.changeimagelist();
                                        Navigator.pop(
                                            context, "globals.initlistimages");
                                        deleteImage();
                                      }

                                      // ignore: use_build_context_synchronously
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const ProfilePage()),
                                      // );
                                    },
                                    child: globals.initlistimages.length == 1
                                        ? TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Okay'),
                                          )
                                        : const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                            // deleteImage();
                            // globals.initlistimages.remove(widget.e);
                            // provider.imagelistvalue = globals.imageList;
                            // provider.changeimagelist();
                            // Navigator.pop(context, globals.initlistimages);
                          },
                        ),
                      ),
                    ],
                  );
                }),
        ]),
      ),
    );
  }

  void deleteImage() async {
    try {
      var valtodelete = [];
      valtodelete.add("${widget.e}");
      var list = widget.e.toString().split('%2F');
      var list2 = list[2].split("?alt");

      print("property/${list[1]}/${list2[0]}");
      final storageRef = FirebaseStorage.instance.ref();
      final desertRef = storageRef.child("property/${list[1]}/${list2[0]}");
      await desertRef.delete();
      await FirebaseFirestore.instance
          .collection("State")
          .doc('City')
          .collection(widget.city)
          .doc(widget.propertyId)
          .update({
        'propertyimage': FieldValue.arrayRemove(valtodelete),
      });
      showToast(context: context, "deleted successfully");
    } catch (e) {
      print("wewewwwwwwwwww$e");
    }
  }
}
