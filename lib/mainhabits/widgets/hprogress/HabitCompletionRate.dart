import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/HabitStatsService.dart';
import '../../domain/Habit.dart';
import '../basic/BarChart.dart';

class HabitCompletionRate extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitCompletionRate({this.habit});

  @override
  _HabitCompletionRateState createState() => _HabitCompletionRateState();
}

class _HabitCompletionRateState extends State<HabitCompletionRate> {
  //
  List<ChartData> data = List();
  bool loading = true;
  //
  String type = "Weekly";
  @override
  void initState() {
    super.initState();
    //
    type = "Weekly";
    _loadData();
  }

  void _loadData() {
    widget.habitStats
        .getCompletionRate(widget.habit, type)
        .then((value) => setState(() {
              data = value;
              loading = false;
            }));
  }

  onFilter(changed) {
    setState(() {
      type = changed;
      loading = true;
    });
    _loadData();
  }

  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        items: ["Monthly", "Weekly"]
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        value: type,
        onChanged: (e) => onFilter(e),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Completion Rate',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: loading
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
                child: CircularProgressIndicator(),
              )
            : _typeDropDown(),
      ),
      ConstrainedBox(
        constraints: BoxConstraints.expand(height: 225.0),
        child: loading
            ? Container()
            : data.length == 0
                ? Center(
                    child: Text(
                    'Not Enough Information',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ))
                : BarChart.withData('Weekly Progress', data, context),
      )
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
