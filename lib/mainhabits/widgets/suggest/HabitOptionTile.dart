import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/TopicHabits.dart';
import '../../pages/NewHabit.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HabitOptionTile extends StatelessWidget {
  final TopicHabits option;
  HabitOptionTile({this.option});

  @override
  Widget build(BuildContext context) {
    var _displayString =
        option.repeat == null ? 'Everyday' : option.repeat.displayString2();

    return option.isYNType
        ? ListTile(
            leading: FaIcon(option.icon, size: 36),
            title: Text(
              option.title,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: _displayString == null || _displayString == ''
                ? Text(
                    '',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : Text(
                    _displayString,
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
            onTap: () => pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: "/new", arguments: option),
                  screen: NewHabit(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ))
        : ListTile(
            leading: FaIcon(option.icon, size: 36),
            title: Text(
              option.title,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "${option.timesTarget} ${option.timesTargetType} $_displayString",
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            onTap: () => pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: "/new", arguments: option),
                  screen: NewHabit(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ));
  }
}
