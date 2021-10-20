import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../domain/Habit.dart';
import '../basic/BooleanListItem.dart';
import '../basic/TimesListItem.dart';
import '../../../shared/colors.dart';
import '../../../utils/const.dart';
import 'package:lottie/lottie.dart';

class HabitsList extends StatelessWidget {
  //
  final List<Habit> habits;
  final DateTime date;
  final ValueChanged<Habit> onEdit;
  final ValueChanged<Habit> onDelete;
  final ValueChanged<Habit> onSkip;
  HabitsList({this.habits, this.date, this.onEdit, this.onDelete, this.onSkip});

  Widget _emptyList(context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 0,
              ),
              child: Lottie.asset('assets/raw/soon.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                  width: 200,
                  height: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slidable(child, Habit habit, context) {
    var _theme = Theme.of(context);
    var _accentColor = CustomColors.darkhabit;
    var _darkMode = _theme.brightness == Brightness.dark;

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          icon: Icons.edit,
          color: _darkMode ? Colors.black : Colors.white,
          foregroundColor: _accentColor,
          onTap: () => this.onEdit(habit),
        ),
        IconSlideAction(
            caption: 'Delete',
            icon: Icons.delete,
            color: _darkMode ? Colors.black : Colors.white,
            foregroundColor: _accentColor,
            onTap: () => this.onDelete(habit)),
      ],
      child: child,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Skip',
          icon: Icons.skip_next,
          color: _darkMode ? Colors.black : Colors.white,
          foregroundColor: _accentColor,
          onTap: () => this.onSkip(habit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return habits.length == 0
        ? SliverList(
            delegate: new SliverChildListDelegate(
            [_emptyList(context)],
          ))
        : SliverList(
            delegate: new SliverChildListDelegate(
              habits
                  .asMap()
                  .entries
                  .map(
                    (entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: const Duration(milliseconds: 1000),
                      child: FadeInAnimation(
                        child: _slidable(
                          entry.value.isYNType
                              ? BooleanListItem(
                                  habit: entry.value,
                                  date: this.date,
                                )
                              : TimesListItem(
                                  habit: entry.value,
                                  date: this.date,
                                ),
                          entry.value,
                          context,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
