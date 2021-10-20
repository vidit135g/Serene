import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/Welcome/welcome_screen.dart';
import '../shared/colors.dart';
import '../utils/authentication.dart';
import '../utils/const.dart';

class CustomDialogBox extends StatefulWidget {
  final String title;
  final String img;

  const CustomDialogBox({Key key, this.title, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    var names = widget.title.split(' ');
    bool _isSigningOut = false;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 50, right: 20, bottom: 50),
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: AssetImage("assets/images/dialog.jpg")),
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //       color: Color(0xFFEAE8FE),
            //       offset: Offset(0, 5),
            //       blurRadius: 5),
            // ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                names[0],
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "\"The mind is everything. What you think you become. - Buddha\"",
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 55,
              ),
              _isSigningOut
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              CustomColors.backgroundGreen),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFfcdee5)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut(context: context);
                        setState(() {
                          _isSigningOut = false;
                        });
                        Navigator.pop(context, true);
                        Navigator.of(context)
                            .pushReplacement(_routeToSignInScreen());
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
            ],
          ),
        ),
        Positioned(
            left: 50,
            right: 50,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 32,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Image.network(widget.img)),
              ),
            )),
      ],
    );
  }
}
