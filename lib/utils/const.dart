import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/colors.dart';

class Constants {
  // Name
  static String appName = "e-Learning";

  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = CustomColors.backgroundGreen;
  static Color lightBackground = Color(0xfffcfcff);

  static Color grey = Color(0xff707070);
  static Color textPrimary = CustomColors.backgroundGreen;
  static Color textDark = CustomColors.backgroundGreen;

  // Salmon
  static Color salmonMain = Color(0xFFF18C8E);
  static Color salmonDark = Color(0xFFBB7F87);
  static Color salmonLight = Color(0xFFF19895);

  // Blue

  static Color blueMain = CustomColors.backgroundGreen;
  static Color blueDark = CustomColors.backgroundGreen;
  static Color blueLight = CustomColors.backgroundGreen;

  // Pink
  static Color lightPink = Color(0xFFFAE4F4);

  // Yellow
  static Color lightYellow = Color(0xFFFFF5E5);

  // Violet
  static Color lightViolet = Color(0xFFFBF5FF);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: CustomColors.backgroundGreen,
      cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double mainPadding = 20.0;
}
