import 'package:flutter/material.dart';
import '../../../google_sign_in_button.dart';
import 'FadeAnimation.dart';
import '../../../shared/colors.dart';
import '../../../shared/widgets/svg_label.dart';
import '../../../utils/authentication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';

class Body extends StatelessWidget {
  final tween = MultiTrackTween([
    Track("color1").add(
        Duration(seconds: 5),
        ColorTween(
            begin: const Color(0xFFFFBD73), end: CustomColors.backgroundGreen)),
    Track("color2").add(
        Duration(seconds: 5),
        ColorTween(
            begin: const Color(0xFF8C2480), end: CustomColors.backgroundGreen))
  ]);
  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        playback: Playback.MIRROR,
        tween: tween,
        duration: tween.duration,
        builder: (context, animation) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [animation["color1"], animation["color2"]])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      FadeAnimation(
                        2,
                        Text(
                          'Organize your life'.toUpperCase(),
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FadeAnimation(
                        2.5,
                        Text(
                          'Serene',
                          style: GoogleFonts.poppins(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: .9,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          2.7,
                          SizedBox(
                            width: 70,
                            height: 5,
                            child: Container(
                              color: CustomColors.backgroundGreen,
                            ),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      FadeAnimation(
                        3,
                        Text(
                          'Get the most out of your day,\nwe know the best habits.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FadeAnimation(
                        3.5,
                        Text(
                          'We will help you \nto keep the streak and\n never miss a habit.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 45),
                      FadeAnimation(
                          4,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgLabel(
                                      assetName: 'assets/svg/mountains.svg',
                                      label: 'Love \nyourself',
                                    ),
                                    SizedBox(width: 45),
                                    SvgLabel(
                                      assetName: 'assets/svg/money.svg',
                                      label: 'Bite-sized \nadvice',
                                    ),
                                    SizedBox(width: 45),
                                    SvgLabel(
                                      assetName: 'assets/svg/stars.svg',
                                      label: 'Insights & \nProgress',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      FadeAnimation(
                          4.5,
                          Container(
                            height: 60,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                                child: FutureBuilder(
                              future: Authentication.initializeFirebase(
                                  context: context),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error initializing Firebase');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GoogleSignInButton();
                                }
                                return GoogleSignInButton();
                              },
                            )),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        // Widget build(BuildContext context) {
        //   Size size = MediaQuery.of(context).size;
        //   // This size provide us total height and width of our screen
        //   return Background(
        //     child: SingleChildScrollView(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Text(
        //             "Lastly, save progress\n& secure your insights.",
        //             style: GoogleFonts.nunito(
        //               color: CustomColors.text,
        //               fontSize: 25,
        //               fontWeight: FontWeight.w500,
        //               height: 1.2,
        //             ),
        //           ),
        //           SizedBox(height: 20),
        //           SvgPicture.asset(
        //             "assets/icons/chat.svg",
        //             height: 400,
        //           ),
        //           SizedBox(height: size.height * 0.05),
        //           SizedBox(height: 50),
        //           FutureBuilder(
        //             future: Authentication.initializeFirebase(context: context),
        //             builder: (context, snapshot) {
        //               if (snapshot.hasError) {
        //                 return Text('Error initializing Firebase');
        //               } else if (snapshot.connectionState == ConnectionState.done) {
        //                 return GoogleSignInButton();
        //               }
        //               return CircularProgressIndicator(
        //                 valueColor: AlwaysStoppedAnimation<Color>(
        //                   CustomColors.backgroundGreen,
        //                 ),
        //               );
        //             },
        //           )
        //         ],
        //       ),
        //     ),
        //   );
        // }
        );
  }
}
