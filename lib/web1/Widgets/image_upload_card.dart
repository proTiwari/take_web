import 'package:flutter/material.dart';

class ImageUploadCard extends StatefulWidget {
  dynamic e;
  ImageUploadCard(this.e, {Key? key}) : super(key: key);

  @override
  State<ImageUploadCard> createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  @override
  Widget build(BuildContext context) {
    print("1");
    print(widget.e);
    print("2");
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 140,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(5, 15),
              blurRadius: 5,
              spreadRadius: 3)
        ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        
          padding: const EdgeInsets.all(8.0),
          child: Column(
            
            children: [

              widget.e == null
                  ? Container(
                height: 120,
                      child: Image.asset("assets/camera3.png"),
                    )
                  : Container(
                      child: Image.asset("assets/camera2.png"),
                    ),

            ],
          )),
    );
  }
}
