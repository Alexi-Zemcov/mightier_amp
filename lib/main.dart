// (c) 2020-2021 Dian Iliev (Tuntorius)
// This code is licensed under MIT license (see LICENSE.md for details)

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mighty_plug_manager/UI/pages/DebugConsolePage.dart';
import 'package:mighty_plug_manager/bluetooth/devices/presets/presetsStorage.dart';
import 'package:mighty_plug_manager/home_page.dart';
import 'package:mighty_plug_manager/platform/simpleSharedPrefs.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'UI/theme.dart';
import 'bluetooth/nux_device_control.dart';
//recreate this file with your own api keys
import 'configKeys.dart';

//able to create snackbars/messages everywhere
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  //configuration data is needed before start of the app
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs prefs = SharedPrefs();

  //capture flutter errors
  if (!kDebugMode)
    FlutterError.onError = (FlutterErrorDetails details) {
      DebugConsole.print("Flutter error: ${details.toString()}");

      //update diagnostics with json preset
      NuxDeviceControl.instance()
          .updateDiagnosticsData(includeJsonPreset: true);

      // Send report
      Sentry.captureException(
        details,
        stackTrace: details.stack,
      );
    };

  if (!kDebugMode) {
    runZonedGuarded(() {
      prefs.waitLoading().then((value) async {
        if (!kDebugMode) {
          await SentryFlutter.init((options) {
            options.dsn = sentryDsn;
          });
        }
        mainRunApp();
      });
    }, (Object error, StackTrace stackTrace) async {
      // Whenever an error occurs, call the `_reportError` function. This sends
      // Dart errors to the dev console or Sentry depending on the environment.
      //_reportError(error, stackTrace);

      DebugConsole.print("Dart error: ${error.toString()}");
      DebugConsole.print(stackTrace);

      //update diagnostics with json preset
      NuxDeviceControl.instance()
          .updateDiagnosticsData(includeJsonPreset: true);

      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    });
  } else {
    prefs.waitLoading().then((value) {
      mainRunApp();
    });
  }
}

mainRunApp() {
  runApp(App());
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NuxDeviceControl device = NuxDeviceControl.instance();
  SharedPrefs prefs = SharedPrefs();
  PresetsStorage storage = PresetsStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mightier Amp',
      theme: getTheme(),
      home: Home(),
      navigatorKey: navigatorKey,
    );
  }
}
