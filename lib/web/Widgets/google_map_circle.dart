import 'package:flutter/material.dart';

import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';

class GoogleMapCircle extends StatelessWidget {
  const GoogleMapCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              offset: const Offset(1, 1),
              blurRadius: 0,
              spreadRadius: 3)
        ],
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Icon(Icons.location_on, color: FlutterFlowTheme.of(context).alternate, size: 50.0),
      ),
    );
  }
}
