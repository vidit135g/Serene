import 'package:flutter/material.dart';
import '../../data/ProgressStatsService.dart';
import '../basic/BasicTile.dart';

class StatusSummary extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _StatusSummaryState createState() => _StatusSummaryState();
}

class _StatusSummaryState extends State<StatusSummary> {
  var data = StatusSummaryData(todayProgress: 0, todayTarget: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    widget.statsService.getStatusSummaryData().then(
          (value) => setState(() {
            data = value;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var descTodaysGoal = data.todayProgress > 0
        ? data.todayProgress == data.todayTarget
            ? 'Great, target completed'
            : 'Good, target is in-progress'
        : 'Start for your goals now';

    return Row(
      children: <Widget>[
        BasicTile(
          title:
              '${data.todayProgress.toString()}/${data.todayTarget.toString()}',
          subtitle1: '',
          subtitle2: descTodaysGoal,
        )
      ],
    );
  }
}

class StatusSummaryData {
  int todayProgress = 0;
  int todayTarget = 0;
  StatusSummaryData({this.todayProgress, this.todayTarget});
}
