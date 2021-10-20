import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/HabitMasterService.dart';
import '../domain/TopicHabits.dart';
import 'TodayView.dart';
import '../widgets/new/SelectChecklistType.dart';
import '../widgets/new/SelectFromDate.dart';
import '../widgets/new/SelectReminder.dart';
import '../widgets/new/SelectRepeat.dart';
import '../widgets/new/SelectTimeOfDay.dart';
import '../../shared/colors.dart';

class NewHabit extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  //
  @override
  _NewHabitState createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  String title;
  Repeats repeat;
  DateTime fromDate;
  ChecklistType type;
  List<TimeOfDay> reminder;
  String timeOfDay;
  bool loading;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //
    title = null;
    repeat = Repeats();
    fromDate = null;
    type = ChecklistType(
      isSimple: true,
      times: 1,
      timesType: null,
    );
    reminder = [];
    timeOfDay = "All Day";
    loading = false;
  }

  void _saveHabit() {
    setState(() {
      loading = true;
    });
    //
    widget.habitMaster
        .create(
          title: title,
          repeat: repeat,
          fromDate: fromDate == null ? DateTime.now() : fromDate,
          type: type,
          reminder: reminder,
          timeOfDay: timeOfDay,
        )
        .then((sts) => {
              setState(() {
                loading = false;
              }),
              Navigator.of(context).popUntil((route) => route.isFirst),
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (BuildContext context) {
                    return TodayView();
                  },
                ),
                (_) => false,
              ),
            });
  }

  AppBar _getAppBar(context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Text(
        'Create New Habit',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => this.title == null
              ? _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("please enter a title for the Habbit"),
                ))
              : _saveHabit(),
          child: Text(
            'Save',
            style: GoogleFonts.nunito(
              color: CustomColors.darkhabit,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Container(color: Colors.grey.withOpacity(0.5), height: 1.0),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }

  Widget _nameTile(context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: _darkMode
            ? Colors.grey.withOpacity(0.25)
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: TextField(
          style: GoogleFonts.nunito(
            color: CustomColors.darkhabit,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          cursorColor: CustomColors.darkhabit,
          autofocus: false,
          controller: TextEditingController(text: title),
          onChanged: (val) => title = val,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 0,
              bottom: 11,
              top: 11,
              right: 15,
            ),
            hintText: 'Name',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TopicHabits _habit = ModalRoute.of(context).settings.arguments;
    if (_habit != null) {
      setState(() {
        title = _habit.title;
        type = ChecklistType(
          isSimple: _habit.isYNType,
          times: _habit.timesTarget,
          timesType: _habit.timesTargetType,
        );
        repeat = _habit.repeat == null ? Repeats() : _habit.repeat;
        timeOfDay = _habit.timeOfDay;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: _getAppBar(context),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: loading
            ? Center(
                child: Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(),
              ))
            : ListView(
                children: <Widget>[
                  _nameTile(context),
                  SelectRepeat(
                    value: repeat,
                    onChange: (val) => {
                      setState(() {
                        repeat = val;
                      })
                    },
                  ),
                  SelectFromDate(
                    value: fromDate,
                    onChange: (val) => setState(() {
                      fromDate = val;
                    }),
                  ),
                  SelectChecklistType(
                    value: type,
                    onChange: (val) => setState(() {
                      type = val;
                    }),
                  ),
                  SelectReminder(
                    value: reminder,
                    onChange: (val) => setState(() {
                      reminder = val;
                    }),
                  ),
                  SelectTimeOfDay(
                    value: timeOfDay,
                    onChange: (val) => setState(() {
                      timeOfDay = val;
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
