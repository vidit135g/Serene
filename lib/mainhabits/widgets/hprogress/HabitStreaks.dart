import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/HabitStatsService.dart';
import '../../domain/Habit.dart';
import '../basic/StackedBarChart.dart';

class HabitStreaks extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitStreaks({this.habit});

  @override
  _HabitStreaksState createState() => _HabitStreaksState();
}

class _HabitStreaksState extends State<HabitStreaks> {
  List<StackData> data = List();
  bool loading = true;
  var type = "3 Months";

  @override
  void initState() {
    super.initState();
    type = "3 Months";
    _loadData();
  }

  void _loadData() {
    widget.habitStats.getStreaks(widget.habit, this.type).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        items: ["3 Months", "6 Months", "12 Months"]
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        value: this.type,
        onChanged: (e) => {
          setState(() {
            this.type = e;
            this.loading = true;
          }),
          _loadData(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Best Streaks',
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
      loading
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(height: 225.0),
              child: Container(),
            )
          : data.length == 0
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
              : StackedBarChart(data: data)
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
