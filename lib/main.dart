import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive/hive.dart';
import 'package:mortality_app/core/data_manager.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/parts/app_view.dart';
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
    runApp(const MortalityAppView());
  });
  Debug().info(
      "Startup took ${DateTime.now().difference(start).inMilliseconds}ms");
}
