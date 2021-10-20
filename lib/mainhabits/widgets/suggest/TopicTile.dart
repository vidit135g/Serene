import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/Topics.dart';
import '../../pages/SelectHabit.dart';
import '../../../shared/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TopicTile extends StatelessWidget {
  final String topic;
  final String assetPath;
  TopicTile({this.topic, this.assetPath});

  Widget _backgroundImage() {
    return Hero(
      tag: assetPath,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1.0,
          widthFactor: 1.0,
          child: Image.asset(assetPath),
        ),
      ),
    );
  }

  Widget _title(context) {
    var _theme = Theme.of(context);
    return Hero(
      tag: topic,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          topic,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    var backgroundColor = _darkMode
        ? Theme.of(context).textTheme.subtitle2.color.withAlpha(35)
        : Theme.of(context).primaryColor.withAlpha(10);

    var borderColor = _darkMode
        ? Theme.of(context).textTheme.subtitle2.color.withAlpha(50)
        : Theme.of(context).primaryColor.withAlpha(_darkMode ? 200 : 50);

    var _border = BoxDecoration(
      border: Border.all(color: borderColor),
      color: backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );

    return InkWell(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: _border,
          child: Stack(
            children: [
              _backgroundImage(),
              _title(context),
            ],
          ),
        ),
        onTap: () => pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(
                name: "/suggest/habit",
                arguments: Topics(
                  title: this.topic,
                  assetPath: this.assetPath,
                ),
              ),
              screen: SelectHabit(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ));
  }
}
