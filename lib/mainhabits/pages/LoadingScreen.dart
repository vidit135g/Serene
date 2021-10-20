import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _textTheme = Theme.of(context).textTheme;

    return new MaterialApp(
      home: Center(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/app-logo.png',
                  width: 250,
                  height: 250,
                ),
                Text(
                  'Serene',
                  style: GoogleFonts.poppins(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: .9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
