import 'package:flutter/material.dart';
import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';
import '../pages/list_property/flutter_flow/flutter_flow_util.dart';
import '../pages/ownersprofile/owners_profile_page.dart';
import 'package:flutter_share/flutter_share.dart';

import '../services/code_generator.dart';
import '../services/deeplink_service.dart';

class OwnerProfileCard extends StatefulWidget {
  var detail;
  var profileimage;
  var valuedata;
  OwnerProfileCard(this.detail, this.profileimage, this.valuedata, {Key? key})
      : super(key: key);

  @override
  State<OwnerProfileCard> createState() => _OwnerProfileCardState();
}

class _OwnerProfileCardState extends State<OwnerProfileCard> {
  @override
  void initState() {
    super.initState();
    deeplink();
  }

  String? referLink = '';

  void deeplink() async {
    final deepLinkRepo = await DeepLinkService.instance;
    var referralCode = await deepLinkRepo?.referrerCode.value;
    print(
        "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd ${referralCode}");
    final referCode =
        await CodeGenerator().generateCode('refer', widget.detail);
    referLink = await DeepLinkService.instance
        ?.createReferLink(referCode, widget.detail);
  }

  @override
  Widget build(BuildContext context) {
    var date;
    var datetime;
    try {
      date = widget.detail['date'];
      datetime = DateFormat.yMMMEd().format(date.toDate());
      print("sidjijsoj: ${datetime}");
    } catch (e) {
      print("hereejfoiej");
      print(e.toString());
      date = null;
    }

    return Stack(children: [
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OwnersProfilePage(
                      widget.valuedata, widget.detail, widget.detail['uid'])));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 0, spreadRadius: 0)
            ],
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: widget.profileimage == null
                          ? const NetworkImage("")
                          : NetworkImage(widget.profileimage),
                      child: Text(
                        widget.detail["ownername"]
                            .substring(0, 1)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          widget.detail["ownername"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    subtitle: widget.detail['wantto'] == "Rent property"
                        ? const Text(
                            "( Property On Rent )",
                            style: TextStyle(fontSize: 13),
                          )
                        : const Text(
                            "( Property On Sale )",
                            style: TextStyle(fontSize: 13),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(38, 20, 18, 0),
                    child: Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            text: "Address",
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              text: "${widget.detail["streetaddress"]}",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.detail["description"] == "null"
                      ? widget.detail["wantto"] == "Rent property"
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(38, 0, 18, 18),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text: "Description",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        text:
                                            "If you need any help regarding this property please contact us on ${widget.detail["mobilenumber"]}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(38, 0, 18, 18),
                              child: Row(
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text: "Description",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        text:
                                            "You can need more information please contact us on ${widget.detail["mobilenumber"]}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                          child: Row(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text: "Description",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    text: "${widget.detail["description"]}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  date != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(38, 20, 18, 18),
                          child: Row(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text: "Date of listing",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    text: "${datetime}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
      // Positioned(
      //     right: 0,
      //     child: Padding(
      //       padding: const EdgeInsets.all(18.0),
      //       child: GestureDetector(
      //         onTap: () async {
      //           await share();
      //         },
      //         child: Container(
      //             height: 40,
      //             width: 40,
      //             decoration: const BoxDecoration(
      //                 color: Color.fromARGB(255, 255, 255, 255),
      //                 shape: BoxShape.circle),
      //             child: Icon(
      //               Icons.share_rounded,
      //               color: FlutterFlowTheme.of(context).primaryColor,
      //               size: 20,
      //             )),
      //       ),
      //     ))
    ]);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'RunForRent',
        text:
            'From cozy rooms to spacious family homes, find your ideal property with us( completely free )',
        linkUrl: '$referLink',
        chooserTitle: '');
  }
}
