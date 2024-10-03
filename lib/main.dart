import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive/hive.dart';
import 'package:mortality_app/core/data_manager.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/parts/new_user_form.dart';
import 'package:mortality_app/shared.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  DateTime start = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  // ********* DEBUG SECTION ********* //
  debugRepaintRainbowEnabled = false;
  // ********************************* //
  Debug().init();
  if (Platform.isAndroid) {
    Debug().warn("Detected ANDROID_PRESET");
    await FlutterDisplayMode.setHighRefreshRate().then((_) =>
        Debug().info("ANDROID_PRESET -> High refresh rate set"));
  }
  Directory dir = await getApplicationDocumentsDirectory();
  Debug().info("Setting data load dir (${dir.path})");
  Hive.init(dir.path);
  DataBoxManager().load().then((bool isNewUser) {
    Debug().info("IsNewUser=$isNewUser");
    runApp(const MyApp());
  });
  Debug().info(
      "Startup took ${DateTime.now().difference(start).inMilliseconds}ms");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mortality',
          theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                  selectionHandleColor: kForeground,
                  selectionColor: kForeground.withOpacity(0.5),
                  cursorColor: kForeground),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kForeground),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kForeground),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kForeground),
                ),
                activeIndicatorBorder: BorderSide(color: kForeground),
                labelStyle: TextStyle(color: kForeground),
              ),
              appBarTheme: const AppBarTheme(
                  backgroundColor: kBackground,
                  foregroundColor: kForeground,
                  titleTextStyle: TextStyle(
                      color: kForeground,
                      fontSize: 24,
                      fontFamily: kDefaultFontFamily)),
              fontFamily: kDefaultFontFamily,
              brightness: Brightness.dark,
              primaryColor: kForeground),
          themeMode: ThemeMode.dark,
          home: const NewUserFormPart()),
    );
  }
}
