import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../globar_variables/globals.dart' as globals;
import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';

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
  var recentmessageuid;
  @override
  Widget build(BuildContext context) {
    print("globasl ${globals.recentmessagetemp}");
    print(widget.sender);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Container(
        color: Color.fromARGB(255, 230, 229, 229),
        padding: EdgeInsets.only(
            top: 4,
            bottom: 0,
            left: widget.sentByMe ? 0 : 13,
            right: widget.sentByMe ? 13 : 0),
        alignment:
            widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sentByMe
              ? const EdgeInsets.only(left: 30)
              : const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          decoration: BoxDecoration(
              borderRadius: globals.recentmessagetemp == widget.sender
                  ? widget.sentByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )
                  : widget.sentByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
              color: widget.sentByMe
                  ? FlutterFlowTheme.of(context).secondaryBackground
                  : FlutterFlowTheme.of(context).greenColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.sentByMe
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          children: [
                            widget.imageurl != ''
                                ? WidgetSpan(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8), // Image border
                                      child: SizedBox.fromSize(
                                        // Image radius

                                        child: Image.network(widget.imageurl,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                : const TextSpan(),
                            widget.imageurl != ''
                                ? const WidgetSpan(
                                    child: SizedBox(
                                    height: 30,
                                  ))
                                : const WidgetSpan(
                                    child: SizedBox(
                                    height: 0,
                                  )),
                            widget.propertydata != ''
                                ? TextSpan(
                                    text: " ${widget.propertydata}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0)))
                                : TextSpan(),
                            TextSpan(
                              text: " ${widget.message}",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            TextSpan(
                                text:
                                    "   ${DateFormat('hh:mm a').format(widget.time.toDate())}  ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 0, 0, 0))),
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
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: RichText(
                        text: TextSpan(
                          // text:
                          //     "${widget.message}\n",//MM/dd/yyyy,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                          children: [
                            widget.imageurl != ''
                                ? WidgetSpan(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8), // Image border
                                      child: SizedBox.fromSize(
                                        // Image radius

                                        child: Image.network(widget.imageurl,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  )
                                : TextSpan(),
                            widget.imageurl != ''
                                ? const WidgetSpan(
                                    child: SizedBox(
                                    height: 30,
                                  ))
                                : const WidgetSpan(
                                    child: SizedBox(
                                    height: 0,
                                  )),
                            widget.propertydata != ''
                                ? TextSpan(
                                    text: " ${widget.propertydata}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)))
                                : TextSpan(),
                            TextSpan(
                              text: " ${widget.message}",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            TextSpan(
                                text:
                                    "   ${DateFormat('hh:mm a').format(widget.time.toDate())}  ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 255, 255, 255))),
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
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
