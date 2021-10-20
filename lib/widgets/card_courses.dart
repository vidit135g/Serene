import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCourses extends StatelessWidget {
  final Image image;
  final String title;
  final String hours;
  final String progress;
  final double percentage;
  final Color color;
  final Function press;
  CardCourses({
    Key key,
    @required this.image,
    @required this.title,
    @required this.hours,
    @required this.percentage,
    @required this.progress,
    @required this.color,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(30.0),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: color,
        ),
        child: InkWell(
          onTap: press,
          child: Row(
            children: <Widget>[
              image,
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      hours,
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    progress,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Constants.textDark,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
