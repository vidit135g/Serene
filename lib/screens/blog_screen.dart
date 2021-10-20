import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import '../mainhabits/pages/Settings.dart';
import '../shared/colors.dart';
import '../shared/widgets/blog_jumbo.dart';
import '../shared/widgets/my_header.dart';
import '../stories/whatsapp.dart';
import '../utils/const.dart';
import '../widgets/blog_card.dart';
import '../widgets/card_courses.dart';
import '../widgets/header.dart';
import '../widgets/instastories.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final TextEditingController _searchControl = new TextEditingController();
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchControl.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _selectedNavIndex = 1;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Journals",
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: new EdgeInsets.symmetric(
                        horizontal: Constants.mainPadding,
                        vertical: Constants.mainPadding),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              BlogHeader(),

              // 2. Search Textfield

              // 3. Start Learning Button Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 22),
                  child: Text(
                    "Popular articles",
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  )),

              SizedBox(height: 20.0),

              // List of courses
              Padding(
                padding: EdgeInsets.all(15),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    CardCourses(
                      image: Image.asset("assets/images/icon_1.png",
                          width: 40, height: 40),
                      color: Constants.lightPink,
                      title: "Mental Health",
                      hours: "Powerful mental health quotes and illustrations.",
                      progress: " ",
                      percentage: 0.25,
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Whatsapp(
                                    index: 0,
                                  )),
                        );
                      },
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/calm.png",
                          width: 40, height: 40),
                      color: CustomColors.backgroundGreen,
                      title: "Calm",
                      hours:
                          "Download the number one app for sleep and meditation.",
                      progress: " ",
                      percentage: 0.75,
                      press: () {
                        openBrowserTab("https://www.calm.com/");
                      },
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/icon_2.png",
                          width: 40, height: 40),
                      color: Constants.lightYellow,
                      title: "Self love",
                      hours: "Stop underestimating yourself.",
                      progress: " ",
                      percentage: 0.5,
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Whatsapp(
                                    index: 1,
                                  )),
                        );
                      },
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/icon_3.png",
                          width: 40, height: 40),
                      color: Color(0xFfffe0c2),
                      title: "Inspirational",
                      hours:
                          "Quotes to motivate you to reflect on the past and start fresh and inspired.",
                      progress: " ",
                      percentage: 0.75,
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Whatsapp(
                                    index: 2,
                                  )),
                        );
                      },
                    ),
                    CardCourses(
                      image: Image.asset("assets/images/missm.png",
                          width: 60, height: 60),
                      color: Constants.lightPink,
                      title: "Miss Mental",
                      hours: "Tap to read more on the website.",
                      progress: " ",
                      percentage: 0.75,
                      press: () {
                        openBrowserTab("https://miss-mental.com/");
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  openBrowserTab(String link) {
    FlutterWebBrowser.openWebPage(
      url: link,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: Colors.deepPurple,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.amber,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
