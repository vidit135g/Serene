import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../data/HabitMasterService.dart';
import '../domain/Habit.dart';
import 'EditHabit.dart';
import 'TodayView.dart';
import '../widgets/hprogress/HabitCompletionRate.dart';
import '../widgets/hprogress/HabitHeatMap.dart';
import '../widgets/hprogress/HabitStatusSummary.dart';
import '../widgets/hprogress/HabitStreaks.dart';
import '../../shared/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

enum HabitOptions { edit, delete }

class HabitProgress extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  @override
  _HabitProgressState createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  final int index = 1;
  var loading = false;

  AppBar _appBar(BuildContext context, Habit habit) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var accentColor = _theme.accentColor;

    return new AppBar(
      automaticallyImplyLeading: true,
      toolbarHeight: 80,
      backgroundColor: _theme.scaffoldBackgroundColor,
      iconTheme: IconThemeData(color: accentColor),
      title: Hero(
        tag: 'habit-title-' + habit.id.toString(),
        child: Text(
          habit.title,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      actions: [
        loading
            ? IconButton(
                icon: CircularProgressIndicator(),
                color: CustomColors.darkhabit,
                onPressed: null,
              )
            : PopupMenuButton<HabitOptions>(
                onSelected: (HabitOptions result) {
                  if (result == HabitOptions.delete) {
                    setState(() {
                      loading = true;
                    });
                    widget.habitMaster.deleteHabit(habit.id).then(
                          (value) => Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (BuildContext context) {
                                return TodayView();
                              },
                            ),
                            (_) => false,
                          ),
                        );
                  } else if (result == HabitOptions.edit) {
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: "/edit", arguments: habit),
                      screen: EditHabit(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<HabitOptions>>[
                  const PopupMenuItem<HabitOptions>(
                    value: HabitOptions.edit,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<HabitOptions>(
                    value: HabitOptions.delete,
                    child: Text('Delete'),
                  ),
                ],
              )
      ],
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    final Habit habit = ModalRoute.of(context).settings.arguments;

    var _widgetList = <Widget>[
      HabitStatusSummary(habit: habit),
      HabitCompletionRate(habit: habit),
      HabitStreaks(habit: habit),
      HabitHeatMap(habit: habit),
    ];

    return new Scaffold(
      appBar: _appBar(context, habit),
      body: Container(
        color: _darkMode ? Colors.black : Colors.grey.withOpacity(0.05),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: _widgetList.length,
              itemBuilder: (context, index, anim) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(child: _widgetList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
