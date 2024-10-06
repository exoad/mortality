import "package:calendar_date_picker2/calendar_date_picker2.dart";
import "package:flutter/material.dart";
import "package:mortality_app/core/user_profile_data.dart";
import "package:mortality_app/debug.dart";
import "package:mortality_app/parts/blobs/fade_blob.dart";
import "package:mortality_app/parts/blobs/gesture_action_blob.dart";
import "package:mortality_app/parts/blobs/gradient_blob.dart";
import "package:mortality_app/parts/blobs/lazy_show_up_blob.dart";
import "package:mortality_app/parts/blobs/show_up_blob.dart";
import "package:mortality_app/shared.dart";
import "package:oktoast/oktoast.dart";
import "package:segmented_button_slide/segmented_button_slide.dart";

class NewUserFormPart extends StatelessWidget {
  final Widget child;

  const NewUserFormPart({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kBackground, body: ScrollingUserGuide(child: child)),
    );
  }
}

class ScrollingUserGuide extends StatefulWidget {
  final Widget child;

  const ScrollingUserGuide({super.key, required this.child});

  @override
  State<ScrollingUserGuide> createState() => _ScrollingUserGuideState();
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
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          controller: _pageController,
          onPageChanged: (int page) {
            _tabController.index = page;
            setState(() => _curr = page);
          },
          children: <Widget>[
            NewUser_WelcomePage(
                curr: _curr, backdropWidthHeight: backdropWidthHeight),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text("Permissions",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 56, fontWeight: FontWeight.normal)),
                      const SizedBox(height: 26),
                      const Divider(color: kTertiary),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
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
                                icon: Icons.notifications_active_rounded,
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
                            const SizedBox(height: 26),
                            if (!_permsGranted)
                              LazySlideInBlob(
                                  delay: 1000,
                                  startOffset: const Offset(0, 0.2),
                                  child: TextButtonBlob.primary(
                                    "Grant and Personalize",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    onPressed: () async {
                                      Debug().info(
                                          "Launch permission grant and personalize page");
                                      await Navigator.of(context).push(
                                          MaterialPageRoute<Widget>(
                                              builder: (BuildContext context) =>
                                                  PersonalizationPage(
                                                      onExit: () {
                                                    _pageController
                                                        .animateToPage(
                                                      2,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                    setState(() {
                                                      _permsGranted = true;
                                                      _curr = 2;
                                                    });
                                                    Navigator.of(context).pop();
                                                  })));
                                    },
                                  )),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ]),
              ),
            ),
            const AppDisclaimerPage()
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 26),
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
                        Icon(Icons.touch_app_rounded,
                            size: 20, color: kForeground),
                        SizedBox(width: 8),
                        Text("Tap the arrows to navigate",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ScrollerWidget(
                  currentPageIndex: _curr,
                  tabController: _tabController,
                  onUpdateCurrentPageIndex: (/* page == next page */ int page) {
                    Debug().info("NEW_USER_WELCOME_PAGE page update $page");
                    if (!_permsGranted && page == 2) {
                      showToastWidget(
                          Center(
                            child: Container(
                              width: 180,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: kBackground,
                                  borderRadius:
                                      BorderRadius.circular(kRRectArc),
                                  border: Border.all(color: kForeground)),
                              child: const Center(
                                child: Text("Please grant permissions",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kForeground, fontSize: 16)),
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
        ),
      ],
    );
  }
}

class _AppDisclaimerPage_FeatureField extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const _AppDisclaimerPage_FeatureField(
      {required this.title, required this.icon, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GradientBlob(
                    gradient: const LinearGradient(
                        colors: <Color>[kPoprockPrimary_1, kPoprockPrimary_2],
                        stops: <double>[0.3, 0.7]),
                    child: Icon(icon, size: 36)),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kPoprockPrimary_2))
              ]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          )
        ]);
  }
}

