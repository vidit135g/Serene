import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/ProgressStatsService.dart';
import '../basic/BarChart.dart';
import '../basic/HorizontalBarChart.dart';

class DayWisePerfomance extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _DayWisePerfomanceState createState() => _DayWisePerfomanceState();
}

class _DayWisePerfomanceState extends State<DayWisePerfomance> {
  List<ChartData> data = List();
  var loading = true;
  var type = "3 Months";

  @override
  void initState() {
    super.initState();
    type = "3 Months";
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

  void _loadData() {
    widget.statsService.getDayWiseProgressData(type).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Day Wise Perfomance',
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
        constraints: BoxConstraints.expand(height: 300.0),
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
                : HorizontalBarChart.withData(
                    'Day Wise Perfomance',
                    this.data,
                    context,
                  ),
      )
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
