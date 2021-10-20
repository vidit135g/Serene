import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/HabitMasterService.dart';
import '../data/provider/ProviderFactory.dart';
import '../domain/Habit.dart';
import '../domain/TimeArea.dart';
import 'Settings.dart';
import '../widgets/today/HCalDayWidget.dart';
import '../widgets/today/HabitsList.dart';
import '../../utils/const.dart';
import 'package:intl/intl.dart';

class TodayView extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  final sp = ProviderFactory.settingsProvider;
  //
  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  //
  final DateFormat dFormat = new DateFormat("dd MMM yyyy");
  var _selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  List<Habit> _habits = new List();
  List<TimeArea> areas = [TimeArea(area: 'All Day', startTime: null)];

  var selectedArea = "All Day";
  bool loading = true;

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    areas.addAll(widget.sp.timeArea);
    selectedArea = _currentTimeOfDay();
    _loadData();
  }

  void _loadData() {
    widget.habitMaster.list(_selectedDate).then(
          (data) => setState(() {
            this._habits.clear();
            this._habits.addAll(data);
            loading = false;
          }),
        );
  }

  int _toMinutes(TimeOfDay _time) {
    return (_time.hour * 60) + _time.minute;
  }

  String _currentTimeOfDay() {
    var timeNow = TimeOfDay.now();

    var _sortAreas = areas.where((ar) => ar.area != 'All Day').toList();

    _sortAreas.sort((prev, after) =>
        _toMinutes(prev.startTime) < _toMinutes(after.startTime) ? -1 : 1);

    var _nowArea = _sortAreas
        .where((ar) => _toMinutes(ar.startTime) < _toMinutes(timeNow));

    return _nowArea == null || _nowArea.length == 0
        ? 'All Day'
        : _nowArea.last.area;
  }

  PreferredSize _getAppBar(selectedDate, context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;

    var index = DateTime.now().difference(selectedDate).inDays;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var title = index == 0 ? 'Habits' : dFormat.format(thisDate);
    // var areaOptions = DropdownButton<String>(
    //   value: selectedArea,
    //   icon: Icon(
    //     Icons.keyboard_arrow_down,
    //     color: Theme.of(context).accentColor,
    //   ),
    //   iconSize: 24,
    //   elevation: 16,
    //   style: GoogleFonts.cabin(
    //     color: Colors.black,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w800,
    //   ),
    //   underline: Container(),
    //   onChanged: (String newValue) {
    //     setState(() {
    //       selectedArea = newValue;
    //     });
    //   },
    //   items: areas.map<DropdownMenuItem<String>>((timeArea) {
    //     return DropdownMenuItem<String>(
    //       value: timeArea.area,
    //       child: Row(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(right: 5.0),
    //             child: Icon(
    //               timeArea.icon,
    //               color: _accent,
    //               size: 20,
    //             ),
    //           ),
    //           Text(timeArea.area),
    //         ],
    //       ),
    //     );
    //   }).toList(),
    // );

    return PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Habits",
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: new EdgeInsets.symmetric(
                      horizontal: Constants.mainPadding,
                      vertical: Constants.mainPadding),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  FloatingActionButton _getFab() {}

  Widget showLoading() {
    return SliverList(
      delegate: new SliverChildListDelegate(
        [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  List<Habit> _filterHabits() {
    if (selectedArea == "All Day")
      return this._habits;
    else {
      return this
          ._habits
          .where((i) =>
              i.timeOfDay == selectedArea ||
              i.timeOfDay == null ||
              i.timeOfDay == "All Day")
          .toList();
    }
  }

  _onDateChange(DateTime newDate) {
    this.setState(() {
      _selectedDate = newDate;
      _habits.clear();
      loading = true;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    //
    var _selectedNavIndex = 0;

    var _appBar = _getAppBar(_selectedDate, context);
    var dateBarHeight = _appBar.preferredSize.height * 1;

    return Scaffold(
      appBar: _appBar,
      extendBodyBehindAppBar: false,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          HCalDayWidget(
            height: dateBarHeight,
            date: _selectedDate,
            onChange: _onDateChange,
          ),
          loading
              ? showLoading()
              : HabitsList(
                  habits: _filterHabits(),
                  date: _selectedDate,
                  onEdit: (habit) => Navigator.pushNamed(
                    context,
                    '/edit',
                    arguments: habit,
                  ),
                  onDelete: (habit) => {
                    setState(() {
                      loading = false;
                    }),
                    widget.habitMaster
                        .deleteHabit(habit.id)
                        .whenComplete(() => _loadData()),
                  },
                  onSkip: (habit) => {
                    setState(() {
                      habit.isSkipped = true;
                      if (habit.isYNType) {
                        habit.timesProgress = 1;
                        habit.ynCompleted = true;
                      } else {
                        habit.timesProgress = habit.timesProgress;
                      }
                      loading = false;
                    }),
                    widget.habitMaster
                        .updateStatus(habit: habit, dateTime: _selectedDate)
                        .then((value) => _loadData()),
                  },
                )
        ],
      ),
      floatingActionButton:
          _filterHabits().length == 0 ? Container() : _getFab(),
    );
  }
}