class AppDisclaimerPage extends StatelessWidget {
  const AppDisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 54),
                    const Text("The clock is ticking...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          shadows: <BoxShadow>[
                            BoxShadow(
                                blurRadius: 16,
                                spreadRadius: 16,
                                offset: Offset(-20, -20),
                                color: kPoprockPrimary_1),
                            BoxShadow(
                                blurRadius: 16,
                                spreadRadius: 16,
                                offset: Offset(20, 20),
                                color: kPoprockPrimary_2),
                            BoxShadow(
                                blurRadius: 24,
                                spreadRadius: 16,
                                offset: Offset(-20, 20),
                                color: kPoprockPrimary_1),
                            BoxShadow(
                                blurRadius: 24,
                                spreadRadius: 16,
                                offset: Offset(20, -20),
                                color: kPoprockPrimary_2)
                          ],
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 23),
                    const Divider(),
                    const SizedBox(height: 23),
                    const Text("Onboarding",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 23),
                    const _AppDisclaimerPage_FeatureField(
                        title: "Interactive Time Visualizer",
                        icon: Icons.interests_rounded,
                        description:
                            "Explore your mortality through an intuitive interface that lets you zoom in on years, months, days, and even hours—right at your fingertips."),
                    const SizedBox(height: 30),
                    const _AppDisclaimerPage_FeatureField(
                        title: "Personalized Reminders",
                        icon: Icons.notification_important_rounded,
                        description:
                            "Receive timely reminders that highlight what you’ve experienced and what remains, helping you focus on what truly matters—or perhaps what you’d prefer to delay."),
                    const SizedBox(height: 30),
                    const _AppDisclaimerPage_FeatureField(
                        title: "Daily & Weekly Reflections",
                        icon: Icons.note_alt_rounded,
                        description:
                            "Document your daily activities and emotions, and visualize your experiences over time to gain insight into your journey."),
                    const SizedBox(height: 16),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.swipe_down_rounded),
                          SizedBox(width: 8),
                          Text("Swipe down to continue")
                        ]),
                    const SizedBox(height: 22),
                    const Divider(),
                    const SizedBox(height: 22),
                    const ExpansionTile(
                        initiallyExpanded: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Row(children: <Widget>[
                          Icon(Icons.info_outline_rounded, color: kForeground),
                          SizedBox(width: 10),
                          Text("Disclaimers",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        subtitle: Text("Please review carefully",
                            style: TextStyle(
                                fontSize: 14,
                                color: kTertiary,
                                fontWeight: FontWeight.w300)),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Text.rich(
                                TextSpan(children: <InlineSpan>[
                                  TextSpan(
                                      text: "This app is intended solely for ",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  TextSpan(
                                    text:
                                        "entertainment and visualization purposes. ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  TextSpan(
                                    text:
                                        "The life expectancy estimates, projections, and other content presented are based on average life expectancy data from reputable research and scientific sources. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "These projections are speculative and should not be considered accurate, reliable, or applicable to individual circumstances.\n\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "1) Not Medical or Professional Advice\n\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  TextSpan(
                                    text:
                                        "Life expectancy is affected by numerous factors, many of which are unpredictable and not fully accounted for by this app. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "The information provided does not constitute medical, health, or professional advice. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "For any health-related concerns or accurate life assessments, always consult a licensed medical professional or healthcare provider.\n\n",
                                  ),
                                  TextSpan(
                                    text: "2) User Responsibility\n\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  TextSpan(
                                    text:
                                        "By using this app, you acknowledge and agree that all decisions and actions based on the app’s content are made at your own discretion and risk. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "The creators and developers of this app do not guarantee the accuracy, completeness, or reliability of any information provided, ",
                                  ),
                                  TextSpan(
                                    text:
                                        "and expressly disclaim any liability for decisions or actions taken by users based on the app’s output.\n\n",
                                  ),
                                  TextSpan(
                                    text: "3) No Personal Data Collection\n\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  TextSpan(
                                    text:
                                        "This app does not collect, store, or share any personal health or medical data. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "Any information you provide is used solely for the app’s intended functionality and remains anonymous. ",
                                  ),
                                  TextSpan(
                                    text:
                                        "We are committed to protecting your privacy and do not share data with third parties.\n\n",
                                  ),
                                  TextSpan(
                                    text: "4) Limitation of Liability\n\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  TextSpan(
                                    text:
                                        "By using this app, you agree that the developers and creators are ",
                                  ),
                                  TextSpan(
                                    text:
                                        "not liable for any direct, indirect, incidental, or consequential damages ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        "resulting from the use or misuse of the app. This includes, but is not limited to, emotional distress, reliance on app-generated projections, or any other adverse outcomes.",
                                  ),
                                ]),
                                style: TextStyle(fontSize: 14)),
                          )
                        ]),
                    const SizedBox(height: 14),
                    const ExpansionTile(
                        title: Row(children: <Widget>[
                          Icon(Icons.gavel_rounded, color: kForeground),
                          SizedBox(width: 10),
                          Text("Copyright & License",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ]),
                        subtitle: Text("Please review carefully"),
                        controlAffinity: ListTileControlAffinity.leading,
                        initiallyExpanded: false,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Text.rich(
                                TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "Copyright (c) 2024, Jiaming (Jack) Meng. All rights reserved.\n\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "3. All advertising materials mentioning features or use of this software must display the following acknowledgment: This product includes software developed by Jiaming (Jack) Meng.\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "4. Neither the name of Jiaming (Jack) Meng nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "THIS SOFTWARE IS PROVIDED BY JIAMING (JACK) MENG \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JIAMING (JACK) MENG BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.",
                                  ),
                                ]),
                                style: TextStyle(fontSize: 14)),
                          )
                        ]),
                    const SizedBox(height: 34),
                    TextButtonBlob("Continue",
                        isDense: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22), onPressed: () {
                      Debug().info(
                          "NewUserForm DONE, switching back to [HomeView]");
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                              builder: (BuildContext context2) => context
                                  .findAncestorWidgetOfExactType<
                                      NewUserFormPart>()!
                                  .child));
                    }),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 38, vertical: 10),
                      child: Text(
                          "By clicking \"Continue,\" you acknowledge that you have read and understood the disclaimers and license agreement regarding the app's purpose and use.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300)),
                    ),
                    const SizedBox(height: 154) // DO NOT REMOVE, THIS IS BUMPER
                  ]),
            )),
      ),
    );
  }
}

