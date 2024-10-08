import 'package:flutter/material.dart';
import 'package:mortality_app/parts/bits/canon_startuptime.dart';
import 'package:mortality_app/parts/home_view.dart';
import 'package:mortality_app/parts/new_user_form.dart';
import 'package:mortality_app/shared.dart';
import 'package:mortality_app/util/intf.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/data_manager.dart';
import '../test_views/test_views.dart' as ts;

class MortalityAppView extends StatelessWidget {
  final bool isNewUser;
  final TestView? testView;

  const MortalityAppView({super.key, required this.isNewUser})
      : testView = ts.testView;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<CanonicalStartupTimeNotifier>(
            create: (_) => CanonicalStartupTimeNotifier()),
        ChangeNotifierProvider<DataBoxManager>(create: (_) => DataBoxManager()),
      ],
      child: OKToast(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mortality',
            theme: ThemeData(
                dividerColor: kTertiary,
                expansionTileTheme: ExpansionTileThemeData(
                    iconColor: kForeground,
                    collapsedIconColor: kPoprockPrimary_1,
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRRectArc)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRRectArc))),
                iconTheme: const IconThemeData(color: kForeground),
                scaffoldBackgroundColor: kBackground,
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
            home: testView ??
                (isNewUser
                    ? const NewUserFormPart(child: HomeView())
                    : const HomeView())),
      ),
    );
  }
}
