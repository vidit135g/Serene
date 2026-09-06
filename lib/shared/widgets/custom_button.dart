import 'package:flutter/material.dart';
import '../colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.minWidth = 135.0,
    this.height = 62.0,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double minWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: CustomColors.backgroundGreen,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text.toString(),
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
