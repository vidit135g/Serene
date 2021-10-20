import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/ProgressStatsService.dart';
import '../basic/LineChart.dart';

class CompletionRate extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _CompletionRateState createState() => _CompletionRateState();
}

class _CompletionRateState extends State<CompletionRate> {
  //
  List<LinearData> data = List();
  bool loading = true;
  String type = "Weekly";

  @override
  void initState() {
    super.initState();
    //
    type = "Weekly";
    _loadData();
  }

  void _loadData() {
    widget.statsService
        .getCompletionRateData(type)
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
        value: this.type,
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
                      fontSize: 216,
                      fontWeight: FontWeight.w800,
                    ),
                  ))
                : LineChart.withData('Weekly Progress', this.data, context),
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
