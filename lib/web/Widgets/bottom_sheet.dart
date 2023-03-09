import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomSheetImage extends StatefulWidget {
  const BottomSheetImage({Key? key}) : super(key: key);

  @override
  State<BottomSheetImage> createState() => _BottomSheetImageState();
}

class _BottomSheetImageState extends State<BottomSheetImage> {
  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.camera,
                size: 50,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              label: const Text("Camera"),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.3,
            // ),
            TextButton.icon(
              icon: const Icon(
                Icons.image,
                size: 50,
              ),
              onPressed: () {
                Navigator.pop(context);
                // takePhoto(ImageSource.gallery);
                // Navigator.pop(context);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}
