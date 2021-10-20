import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/WorkManagerService.dart';
import '../data/provider/ProviderFactory.dart';
import 'AllHabits.dart';
import '../../shared/colors.dart';
import '../../utils/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  final ValueChanged<bool> themeChanged;
  Settings({this.themeChanged});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final sp = ProviderFactory.settingsProvider;
  final wms = WorkManagerService();

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;
    var _darkMode = _theme.brightness == Brightness.dark;
    var _selectedNavIndex = 2;

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
                    "Settings",
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
          )),
      body: SettingsList(
        lightBackgroundColor: _theme.scaffoldBackgroundColor,
        darkBackgroundColor: _theme.scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: "Common",
            titleTextStyle: GoogleFonts.nunito(
              color: Color(0xFFad8df2),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            tiles: [
              SettingsTile(
                title: 'All Habits',
                titleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                subtitleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                onTap: () => pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: '/habit/all'),
                  screen: AllHabits(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ),
              ),
              // SettingsTile(
              //   title: 'Time Of Day',
              //   leading: Icon(Icons.folder),
              //   trailing: Icon(Icons.chevron_right),
              //   titleTextStyle: GoogleFonts.nunito(
              //     color: Colors.black,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //   ),
              //   subtitleTextStyle: GoogleFonts.nunito(
              //     color: Colors.black,
              //     fontSize: 14,
              //     fontWeight: FontWeight.w700,
              //   ),
              //   onTap: () => Navigator.pushNamed(
              //     context,
              //     "/settings/time-of-day",
              //   ),
              // ),
              SettingsTile(
                title: "Start Week With",
                subtitle: sp.firstDayOfWeek == 'Mon' ? "Monday" : "Sunday",
                titleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                subtitleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                leading: Icon(Icons.calendar_today),
                switchActiveColor: _accent,
                onTap: () => showDialog(
                  builder: (context) => SimpleDialog(
                    title: Text('Start Week With'),
                    titleTextStyle: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      SimpleDialogOption(
                        child: CheckboxListTile(
                          title: Text('Sunday',
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )),
                          value: sp.firstDayOfWeek == "Sun",
                          activeColor: _accent,
                          onChanged: (val) => setState(() {
                            sp.firstDayOfWeek = val ? "Sun" : "Mon";
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                      SimpleDialogOption(
                        child: CheckboxListTile(
                          title: Text('Monday',
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )),
                          value: sp.firstDayOfWeek == "Mon",
                          activeColor: _accent,
                          onChanged: (val) => setState(() {
                            sp.firstDayOfWeek = val ? "Mon" : "Sun";
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                    ],
                  ),
                  context: context,
                ),
              ),
              // SettingsTile.switchTile(
              //   title: "Dark Mode",
              //   leading: Icon(Icons.lightbulb_outline),
              //   switchValue: sp.darkMode,
              //   switchActiveColor: _accent,
              //   onToggle: (val) => {
              //     setState(() {
              //       sp.darkMode = val;
              //     }),
              //     widget.themeChanged(true),
              //   },
              // )
            ],
          ),
          SettingsSection(
            title: "Notifications",
            titleTextStyle: GoogleFonts.nunito(
              color: Color(0xFFad8df2),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            tiles: [
              SettingsTile.switchTile(
                title: "Habit Reminders",
                titleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                subtitleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                leading: Icon(Icons.notifications),
                switchValue: sp.allowNotifcations,
                switchActiveColor: CustomColors.backgroundGreen,
                onToggle: (val) => setState(() {
                  sp.allowNotifcations = val;
                  sp.morningBriefing = val;
                  sp.weeklyReports = val;

                  if (val)
                    wms.activate();
                  else
                    wms.deactivate();
                }),
              ),
              SettingsTile.switchTile(
                title: "Daily Briefing",
                titleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                subtitleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                leading: Icon(Icons.dashboard),
                switchValue: sp.morningBriefing,
                switchActiveColor: CustomColors.backgroundGreen,
                onToggle: (val) => setState(() {
                  sp.morningBriefing = val;
                }),
              ),
              SettingsTile.switchTile(
                title: "Weekly Reports",
                titleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                subtitleTextStyle: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                leading: Icon(Icons.weekend),
                switchValue: sp.weeklyReports,
                switchActiveColor: CustomColors.backgroundGreen,
                onToggle: (val) => setState(() {
                  sp.weeklyReports = val;
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}
