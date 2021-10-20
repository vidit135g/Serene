import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/Topics.dart';
import 'NewHabit.dart';
import '../widgets/suggest/TopicTile.dart';
import '../../shared/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SelectTopic extends StatelessWidget {
  AppBar _getAppBar(context) {
    return AppBar(
      toolbarHeight: 80,
      title: Text(
        "Create New Habit",
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _getFab(context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: RaisedButton.icon(
          padding: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          color: CustomColors.darkhabit,
          label: Text(
            'Custom',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: Icon(
            Icons.create,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: '/new'),
                screen: NewHabit(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    final topics = <Topics>[
      Topics(
        title: "Popular",
        assetPath: 'assets/topics/light/DoogieDoodle.png',
      ),
      Topics(
        title: "Get Fit",
        assetPath: 'assets/topics/light/MeditatingDoodle.png',
      ),
      Topics(
        title: "Stay Healthy",
        assetPath: 'assets/topics/light/StrollingDoodle.png',
      ),
      Topics(
        title: "Watch Your Diet",
        assetPath: 'assets/topics/light/IceCreamDoodle.png',
      ),
      Topics(
        title: "Have a Hobby",
        assetPath: 'assets/topics/light/ReadingDoodle.png',
      ),
      Topics(
        title: "Others",
        assetPath: 'assets/topics/light/SwingingDoodle.png',
      ),
    ];

    var widgets = topics
        .map(
          (t) => TopicTile(
            topic: t.title,
            assetPath: t.assetPath,
          ),
        )
        .toList();

    return new Scaffold(
      appBar: _getAppBar(context),
      body: GridView.count(
        crossAxisCount: 2,
        children: widgets,
        padding: EdgeInsets.all(12),
      ),
      floatingActionButton: _getFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
