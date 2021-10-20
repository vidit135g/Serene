import 'package:flutter/material.dart';
import '../../screens/Welcome/welcome_screen.dart';
import '../colors.dart';
import '../../stories/whatsapp.dart';
import '../../widgets/category_sub.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogHeader extends StatelessWidget {
  const BlogHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 4, right: 12),
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            image: AssetImage("assets/images/peace.jpg"),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC2AB),
              Color(0xFFFFEEE9),
              Color(0xFfffe0c2),
            ],
          ),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Text('Featured',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "Different ways to get \nthrough a difficult day.",
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Container(
                    height: 40.0,
                    padding: EdgeInsets.only(left: 20.0),
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      color: Colors.white,
                      label: Text(
                        'Start',
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Whatsapp(
                                    index: 3,
                                  )),
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
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
