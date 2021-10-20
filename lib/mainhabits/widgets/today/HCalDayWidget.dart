import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../pages/SelectTopic.dart';
import '../../../shared/colors.dart';
import '../../../shared/widgets/blog_jumbo.dart';
import '../../../stories/whatsapp.dart';
import '../../../utils/const.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HCalDayWidget extends StatelessWidget {
  //
  final double height;
  final DateTime date;
  final void Function(DateTime) onChange;

  HCalDayWidget({this.height, this.date, this.onChange});

  final int noOfDates = 30;

  final DateFormat dFormat = new DateFormat("MMM");

  Widget _eachCalDate(index, selected, context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var thisDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: -index));

    var textStyle = GoogleFonts.nunito(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    );
    var backgroundColor =
        index == selected ? CustomColors.lighthabit : CustomColors.lighthabit;

    var borderColor =
        index == selected ? CustomColors.darkhabit : CustomColors.lighthabit;

    return GestureDetector(
      onTap: () => this.onChange(thisDate),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 14.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            Text(thisDate.day.toString(), style: textStyle),
            Text(dFormat.format(thisDate), style: textStyle),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedIndex = DateTime.now().difference(this.date).inDays;

    return new SliverPadding(
      padding: new EdgeInsets.all(0),
      sliver: new SliverList(
        delegate: new SliverChildListDelegate([
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              padding: EdgeInsets.only(left: 15, top: 4, right: 12),
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: AssetImage("assets/images/med.jpg"),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFC2AB),
                    Color(0xFFFFEEE9),
                    Color(0xFfffe0c2),
                  ],
                ),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(height: 20),
                    // Container(
                    //   margin: const EdgeInsets.all(15.0),
                    //   padding: const EdgeInsets.only(
                    //       left: 10, right: 10, top: 5, bottom: 5),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(width: 2, color: Colors.white),
                    //     borderRadius: BorderRadius.circular(35),
                    //   ),
                    //   child: Text('Featured',
                    //       style: GoogleFonts.nunito(
                    //         color: Colors.black,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w700,
                    //       )),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: Text(
                        "   Habits to help you \n  love yourself more.",
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: Container(
                          height: 40.0,
                          padding: EdgeInsets.only(left: 20.0),
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            color: Colors.white,
                            label: Text(
                              'Create',
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              size: 20.0,
                            ),
                            onPressed: () {
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: '/suggest/topic'),
                                screen: SelectTopic(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: height,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              shrinkWrap: true,
              itemCount: noOfDates,
              itemBuilder: (context, index) =>
                  _eachCalDate(index, selectedIndex, context),
            ),
          ),
          SizedBox(height: 15),
        ]),
      ),
    );
  }
}
