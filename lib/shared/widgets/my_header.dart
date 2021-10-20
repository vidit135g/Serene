import 'package:flutter/material.dart';
import '../../mainhabits/pages/ProgressMain.dart';
import '../../screens/Welcome/welcome_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../sunshine/components/day/sun.dart';
import '../../sunshine/components/day/sun_rays.dart';
import '../../sunshine/components/night/moon.dart';
import '../../sunshine/components/night/moon_rays.dart';
import '../../sunshine/components/toggle_button.dart';
import '../../sunshine/enums/mode.dart';
import '../../sunshine/models/login_theme.dart';
import '../../sunshine/utils/cached_images.dart';
import '../../sunshine/utils/viewport_size.dart';
import '../../utils/const.dart';

class MyHeader extends StatefulWidget {
  const MyHeader({Key key, String user})
      : _user = user,
        super(key: key);

  final String _user;

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader>
    with SingleTickerProviderStateMixin {
  String user;
  AnimationController _animationController;
  LoginTheme day;
  LoginTheme night;

  Mode _activeMode = Mode.day;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    user = widget._user;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward(from: 0.0);
    }); // wait for all the widget to render
    initializeTheme(); //initializing theme for day and night
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cacheImages();
    super.didChangeDependencies();
  }

  cacheImages() {
    CachedImages.imageAssets.forEach((asset) {
      precacheImage(asset, context);
    });
  }

  initializeTheme() {
    day = LoginTheme(
      title: 'Good Morning,',
      backgroundGradient: [
        const Color(0xFF8C2480),
        const Color(0xFFCE587D),
        const Color(0xFFFF9485),
        const Color(0xFFFF9D80),
        const Color(0xFFFFBD73),
      ],
      landscape: CachedImages.imageAssets[0],
      circle: Sun(
        controller: _animationController,
      ),
      rays: SunRays(
        controller: _animationController,
      ),
    );

    night = LoginTheme(
      title: 'Good Night,',
      backgroundGradient: [
        const Color(0xFF0D1441),
        const Color(0xFF283584),
        const Color(0xFF6384B2),
        const Color(0xFF6486B7),
      ],
      landscape: CachedImages.imageAssets[1],
      circle: Moon(
        controller: _animationController,
      ),
      rays: MoonRays(
        controller: _animationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ViewportSize.getSize(context);

    var names = user.split(' ');
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: 500,

        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _activeMode == Mode.day
                ? day.backgroundGradient
                : night.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // image: DecorationImage(
        //   fit: BoxFit.cover,
        //   alignment: Alignment.center,
        //   image: AssetImage("assets/images/selflo.jpg"),
        // ),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFfffFFFF),
        //     Color(0xFFfcdee5),
        //     Constants.lightYellow,
        //     Color(0xFfffFFFF),
        //     //Color(0xFFEAE8FE),
        //   ],
        // ),
        // image: DecorationImage(
        //   image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
        // ),

        child: Stack(
          alignment: Alignment.center,
          children: [
            // SizedBox(height: 10),
            // Padding(
            //   padding: EdgeInsets.only(right: 20),
            //   child: Text(
            //     "Make Your Journey More Productive.",
            //     style: GoogleFonts.nunito(
            //       color: Colors.black,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            Positioned(
              top: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     height: 52,
                  //     width: 52,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: SvgPicture.asset(
                  //       "assets/icons/menu.svg",
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Text(
                      "Welcome, " + names[0] + "!",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Make Your Journey More Productive.    ",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              width: height * 0.8,
              height: height * 0.8,
              bottom: _activeMode == Mode.day ? -300 : -50,
              child: _activeMode == Mode.day ? day.rays : night.rays,
            ),
            Positioned(
              bottom: _activeMode == Mode.day ? -160 : -80,
              child: _activeMode == Mode.day ? day.circle : night.circle,
            ),
            Positioned.fill(
              child: Image(
                image:
                    _activeMode == Mode.day ? day.landscape : night.landscape,
                fit: BoxFit.fill,
              ),
            ),

            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     alignment: Alignment.center,
            //     height: 52,
            //     width: 52,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //     ),
            //     child: SvgPicture.asset(
            //       "assets/icons/menu.svg",
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 80);
//     path.quadraticBezierTo(
//         size.width / 2, size.height, size.width, size.height - 80);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
