import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PopHabits extends StatelessWidget {
  const PopHabits({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Container(
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
      margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Explore',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.explore,
                    size: 22.0,
                  ),
                )
              ],
            ),
            // SizedBox(height: 30),
            // Expanded(
            //   child: GridView.count(
            //     crossAxisCount: 2,
            //     childAspectRatio: 1,
            //     crossAxisSpacing: 12,
            //     mainAxisSpacing: 12,
            //     children: <Widget>[
            //       CategoryCard(
            //         title: "Water",
            //         svgSrc: "assets/icons/Hamburger.svg",
            //         press: () {},
            //       ),
            //       CategoryCard(
            //         title: "Mindfulness",
            //         svgSrc: "assets/icons/Excrecises.svg",
            //         press: () {},
            //       ),
            //       CategoryCard(
            //         title: "Exercise",
            //         svgSrc: "assets/icons/Meditation.svg",
            //         press: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) {
            //               return DetailsScreen();
            //             }),
            //           );
            //         },
            //       ),
            //       CategoryCard(
            //         title: "Sleep",
            //         svgSrc: "assets/icons/yoga.svg",
            //         press: () {},
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }
}
