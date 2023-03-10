import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:page_transition/page_transition.dart';
import '../../Widgets/bottom_nav_bar.dart';
import '../list_property/agreement_document.dart';
import '../list_property/flutter_flow/flutter_flow_util.dart';
import '../property_detail/property_detail.dart';
import '../splashscreen.dart';
import '../list_property/home_page/home_page_widget.dart';
import '../list_property/imageAndUpload.dart/imageandupload.dart';
import '../list_property/userdetailpage/userdetailpage2.dart';
import '../list_property/userdetailpage/userdetailpage_widget.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../list_property/backend/backend.dart';

import '../list_property/flutter_flow/lat_lng.dart';
import '../list_property/flutter_flow/place.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

go.GoRouter createRouter(AppStateNotifier appStateNotifier) => go.GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, _) => ListPropertyPage(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => SplashScreen(), //SplashScreen
          routes: [
            FFRoute(
              name: 'splashscreen',
              path: 'splashscreen',
              builder: (context, params) => SplashScreen(),
            ),
            FFRoute(
              name: 'customnav',
              path: 'customnav',
              builder: (context, params) => CustomBottomNavigation(
                  params.getParam('city', ParamType.String),
                  params.getParam("secondcall", ParamType.String),
                  params.getParam("profile", ParamType.String)),
            ),
            FFRoute(
              name: 'property',
              path: 'property',
              builder: (context, params) => Property(
                  detail: params.getParam("detail", ParamType.Document)),
            ),
            FFRoute(
              name: 'HomePage',
              path: 'homePage',
              builder: (context, params) => ListPropertyPage(),
            ),
            FFRoute(
              name: 'policy',
              path: 'policy',
              builder: (context, params) => AgreementDocument(),
            ),
            FFRoute(
              name: 'uploadproperty',
              path: 'uploadproperty',
              builder: (context, params) => UploadProperty(),
            ),
            FFRoute(
              name: 'userdetailpage2',
              path: 'userdetailpage2',
              builder: (context, params) => Userdetailpage2Widget(),
            ),
            FFRoute(
              name: 'userdetailpage',
              path: 'userdetailpage',
              builder: (context, params) => const UserdetailpageWidget(),
            ),
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ).toRoute(appStateNotifier),
      ],
      // urlPathStrategy: UrlPathStrategy.path,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension _GoRouterStateExtensions on go.GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(params)
    ..addAll(queryParams)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final go.GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    List<String>? collectionNamePath,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(param, type, isList, collectionNamePath);
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<go.GoRoute> routes;

  go.GoRoute toRoute(AppStateNotifier appStateNotifier) => go.GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? go.CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}
