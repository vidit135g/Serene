import 'package:flutter/material.dart';
import '../shared/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleCard extends StatelessWidget {
  final Image image;
  final String title;
  const StyleCard({
    Key key,
    this.image,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: image,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: GoogleFonts.nunito(
                color: CustomColors.backgroundGreen,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
