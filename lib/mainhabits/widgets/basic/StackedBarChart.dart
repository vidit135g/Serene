import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/colors.dart';

class StackedBarChart extends StatelessWidget {
  final List<StackData> data;

  StackedBarChart({this.data});

  Widget _getBox(BuildContext context, int maxValue, StackData sData) {
    var _theme = Theme.of(context);
    var accentColor = CustomColors.darkhabit;
    var _textStyle = (GoogleFonts.nunito(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    ));
    var maxWidth = MediaQuery.of(context).size.width;
    var thisWidth = ((sData.yValue / maxValue) * maxWidth * 0.65).toDouble();
    //
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(10.0, 5, 10.0, 5.0),
      width: thisWidth,
      decoration: BoxDecoration(
        color: CustomColors.backgroundGreen,
        border: Border.all(width: 3.0, color: accentColor),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
          child: Text(
        '${sData.yValue}',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var maxValue = this.data.map((e) => e.yValue).reduce(max);
    //
    return new Column(
      children: this
          .data
          .map(
            (e) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(e.xStart),
                Container(
                  child: _getBox(context, maxValue, e),
                ),
                Text(e.xEnd),
              ],
            ),
            // ListTile(
            //   dense: true,
            //   leading: Text(e.xStart),
            //   title: _getBox(context, maxValue, e),
            //   trailing: Text(e.xEnd),
            // ),
          )
          .toList(),
    );
  }
}

class StackData {
  final String xStart;
  final String xEnd;
  final int yValue;

  StackData(this.xStart, this.xEnd, this.yValue);
}
