import 'package:flutter/material.dart';

import '../../web1/globar_variables/globals.dart';
class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 50,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(5, 15),
              blurRadius: 5,
              spreadRadius: 3,
          ),
        ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const ListTile(
        leading: Icon(Icons.search),
        title: TextField(
          decoration: InputDecoration(
              hintText: 'City, Pincode, Locality...etc', border: InputBorder.none,
          ),

        ),
       trailing: Icon(Icons.message_rounded, color: Colors.blueGrey,),
      ),

    );
  }
}
