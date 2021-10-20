import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/domain/HabitMaster.dart';
import '../data/provider/ProviderFactory.dart';
import 'HabitProgress.dart';
import '../../shared/colors.dart';
import '../../utils/const.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AllHabits extends StatefulWidget {
  @override
  _AllHabitsState createState() => _AllHabitsState();
}

class _AllHabitsState extends State<AllHabits> {
  final hmp = ProviderFactory.habitMasterProvider;
  List<HabitMaster> data = List<HabitMaster>();
  var loading = true;

  var _format = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() {
    hmp.list().then(
          (sData) => setState(() {
            data = sData;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var accentColor = _theme.accentColor;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "All Habits",
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
        ),
      ),
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   iconTheme: IconThemeData(color: accentColor),
      //   elevation: 0.0,
      //   title: Text(
      //     'All Habits',
      //     style: TextStyle(
      //       color: _darkMode ? Colors.white : Colors.black,
      //     ),
      //   ),
      //   backgroundColor: _theme.scaffoldBackgroundColor,
      // ),
      body: loading
          ? Container()
          : ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) =>
                  _darkMode ? Divider(color: accentColor) : Divider(),
              itemBuilder: (context, index) => ListTile(
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                  color: CustomColors.backgroundGreen,
                ),
                title: Text(
                  data[index].title,
                  style: GoogleFonts.nunito(
                    color: CustomColors.backgroundGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      data[index].isYNType
                          ? 'Simple Type'
                          : 'Target ${data[index].timesTarget} ${data[index].timesTargetType}',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    Text(
                      _format.format(data[index].fromDate),
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
                onTap: () => pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(
                      name: '/habit/progress',
                      arguments: data[index].toDomain()),
                  screen: HabitProgress(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ),
              ),
            ),
    );
  }
}