class PersonalizationPage extends StatefulWidget {
  final void Function() onExit;

  const PersonalizationPage({super.key, required this.onExit});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _curr;

  _PersonalizationPageState() : _curr = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            Debug().info("PersonalizationPage page update $page");
            setState(() => _curr = page);
          },
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            PersonalizationPage_StartingPage(pageController: _pageController),
            PersonalizationPage_EnterName(pageController: _pageController),
            PersonalizationPage_SelectSex(pageController: _pageController),
            PersonalizationPage_EnterBDay(pageController: _pageController),
            PersonalizationPage_EndingPage(widget: widget)
          ]),
    );
  }
}

class PersonalizationPage_EndingPage extends StatelessWidget {
  const PersonalizationPage_EndingPage({
    super.key,
    required this.widget,
  });

  final PersonalizationPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const GradientBlob(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: <double>[0.2, 0.8],
                colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
            child: Icon(Icons.done_all_rounded, size: 80),
          ),
          const SizedBox(height: 22),
          const Text.rich(
            TextSpan(
                text: "Thank you.\n",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                children: <InlineSpan>[
                  TextSpan(
                      text: "You are almost at the countdown...",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic))
                ]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SPECIFIC_GradientIntrinsicButtonBlob(
              text: "Next",
              icon: Icons.keyboard_arrow_right_rounded,
              onPressed: widget.onExit)
        ]);
  }
}

class PersonalizationPage_SelectSex extends StatelessWidget {
  const PersonalizationPage_SelectSex({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const GradientBlob(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                stops: <double>[0.4, 0.6],
                colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
            child: Icon(Icons.wc_rounded, size: 80),
          ),
          const SizedBox(height: 14),
          const Text("What's your sex?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: kStylizedFontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
              "We will use this to provide you with\nmore accurate data.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          const SizedBox(height: 40),
          const SelectSexSegmentedButton(),
          const SizedBox(height: 54),
          SPECIFIC_GradientIntrinsicButtonBlob(
              text: "Next",
              icon: Icons.keyboard_arrow_right_rounded,
              onPressed: () => _pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ))
        ]);
  }
}

class SelectSexSegmentedButton extends StatefulWidget {
  const SelectSexSegmentedButton({super.key});

  @override
  State<SelectSexSegmentedButton> createState() =>
      _SelectSexSegmentedButtonState();
}

class _SelectSexSegmentedButtonState extends State<SelectSexSegmentedButton> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 100,
      child: SegmentedButtonSlide(
          selectedEntry: _selected,
          onChange: (int index) {
            setState(() => _selected = index);
          },
          borderRadius: BorderRadius.circular(kRRectArc),
          entries: const <SegmentedButtonSlideEntry>[
            SegmentedButtonSlideEntry(
                icon: Icons.female_rounded, label: "Female"),
            SegmentedButtonSlideEntry(icon: Icons.male_rounded, label: "Male")
          ],
          margin: const EdgeInsets.symmetric(horizontal: 20),
          selectedTextStyle: const TextStyle(
              color: kBackground, fontSize: 18, fontWeight: FontWeight.bold),
          unselectedTextStyle: const TextStyle(
              color: kForeground, fontSize: 18, fontWeight: FontWeight.normal),
          colors: SegmentedButtonSlideColors(
              backgroundSelectedColor: _selected == 0
                  ? const Color.fromARGB(255, 255, 59, 124)
                  : const Color.fromARGB(255, 68, 171, 255),
              barColor: kBackground)),
    );
  }
}

