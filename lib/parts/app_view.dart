import 'package:flutter/material.dart';
import 'package:mortality_app/parts/bits/canon_startuptime.dart';
import 'package:mortality_app/parts/home_view.dart';
import 'package:mortality_app/parts/new_user_form.dart';
import 'package:mortality_app/shared.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/data_manager.dart';

class MortalityAppView extends StatelessWidget {
  final bool isNewUser;

  const MortalityAppView({super.key, required this.isNewUser});

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
            home: isNewUser
                ? const NewUserFormPart(child: HomeView())
                : const HomeView()),
      ),
    );
  }
}

/*
* import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Zoomable Grid of Squares")),
        body: ZoomableGrid(),
      ),
    );
  }
}

class ZoomableGrid extends StatefulWidget {
  @override
  _ZoomableGridState createState() => _ZoomableGridState();
}

class _ZoomableGridState extends State<ZoomableGrid> {
  // Default zoom level (controls the size of each square and number of squares per row)
  double _zoomLevel = 1.0;
  final int _totalSquares = 1000; // Arbitrary large number to simulate infinite scrolling

  @override
  Widget build(BuildContext context) {
    // Calculate number of squares per row based on zoom level
    int squaresPerRow = (_zoomLevel * 3).toInt(); // More zoom = fewer squares per row

    return Column(
      children: [
        // Zoom control buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.zoom_out),
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0); // Minimum zoom level is 0.5
                  });
                },
              ),
              Text("Zoom Level: ${_zoomLevel.toStringAsFixed(1)}"),
              IconButton(
                icon: Icon(Icons.zoom_in),
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 4000); // Maximum zoom level is 2.0
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: squaresPerRow, // Adjust squares per row based on zoom level
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _totalSquares, // Arbitrarily large number to simulate infinite scroll
            itemBuilder: (context, index) {
              return Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

* */
