import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:go_router/go_router.dart';
import 'package:take_web/web/Widgets/smaill_card.dart';
import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';
import '../pages/nav/serialization_util.dart';
import '../pages/property_detail/property_detail.dart';
import '../services/code_generator.dart';
import '../services/deeplink_service.dart';

class CardsWidget extends StatefulWidget {
  var property;
  CardsWidget(this.property, {Key? key}) : super(key: key);

  @override
  State<CardsWidget> createState() => _CardsWidgetState();
}

class _CardsWidgetState extends State<CardsWidget> {
  var property = '';

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
    var id = widget.property['propertyId'];

    final referCode =
        await CodeGenerator().generateCode('refer', id.toString());

    referLink = await DeepLinkService.instance
        ?.createReferLink(referCode, widget.property);

    setState(() {
      referLink;
    });
  }

  var firstpropertyimage;
  @override
  Widget build(BuildContext context) {
    try {
      firstpropertyimage = widget.property['propertyimage'][0];
    } catch (e) {
      firstpropertyimage =
          'https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/house-icon.png';
    }

    final width = MediaQuery.of(context).size.width;
    if (widget.property['wantto'] == 'Rent property') {
      setState(() {
        property = "Rental property";
      });
    } else {
      setState(() {
        property = 'Seller property';
      });
    }

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 6 : width * 0.24),
          // margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x32000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Property(
                            detail: widget.property,
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Image(
                    height: 200,
                    fit: width < 800 ? BoxFit.cover : BoxFit.contain,
                    image: CachedNetworkImageProvider(
                      firstpropertyimage,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2.0, 2.0, 2.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 31,
                                child: SmallCard(
                                    "${widget.property['city']}"), //widget.property['city']
                              ),
                              SizedBox(
                                height: 31,
                                child: widget.property['wantto'] ==
                                        'Rent property'
                                    ? SmallCard(
                                        "₹${widget.property['amount']}/${widget.property['paymentduration']}")
                                    : SmallCard(
                                        "₹${widget.property['amount']}/-"), //widget.property['streetaddress']
                              ),
                              SizedBox(
                                height: 31,
                                child: SmallCard(
                                    "$property"), //widget.property['streetaddress']
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 2.0, 2.0, 2.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 31,
                                child: SmallCard(
                                    "${widget.property['streetaddress']}"), //
                              ),
                              SizedBox(
                                height: 31,
                                child: SmallCard(
                                    "${widget.property['pincode']}"), //
                              ),
                              SizedBox(
                                height: 31,
                                child: SmallCard(
                                    "${widget.property['whatsappnumber']}"), //
                              ),
                              widget.property['wantto'] == 'Rent property'
                                  ? SizedBox(
                                      height: 31,
                                      child: SmallCard(
                                          "${widget.property['servicetype']}"), //
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Divider(
                //   color: Colors.grey.shade500,
                //   indent: 10,
                //   endIndent: 10,
                // ),
                //
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(9, 6, 9, 15),
                //   child: Row(
                //     children: [
                //       SizedBox(width: globals.width*0.87,
                //           child: Text("Feedback 0"),
                //       ),
                //   RichText(
                //     text: TextSpan(
                //       text: "0",
                //     style: TextStyle(
                //     color: Colors.black45,
                //         fontSize: 17
                //     ),),),
                //       Icon(
                //         Icons.star,
                //         color: Colors.yellow,
                //         size: 20.0,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
      // Positioned(
      //     right: 0,
      //     child: Padding(
      //       padding: const EdgeInsets.all(13.0),
      //       child: GestureDetector(
      //         onTap: () async {
      //           if (referLink != '') {
      //             await share();
      //           }
      //         },
      //         child: Container(
      //             height: 30,
      //             width: 30,
      //             decoration: const BoxDecoration(
      //                 color: Color.fromARGB(255, 255, 255, 255),
      //                 shape: BoxShape.circle),
      //             child: Icon(
      //               Icons.share_rounded,
      //               color: FlutterFlowTheme.of(context).primaryColor,
      //               size: 17,
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
