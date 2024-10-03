import 'package:flutter/material.dart';
import 'package:mortality_app/parts/new_user_form.dart';
import 'package:mortality_app/shared.dart';
import 'package:oktoast/oktoast.dart';

class MortalityAppView extends StatelessWidget {
  const MortalityAppView({super.key});

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
