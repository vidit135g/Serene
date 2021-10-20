import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/HabitMasterService.dart';
import '../domain/Habit.dart';
import '../widgets/new/SelectChecklistType.dart';
import '../widgets/new/SelectFromDate.dart';
import '../widgets/new/SelectReminder.dart';
import '../widgets/new/SelectRepeat.dart';
import '../widgets/new/SelectTimeOfDay.dart';
import '../../shared/colors.dart';
import '../../utils/const.dart';

class EditHabit extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  //
  @override
  _EditHabitState createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {
  String title;
  Repeats repeat;
  DateTime fromDate;
  ChecklistType type;
  List<TimeOfDay> reminder;
  String timeOfDay;
  bool loading;

  Habit srcHabit;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //
    title = null;
    repeat = Repeats();
    fromDate = DateTime.now();
    type = ChecklistType(
      isSimple: true,
      times: 1,
      timesType: null,
    );
    reminder = null;
    timeOfDay = "All Day";
    loading = true;
  }

  void _saveHabit() {
    setState(() {
      loading = true;
    });
    //
    widget.habitMaster
        .update(
          id: srcHabit.id,
          title: title,
          repeat: repeat,
          fromDate: fromDate,
          type: type,
          reminder: reminder,
          timeOfDay: timeOfDay,
        )
        .then((sts) => {
              setState(() {
                loading = false;
              }),
              Navigator.pushNamed(context, '/'),
            });
  }

  AppBar _getAppBar(context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Text(
        'Edit Habit',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 24,
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _nameTile(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
      child: ListTile(
        title: TextField(
          autofocus: false,
          style: GoogleFonts.nunito(
            color: CustomColors.darkhabit,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          controller: TextEditingController(text: title),
          onChanged: (val) => title = val,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            filled: true,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 5,
              bottom: 11,
              top: 11,
              right: 15,
            ),
            hintText: 'Habit Name',
            hintStyle: GoogleFonts.nunito(
              color: CustomColors.darkhabit,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (srcHabit == null) {
      Habit habit = ModalRoute.of(context).settings.arguments;
      widget.habitMaster.hmp.getData(habit.id).then((hm) => {
            setState(() {
              srcHabit = habit;
              title = hm.title;
              repeat = Repeats(
                none: hm.isNone,
                isWeekly: hm.isWeekly,
                hasSun: hm.hasSun,
                hasMon: hm.hasMon,
                hasTue: hm.hasTue,
                hasWed: hm.hasWed,
                hasThu: hm.hasThu,
                hasFri: hm.hasFri,
                hasSat: hm.hasSat,
                interval: hm.repDuation,
              );
              fromDate = hm.fromDate;
              type = ChecklistType(
                isSimple: hm.isYNType,
                times: hm.timesTarget,
                timesType: hm.timesTargetType,
              );
              reminder = hm.reminder;
              timeOfDay = hm.timeOfDay;
              loading = false;
            }),
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
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: _nameTile(context)),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: SelectRepeat(
                        value: repeat,
                        onChange: (val) => {
                          setState(() {
                            repeat = val;
                          })
                        },
                      )),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: SelectFromDate(
                        value: fromDate,
                        onChange: (val) => setState(() {
                          fromDate = val;
                        }),
                      )),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: SelectChecklistType(
                        value: type,
                        onChange: (val) => setState(() {
                          type = val;
                        }),
                      )),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: SelectReminder(
                        value: reminder,
                        onChange: (val) => setState(() {
                          reminder = val;
                        }),
                      )),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.all(10),
                      child: SelectTimeOfDay(
                        value: timeOfDay == 'All Day' ? null : timeOfDay,
                        onChange: (val) => setState(() {
                          timeOfDay = val;
                        }),
                      )),
                ],
              ),
      ),
    );
  }
}
