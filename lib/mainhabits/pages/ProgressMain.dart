import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/progress/CompletionRate.dart';
import '../widgets/progress/DailyTracker.dart';
import '../widgets/progress/DayWisePerfomance.dart';
import '../widgets/progress/StatusSummary.dart';
import '../widgets/progress/WeeklyProgress.dart';
import '../../shared/colors.dart';
import '../../shared/widgets/blog_jumbo.dart';
import '../../stories/whatsapp.dart';
import '../../utils/const.dart';
import '../../widgets/category_sub.dart';

import '../../constants.dart';

class ProgressMain extends StatelessWidget {
  PreferredSize _appBar(context) {
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
                  "Progress",
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

  @override
  Widget build(BuildContext context) {
    var _selectedNavIndex = 1;

    var _widgetList = <Widget>[
      ProgressHeader(),
      SizedBox(height: 0),
      WeeklyProgress(),
      CompletionRate(),
      DayWisePerfomance(),
      DailyTracker(),
    ];

    return new Scaffold(
      appBar: _appBar(context),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: _widgetList.length,
              itemBuilder: (context, index, anim) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(child: _widgetList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 4, right: 12),
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            image: AssetImage("assets/images/love.jpg"),
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
              SizedBox(height: 45),
              Padding(
                padding: EdgeInsets.only(right: 25),
                child: Text(
                  "\"Changes call for innovation, \nand innovation leads to progress.\"",
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
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
                        'Summary',
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: Icon(
                        Icons.info_rounded,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Dialog errorDialog = Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0)), //this right here
                          child: Container(
                            height: 300.0,
                            width: 300.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Summary',
                                    style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3.0)),
                                StatusSummary(),
                              ],
                            ),
                          ),
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => errorDialog);
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SubClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
