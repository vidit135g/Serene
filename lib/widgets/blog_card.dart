import 'package:flutter/material.dart';
import '../constants.dart';
import '../shared/colors.dart';
import '../shared/widgets/my_header.dart';
import 'category_sub.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.topCenter,
        padding: new EdgeInsets.only(top: 60, right: 20.0, left: 20.0),
        child: new Container(
          height: 350,
          // Here the height of the container is 45% of our total height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 17,
                spreadRadius: -23,
                color: kShadowColor,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: SubClipper(),
                  child: Container(
                    width: double.maxFinite,
                    // Here the height of the container is 45% of our total height
                    height: 140,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        image:
                            AssetImage("assets/images/undraw_pilates_gpdb.png"),
                      ),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 1),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.wb_sunny,
                              size: 16,
                              color: CustomColors.backgroundGreen,
                            ),
                          ),
                          TextSpan(
                            text: " Daily Journal",
                            style: GoogleFonts.nunito(
                              color: CustomColors.backgroundGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                    // Text(
                    //   "Good Morning, Jai!",
                    //   style: GoogleFonts.nunito(
                    //     color: Colors.black,
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(right: 1),
                  child: Text(
                    "How are you feeling today?",
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SubCard(
                        title: "Great",
                        svgSrc: "assets/images/great.svg",
                        accent: CustomColors.backgroundGreen,
                        press: () {},
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      SubCard(
                        title: "Good",
                        svgSrc: "assets/images/good.svg",
                        accent: CustomColors.backgroundGreen,
                        press: () {},
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      SubCard(
                        title: "Okay",
                        svgSrc: "assets/images/okay.svg",
                        accent: CustomColors.backgroundGreen,
                        press: () {},
                      ),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SubCard(
                        title: "Not Great",
                        svgSrc: "assets/images/notokay.svg",
                        accent: CustomColors.backgroundGreen,
                        press: () {},
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      SubCard(
                        title: "Bad",
                        svgSrc: "assets/images/sad.svg",
                        accent: CustomColors.backgroundGreen,
                        press: () {},
                      ),
                    ])
              ],
            ),
          ),
        ));
  }
}

class SubClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
