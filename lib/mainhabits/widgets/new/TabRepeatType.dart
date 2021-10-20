import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SelectRepeat.dart';

class TabRepeatType extends StatefulWidget {
  //
  final Repeats value;
  final ValueChanged<Repeats> onChange;
  TabRepeatType({this.value, this.onChange});

  @override
  _TabRepeatTypeState createState() => _TabRepeatTypeState();
}

class _TabRepeatTypeState extends State<TabRepeatType> {
  Repeats selected;

  @override
  void initState() {
    super.initState();
    selected = widget.value;
  }

  CheckboxListTile _tile({
    String title,
    bool value,
    ValueChanged<bool> onChange,
    Color accent,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      value: value,
      activeColor: accent,
      onChanged: (val) => onChange(!value),
    );
  }

  List<Widget> _intervalList(Color accent) {
    return [1, 2, 3, 4, 5, 6, 7]
        .map(
          (d) => _tile(
            title: 'Every $d Days',
            value: selected.interval == d,
            onChange: (val) => {
              setState(() {
                selected.none = false;
                if (val) selected.interval = d;
              }),
              widget.onChange(selected),
            },
            accent: accent,
          ),
        )
        .toList();
  }

  List<Widget> _weekdayList(Color accent) {
    return [
      _tile(
        title: 'Sunday',
        value: selected.hasSun,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasSun = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Monday',
        value: selected.hasMon,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasMon = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Tuesday',
        value: selected.hasTue,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasTue = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Wednesday',
        value: selected.hasWed,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasWed = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Thursday',
        value: selected.hasThu,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasThu = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Friday',
        value: selected.hasFri,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasFri = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      ),
      _tile(
        title: 'Saturday',
        value: selected.hasSat,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasSat = val;
          }),
          widget.onChange(selected),
        },
        accent: accent,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;
    var _bgColor = _theme.brightness == Brightness.dark
        ? Colors.grey.withOpacity(0.25)
        : Theme.of(context).scaffoldBackgroundColor;

    var weekdayList = _weekdayList(_accent);
    var intervalList = _intervalList(_accent);

    return DefaultTabController(
      length: 2,
      initialIndex: selected.isWeekly ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: _bgColor,
          //elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: _theme.textTheme.bodyText1.color),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Select Repetitions',
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: TabBar(
            labelColor: _accent,
            indicatorColor: _accent,
            unselectedLabelColor: _theme.textTheme.subtitle2.color,
            tabs: [
              Tab(
                  child: Text(
                'Weekly',
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              )),
              Tab(
                  child: Text(
                'In-Interval',
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              )),
            ],
            onTap: (index) => {
              setState(() {
                selected.isWeekly = index == 0;
              }),
              widget.onChange(selected),
            },
          ),
        ),
        body: Container(
          child: TabBarView(children: [
            ListView.separated(
              separatorBuilder: (context, index) => Divider(color: _bgColor),
              itemCount: weekdayList.length,
              itemBuilder: (context, index) => weekdayList[index],
            ),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(color: _bgColor),
              itemCount: intervalList.length,
              itemBuilder: (context, index) => intervalList[index],
            ),
          ]),
        ),
      ),
    );
  }
}
