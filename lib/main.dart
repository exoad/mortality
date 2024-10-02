import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive/hive.dart';
import 'package:mortality_app/core/data_manager.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/parts/new_user_form.dart';
import 'package:mortality_app/shared.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  DateTime start = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  timeDilation = 1.1;
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mortality',
        theme: ThemeData(
            brightness: Brightness.dark, primaryColor: kForeground),
        themeMode: ThemeMode.dark,
        home: const NewUserFormPart());
  }
}
