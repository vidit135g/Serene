import 'package:flutter/material.dart';
import '../basic/BaseSelectionAddableTile.dart';
import '../basic/BaseSelectionChipsTile.dart';

class SelectReminder extends StatefulWidget {
  final List<TimeOfDay> value;
  final ValueChanged<List<TimeOfDay>> onChange;

  SelectReminder({this.value, this.onChange});

  @override
  _SelectReminderState createState() => _SelectReminderState();
}

class _SelectReminderState extends State<SelectReminder> {
  List<TimeOfDay> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.value;
  }

  void _showDialog(context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      helpText: 'Select Reminder Time',
      context: context,
    ).then((val) => {
          if (_data
                  .where((el) =>
                      (el.hour + el.minute / 60.0) ==
                      (val.hour + val.minute / 60.0))
                  .length ==
              0)
            {
              setState(() {
                _data.add(val);
              }),
              this.widget.onChange(_data),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.value == null || widget.value.length == 0
        ? BaseSelectionAddableTile(
            value: null,
            icon: Icon(Icons.notifications),
            title: 'Reminder',
            emptyText: 'No Reminder',
            onTap: () => _showDialog(context),
            onClear: () => this.widget.onChange(null),
          )
        : BaseSelectionChipsTile(
            values: widget.value,
            icon: Icon(Icons.notifications),
            title: 'Reminder',
            emptyText: 'No Reminder',
            onAdd: () => _showDialog(context),
            onDelete: (val) => {
              setState(() {
                _data.retainWhere((el) =>
                    (el.hour + el.minute / 60.0) !=
                    (val.hour + val.minute / 60.0));
              }),
              this.widget.onChange(_data),
            },
          );
  }
}
