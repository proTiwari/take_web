import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final dynamic time;
  final bool status;
  final String imageurl;
  final String propertydata;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time,
      required this.status,
      required this.imageurl,
      required this.propertydata})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        padding: EdgeInsets.only(
            top: 4,
            bottom: 0,
            left: widget.sentByMe ? 0 : 24,
            right: widget.sentByMe ? 24 : 0),
        alignment:
            widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sentByMe
              ? const EdgeInsets.only(left: 30)
              : const EdgeInsets.only(right: 30),
          padding:
              const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: widget.sentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              color: widget.sentByMe
                  ? Theme.of(context).primaryColor
                  : Colors.grey[700]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.sender.toUpperCase(),
              //   textAlign: TextAlign.start,
              //   style: const TextStyle(
              //       fontSize: 13,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white,
              //       letterSpacing: -0.5),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text("${widget.message} \n",
              //     textAlign: TextAlign.start,
              //     style: const TextStyle(fontSize: 16, color: Colors.white)),
              RichText(
                text: TextSpan(
                  // text:
                  //     "${widget.message}\n",//MM/dd/yyyy,
                  style: const TextStyle(color: Colors.white),
                  children: [
                    widget.imageurl != ''
                        ? WidgetSpan(
                            child: Image.network(
                            widget.imageurl,
                          ))
                        : TextSpan(),
                    widget.propertydata != ''
                        ? TextSpan(
                            text: widget.propertydata,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white))
                        : TextSpan(),
                    TextSpan(
                        text: widget.message,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    TextSpan(
                        text:
                            "   ${DateFormat('hh:mm a').format(widget.time.toDate())}  ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.white)),
                    widget.sentByMe
                        ? widget.status
                            ? WidgetSpan(
                                child: SizedBox(
                                height: 18,
                                width: 18,
                                child: Image.asset("assets/seen.png"),
                              ))
                            : WidgetSpan(
                                child: SizedBox(
                                height: 18,
                                width: 18,
                                child: Image.asset("assets/unseen.png"),
                              ))
                        : TextSpan(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
