import 'package:flutter/material.dart';
import 'package:mortality_app/parts/blobs/fade_blob.dart';
import 'package:mortality_app/parts/blobs/show_up_blob.dart';

class NewUserFormPart extends StatelessWidget {
  const NewUserFormPart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.black, body: ScrollingUserGuide());
  }
}

class ScrollingUserGuide extends StatefulWidget {
  const ScrollingUserGuide({super.key});

  @override
  State<ScrollingUserGuide> createState() =>
      _ScrollingUserGuideState();
}

class _ScrollingUserGuideState extends State<ScrollingUserGuide>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  int _curr = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double backdropWidthHeight =
        MediaQuery.of(context).size.width * 0.96;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          allowImplicitScrolling: true,
          controller: _pageController,
          onPageChanged: (int page) {
            _tabController.index = page;
            setState(() => _curr = page);
          },
          children: <Widget>[
            Center(
                child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                  const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeInBlob(
                          delay: 0,
                          duration: Duration(milliseconds: 600),
                          child: Text("Welcome to",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.normal)),
                        ),
                        SizedBox(height: 14),
                        SlideBlob(
                            delay: 240,
                            child: Text("Mortality",
                                style: TextStyle(
                                    fontSize: 54,
                                    fontWeight: FontWeight.w800))),
                        SizedBox(height: 20),
                        SlideBlob(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 800),
                            delay: 800,
                            startOffset: Offset(0, 0.9),
                            child: Text(
                                "\"Literally a life tracker\"",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal))),
                      ]),
                  Opacity(
                    opacity: 0.1,
                    child: Image(
                        image: const AssetImage(
                            "assets/skull_backdrop.png"),
                        width: backdropWidthHeight,
                        height: backdropWidthHeight),
                  ),
                ])),
            const Center(
              child: Text('Second Page'),
            ),
            const Center(
              child: Text('Third Page'),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _curr != 0 ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: const SlideBlob(
                    delay: 2400,
                    startOffset: Offset(0, 0.1),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.swipe_right_rounded,
                              size: 18, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Swipe or use the arrows to navigate",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ])),
              ),
              const SizedBox(height: 18),
              ScrollerWidget(
                currentPageIndex: _curr,
                tabController: _tabController,
                onUpdateCurrentPageIndex: (int page) {
                  _pageController.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScrollerWidget extends StatelessWidget {
  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  const ScrollerWidget({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            color: Colors.white,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 38.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: Colors.grey[750],
            selectedColor: Colors.white,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(Icons.arrow_right_rounded,
                size: 38.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
