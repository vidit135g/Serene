import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/ProgressStatsService.dart';
import '../basic/HeatMap.dart';

class DailyTracker extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _DailyTrackerState createState() => _DailyTrackerState();
}

class _DailyTrackerState extends State<DailyTracker> {
  Map<DateTime, int> data = Map();
  var type = "3 Months";
  var loading = true;
  Key hmcKey = ValueKey('progress-all');

  @override
  void initState() {
    super.initState();
    //
    type = "3 Months";
    _loadData();
  }

  void _loadData() {
    widget.statsService.getHeatMapData(type).then((value) => {
          if (mounted)
            setState(() {
              data = value;
              loading = false;
            }),
        });
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

  onFilter(type) {
    setState(() {
      type = type;
      loading = true;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        dense: true,
        title: Text(
          'Daily Tracker',
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
      Padding(
        padding: EdgeInsets.all(10),
        child: loading
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
                : HeatMap(key: hmcKey, data: this.data, range: this.type),
      )
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
