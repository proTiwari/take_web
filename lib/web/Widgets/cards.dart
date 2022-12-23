import 'package:flutter/material.dart';
import 'package:take_web/web/Widgets/smaill_card.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import 'package:take_web/web/pages/property_detail/property_detail.dart';

class CardsWidget extends StatefulWidget {
  var property;
  CardsWidget(this.property, {Key? key}) : super(key: key);

  @override
  State<CardsWidget> createState() => _CardsWidgetState();
}

class _CardsWidgetState extends State<CardsWidget> {
  var property = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (widget.property['wantto'] == 'Rent property') {
      setState(() {
        property = 'Property on sale';
      });
    } else {
      setState(() {
        property = 'Property on rent';
      });
    }

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
      // margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(5, 15),
              blurRadius: 5,
              spreadRadius: 3)
        ],
        // color: Colors.white,
        // // color: Theme.of(context).primaryColor,
        // borderRadius: BorderRadius.circular(58),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Property(detail: widget.property)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
                child: Image.network(
                  widget.property['propertyimage'][0],
                  height: globals.height * 0.39,
                  fit: width < 800 ? BoxFit.cover : BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                              height: 37,
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
    );
  }
}
