import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  BasicTile({this.title, this.subtitle1, this.subtitle2});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;
    var titleStyle = _theme.textTheme.headline3.copyWith(color: accentColor);
    var subtitle1Style = _theme.textTheme.subtitle1;
    var subtitle2Style = _theme.textTheme.subtitle2;

    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle1,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle2,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
