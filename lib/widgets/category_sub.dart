import 'package:flutter/material.dart';
import '../constants.dart';
import '../shared/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Color accent;
  final Function press;
  const SubCard({
    Key key,
    this.svgSrc,
    this.title,
    this.press,
    this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            svgSrc,
            height: 20,
            width: 20,
          ),
          SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
