import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'screens/primaryscreen.dart';
import 'shared/colors.dart';
import 'utils/authentication.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 270,
        height: 60,
        child: _isSigningIn
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 173, 173, 242)),
              )
            : RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User user =
                      await Authentication.signInWithGoogle(context: context);

                  setState(() {
                    _isSigningIn = false;
                  });

                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PrimaryScreen(
                          user: user,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // child: Text(
                //   "Sigin with Google",
                //   style: GoogleFonts.nunito(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.w800,
                //   ),
                // ),
              ));
  }
}
