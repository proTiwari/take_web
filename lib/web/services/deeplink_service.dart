// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../globar_variables/globals.dart' as globals;

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');
  ValueNotifier<String> moneyreferrerCode = ValueNotifier<String>('');

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaanull: ${data}");
    if (data != null) {
      print("sdfffffffffffffffasdjfaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${data.link}");
      try {
        globals.dynamiclink = data.link.toString().split("%22")[1].split('refer-')[1];
      } catch (e) {}

      _handleDeepLink(data);
    }

    //handle foreground
    dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      debugPrint('Failed: $v');
    });
  }

  Future<String> createReferLink(String referCode, property) async {
    DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://runforrent.page.link',
      link: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.runforrent.take&/refer?code="$referCode"'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.runforrent.take'),
        packageName: 'com.runforrent.take',
        minimumVersion: 4,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Address: ${property['streetaddress']}',
        description: '${property['description']}',
        imageUrl: Uri.parse('${property['propertyimage'][0]}'),
      ),
    );

    final shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);

    return shortLink.shortUrl.toString();
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
  }
}
