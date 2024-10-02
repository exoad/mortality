import 'package:flutter/material.dart';
import 'package:mortality_app/debug.dart';
import 'package:mortality_app/parts/blobs/fade_blob.dart';
import 'package:mortality_app/parts/blobs/gesture_action_blob.dart';
import 'package:mortality_app/parts/blobs/gradient_blob.dart';
import 'package:mortality_app/parts/blobs/lazy_show_up_blob.dart';
import 'package:mortality_app/parts/blobs/show_up_blob.dart';
import 'package:mortality_app/shared.dart';
import 'package:oktoast/oktoast.dart';

class NewUserFormPart extends StatelessWidget {
  const NewUserFormPart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kBackground, body: ScrollingUserGuide());
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
  int _curr;
  bool _permsGranted;

  _ScrollingUserGuideState()
      : _permsGranted = false,
        _curr = 0;

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
    double backdropWidthHeight = MediaQuery.sizeOf(context).width * 2;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          allowImplicitScrolling: true,
          controller: _pageController,
          onPageChanged: (int page) {
            _tabController.index = page;
            setState(() => _curr = page);
          },
          children: <Widget>[
            NewUser_WelcomePage(
                curr: _curr,
                backdropWidthHeight: backdropWidthHeight),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text("Permissions",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 26),
                      const Divider(color: kTertiary),
                      Expanded(
                        child: SingleChildScrollView(
                          physics:
                              const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                          child: Column(children: <Widget>[
                            const SizedBox(height: 28),
                            const NewUserPermissionsField(
                                delay: 60,
                                icon: Icons.health_and_safety_rounded,
                                gradientEnd: Alignment.bottomRight,
                                gradientStart: Alignment.topLeft,
                                stops: <double>[0.3, 0.7],
                                title: "Personalization",
                                description:
                                    "This app is tailored to you, so we need to know a bit about you.",
                                invertColorPos: true),
                            const SizedBox(height: 20),
                            const NewUserPermissionsField(
                                delay: 100,
                                icon: Icons
                                    .notifications_active_rounded,
                                stops: <double>[0.2, 0.8],
                                title: "Notifications",
                                description:
                                    "Ensures you never miss out on what is important. Like what has passed and what remains.",
                                gradientStart: Alignment.topRight,
                                gradientEnd: Alignment.centerRight),
                            const SizedBox(height: 20),
                            const NewUserPermissionsField(
                                delay: 80,
                                icon: Icons.phone_iphone_rounded,
                                gradientEnd: Alignment.centerRight,
                                gradientStart: Alignment.topLeft,
                                stops: <double>[0.4, 0.6],
                                title: "Storage",
                                description:
                                    "Mortality uses storage to save your data and settings.",
                                invertColorPos: true),
                            const SizedBox(height: 20),
                            const NewUserPermissionsField(
                                delay: 140,
                                icon: Icons.location_on_rounded,
                                stops: <double>[0.2, 0.8],
                                title: "Location",
                                description:
                                    "We utilize environmental data to tailor towards you.",
                                gradientStart: Alignment.topRight,
                                gradientEnd: Alignment.centerRight),
                            const SizedBox(height: 46),
                            if (!_permsGranted)
                              LazySlideInBlob(
                                  delay: 1500,
                                  startOffset: const Offset(0, 0.2),
                                  child: TextButtonBlob.primary(
                                    "Grant and Personalize",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    onPressed: () async {
                                      Debug().info(
                                          "Launch permission grant and personalize page");
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute<
                                                  Widget>(
                                              builder: (BuildContext
                                                      context) =>
                                                  PersonalizationPage(
                                                      onExit: () =>
                                                          Navigator.of(
                                                                  context)
                                                              .pop())));
                                    },
                                  )),
                            const SizedBox(height: 50),
                          ]),
                        ),
                      ),
                    ]),
              ),
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
                child: const SlideInBlob(
                  delay: 1400,
                  startOffset: Offset(0, 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.swipe_left_rounded,
                          size: 20, color: kForeground),
                      SizedBox(width: 8),
                      Text("Swipe or use the arrows to navigate",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ScrollerWidget(
                currentPageIndex: _curr,
                tabController: _tabController,
                onUpdateCurrentPageIndex:
                    (/* page == next page */ int page) {
                  Debug().info(
                      "NEW_USER_WELCOME_PAGE page update $page");
                  if (!_permsGranted && page == 2) {
                    showToastWidget(
                        Center(
                          child: Container(
                            width: 140,
                            height: 60,
                            decoration: BoxDecoration(
                                color: kBackground,
                                borderRadius:
                                    BorderRadius.circular(kRRectArc),
                                border:
                                    Border.all(color: kForeground)),
                            child: const Center(
                              child: Text("Please grant permissions",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kForeground,
                                      fontSize: 16)),
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 3));
                    Debug().warn(
                        "NEW_USER_WELCOME_PAGE -> perms not granted, not moving!");
                  } else {
                    _pageController.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    Debug().info(
                        "NEW_USER_WELCOME_PAGE -> perms granted, moving on");
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonalizationPage extends StatefulWidget {
  final void Function() onExit;

  const PersonalizationPage({super.key, required this.onExit});

  @override
  State<PersonalizationPage> createState() =>
      _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  int _curr;

  _PersonalizationPageState() : _curr = 0;

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

  void toPage(int newPage) {
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButtonBlob(
              icon: const Icon(Icons.arrow_back_rounded, size: 28),
              onPressed: widget.onExit)),
      backgroundColor: kBackground,
      body: PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int page) {
            _tabController.index = page;
            setState(() => _curr = page);
          },
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const GradientBlob(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: <double>[
                          0.3,
                          0.7
                        ],
                        colors: <Color>[
                          kPoprockPrimary_2,
                          kPoprockPrimary_1
                        ]),
                    child: Icon(Icons.supervised_user_circle_rounded,
                        size: 78),
                  ),
                  const SizedBox(height: 14),
                  const Text("Lets get to know you",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: kStylizedFontFamily,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36),
                    child: Text(
                        "By providing accurate information, we can provide you with the most accurate data and insights.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(height: 54),
                  SPECIFIC_GradientIntrinsicButtonBlob(
                      text: "Next",
                      icon: Icons.keyboard_arrow_right_rounded,
                      onPressed: () => toPage(1))
                ]),
          ]),
    );
  }
}

