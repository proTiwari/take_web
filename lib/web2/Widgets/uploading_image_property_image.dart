import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globar_variables/globals.dart' as globals;
import '../pages/list_property/list_provider.dart';

class UploadingImageProperty extends StatefulWidget {
  dynamic e;
  UploadingImageProperty(this.e, {Key? key}) : super(key: key);

  @override
  State<UploadingImageProperty> createState() => _UploadingImagePropertyState();
}

class _UploadingImagePropertyState extends State<UploadingImageProperty> {
  @override
  Widget build(BuildContext context) {
    print("1");
    // print(widget.e);
    print("2");
    print("9");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 100,
      decoration: BoxDecoration(
        // boxShadow: [

        // ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(570),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.e == null
                ? Container()
                : Consumer<ListProvider>(builder: (context, provider, child) {
                    return Stack(children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: FileImage(File(widget.e.path)),
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
                              globals.uploadingimageList.remove(widget.e);
                              provider.uploadimagelist =
                                  globals.uploadingimageList;
                              provider.uploadingimagelist();
                              // Navigator.pop(context, globals.imageList);
                            },
                          )),
                    ]);
                  }
                    // : Consumer<ListProvider>(
                    //     builder: (context, provider, child) {
                    //       return Stack(children: [
                    //         CircleAvatar(
                    //           backgroundColor: Colors.white,
                    //           radius: 50.0,
                    //           child: Image.memory(
                    //             widget.e,
                    //             fit: BoxFit.fill,
                    //           ),
                    //         ),
                    //         const Positioned(
                    //           bottom: 0,
                    //           right: 0,
                    //           child: Icon(
                    //             Icons.circle,
                    //             color: Color.fromARGB(255, 255, 255, 255),
                    //             size: 43,
                    //           ),
                    //         ),
                    //         Positioned(
                    //           bottom: -3,
                    //           right: -3,
                    //           child: IconButton(
                    //             icon: const Icon(Icons.delete),
                    //             onPressed: () {
                    //               setState(() {
                    //                 globals.uploadingimageList.remove(widget.e);
                    //                 provider.uploadimagelist =
                    //                     globals.uploadingimageList;
                    //                 provider.uploadingimagelist();
                    //                 // Navigator.pop(context, globals.imageList);
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ]);
                    //     },
                    //   ),
                    )
          ],
        ),
      ),
    );
  }
}