class PersonalizationPage_EnterBDay extends StatelessWidget {
  const PersonalizationPage_EnterBDay({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const GradientBlob(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: <double>[0.3, 0.7],
                colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
            child: Icon(Icons.cake_rounded, size: 80),
          ),
          const SizedBox(height: 14),
          const Text("When is your birthday?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: kStylizedFontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("We will use this to base our calculations on.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          const SizedBox(height: 20),
          const EnterBDay_CalendarWidget(),
          const SizedBox(height: 14),
          SPECIFIC_GradientIntrinsicButtonBlob(
              text: "Next",
              icon: Icons.keyboard_arrow_right_rounded,
              onPressed: () => _pageController.animateToPage(
                    4,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ))
        ]);
  }
}

class EnterBDay_CalendarWidget extends StatefulWidget {
  const EnterBDay_CalendarWidget({
    super.key,
  });

  @override
  State<EnterBDay_CalendarWidget> createState() =>
      _EnterBDay_CalendarWidgetState();
}

class _EnterBDay_CalendarWidgetState extends State<EnterBDay_CalendarWidget> {
  late DateTime selected;

  @override
  void initState() {
    super.initState();
    selected = DateTime.now().subtract(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2WithActionButtonsConfig(
              hideMonthPickerDividers: true,
              hideScrollViewTopHeaderDivider: true,
              hideYearPickerDividers: true,
              selectedDayHighlightColor: kForeground,
              scrollViewTopHeaderTextStyle: const TextStyle(
                color: kPoprockPrimary_1,
                fontSize: 18,
                fontFamily: kStylizedFontFamily,
                fontWeight: FontWeight.bold,
              ),
              selectedYearTextStyle: const TextStyle(
                  color: kBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              selectedMonthTextStyle: const TextStyle(
                  color: kBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              selectedDayTextStyle: const TextStyle(
                  color: kBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              yearTextStyle: const TextStyle(
                  color: kForeground,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
              monthTextStyle: const TextStyle(
                  color: kForeground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              daySplashColor: Colors.transparent,
              dayTextStyle: const TextStyle(color: kForeground, fontSize: 16),
              calendarType: CalendarDatePicker2Type.single,
              currentDate: selected,
              lastDate: DateTime.now(),
              firstDate: DateTime(1900),
              disableModePicker: false),
          value: <DateTime>[selected],
          onValueChanged: (List<DateTime> newDate) {
            Debug().info("EnterBDay_CalendarWidget: Selected= $newDate");
            setState(() => selected = newDate[0]);
          },
        ));
  }
}

class PersonalizationPage_EnterName extends StatelessWidget {
  const PersonalizationPage_EnterName({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const GradientBlob(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.centerRight,
                stops: <double>[0.4, 0.6],
                colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
            child: Icon(Icons.person_pin_rounded, size: 80),
          ),
          const SizedBox(height: 14),
          const Text("What's your name?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: kStylizedFontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("We will address you using this name",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          const SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.76,
            child: TextFormField(
                maxLines: 1,
                minLines: 1,
                maxLength: kMaxCharsUserName,
                keyboardAppearance: Brightness.dark,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        fontFamily: kDefaultFontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    hintText: UserProfileDefaults.defaultName)),
          ),
          const SizedBox(height: 54),
          SPECIFIC_GradientIntrinsicButtonBlob(
              text: "Next",
              icon: Icons.keyboard_arrow_right_rounded,
              onPressed: () => _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ))
        ]);
  }
}

class PersonalizationPage_StartingPage extends StatelessWidget {
  const PersonalizationPage_StartingPage({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const GradientBlob(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: <double>[0.3, 0.7],
                colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
            child: Icon(Icons.supervised_user_circle_rounded, size: 78),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          ),
          const SizedBox(height: 54),
          SPECIFIC_GradientIntrinsicButtonBlob(
              text: "Next",
              icon: Icons.keyboard_arrow_right_rounded,
              onPressed: () => _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ))
        ]);
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
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          const FadeInBlob(
            delay: 0,
            duration: Duration(milliseconds: 600),
            child: Text("Welcome to",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal)),
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
                    stops: <double>[0.35, 0.65],
                    colors: <Color>[kPoprockPrimary_2, kPoprockPrimary_1]),
              )),
          const SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.1),
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
                    ? const <Color>[kPoprockPrimary_2, kPoprockPrimary_1]
                    : const <Color>[kPoprockPrimary_1, kPoprockPrimary_2]),
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
                          fontSize: 14, fontWeight: FontWeight.normal)),
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
    return Row(
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
    );
  }
}
