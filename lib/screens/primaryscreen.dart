import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../mainhabits/pages/ProgressMain.dart';
import '../mainhabits/pages/Settings.dart';
import '../mainhabits/pages/TodayView.dart';
import 'blog_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../shared/colors.dart';
import '../utils/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  User _user;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 86.4,
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      MainScreen(
        user: _user.displayName,
        photo: _user.photoURL,
      ),
      BlogScreen(),
      TodayView(),
      ProgressMain(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: new SvgPicture.asset('assets/svg/icon_home.svg'),
        title: ("Home"),
        activeColorPrimary: const Color(0xFFCE587D),
        inactiveColorPrimary: CupertinoColors.systemGrey,
        //inactiveIcon: new SvgPicture.asset('assets/svg/icon_home.svg'),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: new SvgPicture.asset('assets/svg/icon_heart.svg'),
        inactiveIcon: new SvgPicture.asset('assets/svg/icon_heart.svg'),
        title: ("Blogs"),
        activeColorPrimary: Color.fromARGB(255, 173, 173, 242),
        //inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: new SvgPicture.asset('assets/svg/icon_plus.svg'),
        title: ("Habits"),
        inactiveIcon: new SvgPicture.asset('assets/svg/icon_plus.svg'),
        activeColorPrimary: Color(0xFfecae4b),
        // inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: new SvgPicture.asset('assets/svg/icon_notification.svg'),
        inactiveIcon: new SvgPicture.asset('assets/svg/icon_notification.svg'),
        title: ("Stats"),
        activeColorPrimary: Color.fromARGB(255, 219, 68, 55),
        // inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: new SvgPicture.asset('assets/svg/icon_user.svg'),
        //inactiveIcon: new SvgPicture.asset('assets/svg/icon_user.svg'),
        title: ("Misc"),
        activeColorPrimary: Colors.black,
        //inactiveColorPrimary: CupertinoColors.systemGrey,
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    ];
  }
}
