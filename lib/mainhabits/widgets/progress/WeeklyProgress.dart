import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/ProgressStatsService.dart';
import '../../domain/Habit.dart';
import '../../pages/HabitProgress.dart';
import '../../../shared/colors.dart';
import '../../../utils/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class WeeklyProgress extends StatefulWidget {
  //
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _WeeklyProgressState createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress> {
  List<Habit> weeklyData = List();
  var weeksProgress = 0;
  var weeksTarget = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //
    _loadData();
  }

  void _loadData() {
    var sum = (int a, int b) => a + b;
    widget.statsService
        .getWeeklyProgressData()
        .then(
          (value) => {
            if (mounted)
              setState(() {
                weeklyData = value;
                weeksProgress =
                    weeklyData.map((e) => e.timesProgress).reduce(sum);
                weeksTarget = weeklyData.map((e) => e.timesTarget).reduce(sum);
                loading = false;
              })
          },
        )
        .whenComplete(() => {
              if (mounted)
                setState(() {
                  loading = false;
                })
            });
  }

  ListTile _weeklyTile(BuildContext context, Habit data) {
    var _theme = Theme.of(context);
    return ListTile(
      leading: CircularProgressIndicator(
        color: Color(0xFFc74e55),
        backgroundColor: Color(0xFFfbeae0),
        value: data.timesProgress / data.timesTarget,
      ),
      title: Row(
        children: <Widget>[
          Text(
            data.title,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Spacer(),
          Text(
            data.timesProgress.toString(),
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text('/'),
          Text(
            data.timesTarget.toString(),
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => pushNewScreenWithRouteSettings(
        context,
        settings: RouteSettings(name: '/habit/progress', arguments: data),
        screen: HabitProgress(),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    //
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'This Week',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        dense: true,
        trailing: loading
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
                child: CircularProgressIndicator(
                  color: Color(0xFFc74e55),
                  backgroundColor: Color(0xFFfbeae0),
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 50),
                child: LinearProgressIndicator(
                  value: weeksTarget == 0 ? 0 : weeksProgress / weeksTarget,
                  color: Color(0xFFc74e55),
                  backgroundColor: Color(0xFFfbeae0),
                ),
              ),
      ),
      loading
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(height: 225.0),
              child: Container(),
            )
          : weeklyData.length == 0
              ? ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 225.0),
                  child: Center(
                    child: Text(
                      'Not Enough Information',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const Divider(),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: weeklyData.length,
                  itemBuilder: (context, index) => _weeklyTile(
                    context,
                    weeklyData[index],
                  ),
                )
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const Divider(),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