class NewUser_WelcomePage extends StatelessWidget {
  const NewUser_WelcomePage({
    super.key,
    required int curr,
    required this.backdropWidthHeight,
  }) : _curr = curr;

  final int _curr;
  final double backdropWidthHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedOpacity(
      opacity: _curr == 0 ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const FadeInBlob(
                delay: 0,
                duration: Duration(milliseconds: 600),
                child: Text("Welcome to",
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.normal)),
              ),
              const SizedBox(height: 60),
              const SlideInBlob(
                  delay: 480,
                  child: GradientTextBlob(
                    "Mortality",
                    style: TextStyle(
                        fontFamily: kStylizedFontFamily,
                        fontSize: 68,
                        fontWeight: FontWeight.w800),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        stops: <double>[
                          0.35,
                          0.65
                        ],
                        colors: <Color>[
                          kPoprockPrimary_2,
                          kPoprockPrimary_1
                        ]),
                  )),
              const SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.sizeOf(context).width * 0.1),
                child: const SlideInBlob(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 800),
                    delay: 800,
                    startOffset: Offset(0, 0.9),
                    child: Text(
                        "Get a gentle reminder of how much time you probably have left, so you can finally prioritize... or procrastinate wisely",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal))),
              ),
            ]),
        Opacity(
          opacity: 0.1,
          child: Image(
              image: const AssetImage("assets/skull_backdrop.png"),
              width: backdropWidthHeight,
              height: backdropWidthHeight),
        ),
      ]),
    ));
  }
}

class NewUserPermissionsField extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<double> stops;
  final String description;
  final Alignment gradientStart;
  final Alignment gradientEnd;
  final bool invertColorPos;
  final int delay;
  const NewUserPermissionsField(
      {super.key,
      required this.icon,
      required this.gradientEnd,
      required this.gradientStart,
      required this.stops,
      this.invertColorPos = true,
      required this.delay,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return LazySlideInBlob(
      delay: delay,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientBlob(
            gradient: LinearGradient(
                begin: gradientStart,
                end: gradientEnd,
                stops: stops,
                colors: invertColorPos
                    ? const <Color>[
                        kPoprockPrimary_2,
                        kPoprockPrimary_1
                      ]
                    : const <Color>[
                        kPoprockPrimary_1,
                        kPoprockPrimary_2
                      ]),
            child: Icon(icon, size: 44, color: kForeground),
          ),
          const SizedBox(height: 6),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                      text: "$title\n",
                      style: const TextStyle(
                          fontFamily: kStylizedFontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: description,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                ]),
                textAlign: TextAlign.center,
              ))
        ],
      ),
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
            color: kForeground,
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
            selectedColor: kForeground,
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
                size: 38.0, color: kForeground),
          ),
        ],
      ),
    );
  }
}
