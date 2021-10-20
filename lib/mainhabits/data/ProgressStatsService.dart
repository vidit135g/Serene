import 'domain/HabitRunData.dart';
import 'provider/ProviderFactory.dart';
import '../domain/Habit.dart';
import '../widgets/basic/BarChart.dart';
import '../widgets/basic/LineChart.dart';
import '../widgets/progress/StatusSummary.dart';

class ProgressStatsService {
  //
  var hmp = ProviderFactory.habitMasterProvider;
  var lrdp = ProviderFactory.habitLastRunDataProvider;
  var rdp = ProviderFactory.habitRunDataProvider;
  var slrp = ProviderFactory.serviceLastRunProvider;
  var sp = ProviderFactory.settingsProvider;
  //
  Future<List<LinearData>> getCompletionRateData(String type) async {
    return type == 'Weekly'
        ? await getWeeklyCompletionRate()
        : await getMonthlyCompletionRate();
  }

  Future<List<LinearData>> getWeeklyCompletionRate() async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var weeksToShow = 12;
    var statStart = today.subtract(Duration(days: today.weekday - 1));
    var statEnd = statStart.subtract(Duration(days: 7 * weeksToShow));
    //
    var data = List<LinearData>();
    var counts = await this.rdp.weekWiseStatsForAll(
          statStart,
          statEnd,
          weeksToShow,
        );
    if (counts.length == 0) {
      return [];
    }
    if (counts.length < weeksToShow) {
      var startMarker = counts.first[columnTargetWeekInYear];
      int markerWeek = startMarker == null
          ? null
          : int.parse(startMarker.toString().substring(1));

      for (var ct = 0; ct < (weeksToShow - counts.length); ct++) {
        var weekName = markerWeek - (weeksToShow - counts.length) + ct;
        data.add(LinearData('W$weekName', ct + 1, 0));
      }
    }

    var cnt2 = weeksToShow - counts.length;
    counts.forEach((runData) {
      cnt2++;
      data.add(
        LinearData(runData[columnTargetWeekInYear], cnt2, runData['sum']),
      );
    });
    //
    return data;
  }

  Future<List<LinearData>> getMonthlyCompletionRate() async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var monthsToShow = 12;

    var statStart = DateTime(today.year, today.month + 1, 1);
    var statEnd = statStart.subtract(Duration(days: 31 * monthsToShow));
    //
    var data = List<LinearData>();
    var counts = await this.rdp.weekMonthStatsForAll(
          statStart,
          statEnd,
          monthsToShow,
        );
    if (counts.length == 0) {
      return [];
    }

    if (counts.length < monthsToShow) {
      var startingMonth = counts.first[columnTargetMonthInYear];
      var firstDate = fmMonth.parse(startingMonth);
      for (var ct = 1; ct <= (monthsToShow - counts.length); ct++) {
        var monthToShow = firstDate.month - (monthsToShow - ct) + 1;
        var monString = fmMonth.format(DateTime(2020, monthToShow, 1));
        data.add(LinearData(monString, ct, 0));
      }
    }

    var cnt2 = monthsToShow - counts.length;
    counts.forEach((runData) {
      cnt2++;
      data.add(
        LinearData(runData[columnTargetMonthInYear], cnt2, runData['sum']),
      );
    });
    //
    return data;
  }

  Future<List<Habit>> getWeeklyProgressData() async {
    var weeklyData = new List<Habit>();

    var now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var startWeek = now.subtract(Duration(days: now.weekday - 1));

    var habitData = await this.rdp.listBetween(startWeek, now);
    var habitsList = habitData.map((habit) => habit.habitId).toSet().toList();

    for (var habitId in habitsList) {
      var habit = await this.hmp.getData(habitId);
      var habitWeeklyData =
          habitData.where((eachData) => eachData.habitId == habitId).toList();

      var weeklyProgress = habitWeeklyData == null
          ? 0
          : habitWeeklyData.map((e) => e.progress).reduce(
                (a, b) => a + b,
              );

      var weeklyTarget = habitWeeklyData == null
          ? 0
          : habitWeeklyData.length * habit.timesTarget;

      weeklyData.add(Habit.newTimesHabit(
        id: habitId,
        title: habit.title,
        completed: weeklyProgress,
        target: weeklyTarget,
      ));
    }

    return weeklyData;
  }

  Future<StatusSummaryData> getStatusSummaryData() async {
    var now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var totalProgress = 0;
    var totalTarget = 0;

    var habitTodayData = await this.rdp.listForDate(now);
    for (var habitData in habitTodayData) {
      var habit = await this.hmp.getData(habitData.habitId);
      totalProgress += habitData.progress;
      totalTarget += habit.timesTarget;
    }

    return StatusSummaryData(
      todayProgress: totalProgress,
      todayTarget: totalTarget,
    );
  }

  Future<Map<DateTime, int>> getHeatMapData(String type) async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    //
    var dayToShow = type == "12 Months" ? 366 : (type == "6 Months" ? 183 : 90);
    var statDate = today.subtract(Duration(days: dayToShow));
    var runData = await this.rdp.listBetween(statDate, today);

    var hmData = Map<DateTime, int>();
    for (var rd in runData) {
      var habit = await this.hmp.getData(rd.habitId);
      var pcCompleted = ((rd.hasSkipped ? 0 : rd.progress) /
              (habit.isYNType ? 1 : habit.timesTarget)) *
          100;

      var prevData = hmData[rd.targetDate];
      hmData[rd.targetDate] = prevData == null
          ? pcCompleted.toInt()
          : (prevData + pcCompleted.toInt());
    }

    return hmData;
  }

  Future<List<ChartData>> getDayWiseProgressData(type) async {
    //
    var numDaysToShow =
        type == "12 Months" ? 366 : (type == "6 Months" ? 183 : 90);
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    var startDay = today.subtract(Duration(days: numDaysToShow));
    var weekWiseData = await this.rdp.dayWiseStatsForAll(
          startDay.millisecondsSinceEpoch,
        );

    var data = List<ChartData>();
    var weeklyConst = sp.firstDayOfWeek == 'Mon'
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    weeklyConst.forEach((wc) {
      var filtered = weekWiseData.where(
        (weekData) => weekData[columnTargetDayInWeek] == wc,
      );

      data.add(
        ChartData(
          wc,
          filtered.length > 0 ? filtered.first['sum'] : 0,
        ),
      );
    });

    return data;
  }
}
