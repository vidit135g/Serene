import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/HabitMasterService.dart';
import '../../domain/Habit.dart';
import '../../pages/HabitProgress.dart';
import '../../../shared/colors.dart';
import '../../../utils/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TimesListItem extends StatefulWidget {
  final Habit habit;
  final DateTime date;
  final HabitMasterService habitMaster = new HabitMasterService();
  TimesListItem({this.habit, this.date});

  @override
  _TimesListItemState createState() => _TimesListItemState();
}

class _TimesListItemState extends State<TimesListItem> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateData(int progress) async {
    setState(() {
      loading = true;
      widget.habit.isSkipped = false;
      widget.habit.timesProgress = progress;
    });
    widget.habitMaster
        .updateStatus(
          habit: widget.habit,
          dateTime: widget.date,
        )
        .then(
          (sts) => setState(() {
            loading = false;
          }),
        );
  }

  Future<void> _showLogEntry(context) async {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        double _timesProgress = widget.habit.timesProgress.toDouble();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Log Entry',
                style: TextStyle(fontWeight: FontWeight.bold, color: _accent),
              ),
              titlePadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.habit.title),
                      subtitle: Text(
                          "Target ${widget.habit.timesTarget} ${widget.habit.timesTargetType}"),
                      trailing: Text(
                        widget.habit.timesProgress.toString(),
                        style: _theme.textTheme.headline4,
                      ),
                    ),
                    Slider(
                      value: _timesProgress,
                      min: 0,
                      max: widget.habit.timesTarget.toDouble(),
                      divisions: widget.habit.timesTarget,
                      label: _timesProgress.toInt().toString(),
                      activeColor: _accent,
                      onChanged: (value) => setState(() {
                        _timesProgress = value;
                      }),
                      onChangeEnd: (double value) => {
                        setState(() {
                          _timesProgress = value;
                        }),
                        _updateData(value.toInt()),
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  InkWell _addIcon(_theme, context) {
    var _icon = Icon(
      Icons.add_circle_outline,
      size: 30,
      color: CustomColors.darkhabit,
    );

    return InkWell(
      child: IconButton(
        icon: widget.habit.timesProgress < widget.habit.timesTarget
            ? _icon
            : Container(),
        onPressed: () => widget.habit.timesProgress < widget.habit.timesTarget
            ? {
                setState(() {
                  loading = true;
                  widget.habit.isSkipped = false;
                  widget.habit.timesProgress++;
                }),
                widget.habitMaster
                    .updateStatus(
                      habit: widget.habit,
                      dateTime: widget.date,
                    )
                    .then(
                      (sts) => setState(() {
                        loading = false;
                      }),
                    ),
              }
            : {},
      ),
      onLongPress: () async => _showLogEntry(context),
    );
  }

  InkWell _minusIcon(_theme, context) {
    var _icon = Icon(
      Icons.remove_circle_outline,
      size: 30,
      color: CustomColors.darkhabit,
    );

    return InkWell(
      child: IconButton(
        icon: widget.habit.timesProgress > 0 ? _icon : Container(),
        onPressed: () => widget.habit.timesProgress > 0
            ? {
                setState(() {
                  loading = true;
                  widget.habit.isSkipped = false;
                  widget.habit.timesProgress--;
                }),
                widget.habitMaster
                    .updateStatus(
                      habit: widget.habit,
                      dateTime: widget.date,
                    )
                    .then(
                      (sts) => setState(() {
                        loading = false;
                      }),
                    )
              }
            : {},
      ),
      onLongPress: () async => _showLogEntry(context),
    );
  }

  String toReminderString(TimeOfDay tod) {
    if (tod == null) {
      return '';
    } else {
      var _hour = tod.hour.toString().padLeft(2, '0');
      var _minute = tod.minute.toString().padLeft(2, '0');
      return "$_hour:$_minute";
    }
  }

  String _getReminder() {
    var now = DateTime.now();
    var nowHour = (now.hour + now.minute / 60.0);
    this.widget.habit.reminder.sort(
          (a, b) =>
              (a.hour + a.minute / 60.0).compareTo((b.hour + b.minute / 60.0)),
        );
    var thatReminder = this.widget.habit.reminder.firstWhere(
          (rem) => (rem.hour + rem.minute / 60.0) > nowHour,
          orElse: () => null,
        );

    return thatReminder == null ? null : toReminderString(thatReminder);
  }

  @override
  Widget build(BuildContext context) {
    //
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var subtitleStyle = _theme.textTheme.subtitle2;

    var timesProgress = widget.habit == null ? 0 : widget.habit.timesProgress;
    var timesTarget = widget.habit == null ? 0 : widget.habit.timesTarget;
    var timesTargetType =
        widget.habit == null ? 0 : widget.habit.timesTargetType;

    var backgroundColor = timesProgress == timesTarget
        ? _theme.primaryColor.withAlpha(_darkMode ? 75 : 10)
        : _darkMode
            ? _theme.textTheme.subtitle2.color.withAlpha(50)
            : _theme.scaffoldBackgroundColor;

    var borderColor = timesProgress == timesTarget
        ? _theme.primaryColor.withAlpha(80)
        : _theme.textTheme.subtitle2.color.withAlpha(_darkMode ? 100 : 50);

    var _border = BoxDecoration(
      border: Border.all(color: borderColor),
      color: CustomColors.lighthabit,
      borderRadius: BorderRadius.all(Radius.circular(22)),
    );

    var _progressTxt =
        "${timesProgress.toString()} / ${timesTarget.toString()} $timesTargetType Completed";

    var displayReminder = _getReminder();

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      decoration: _border,
      child: InkWell(
        onTap: () => pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(
              name: '/habit/progress', arguments: this.widget.habit),
          screen: HabitProgress(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ),
        child: Card(
          elevation: 0.0,
          color: CustomColors.lighthabit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'habit-title-' + this.widget.habit.id.toString(),
                        child: Text(
                          this.widget.habit.title,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          this.widget.habit.reminder == null ||
                                  this.widget.habit.reminder.length == 0 ||
                                  displayReminder == null
                              ? Text(
                                  this.widget.habit.timeOfDay == null
                                      ? 'All Day'
                                      : this.widget.habit.timeOfDay,
                                  style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Row(
                                  children: [
                                    _getReminder() == null
                                        ? null
                                        : Icon(
                                            Icons.alarm,
                                            color: CustomColors.darkhabit,
                                            size: subtitleStyle.fontSize,
                                          ),
                                    Text(
                                      _getReminder(),
                                      style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                          this.widget.habit.isSkipped
                              ? Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'Skipped',
                                    style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  loading
                      ? IconButton(
                          icon: CircularProgressIndicator(),
                          onPressed: () => {},
                        )
                      : Container(),
                  loading ? Container() : _minusIcon(_theme, context),
                  loading ? Container() : _addIcon(_theme, context),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  _progressTxt,
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    backgroundColor: CustomColors.lighthabit,
                    color: CustomColors.darkhabit,
                    value: timesProgress / timesTarget,
                  ),
                ),
              ),
              // ButtonBar(
              //   children: loading
              //       ? [
              //           Padding(
              //             child: Text('.. updating ..'),
              //             padding: EdgeInsets.all(16.0),
              //           )
              //         ]
              //       : [_addIcon(_theme), _minusIcon(_theme)],
              //   buttonPadding: EdgeInsets.zero,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
