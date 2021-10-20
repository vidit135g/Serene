import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'constants.dart';
import 'journal/db_helper/db_helper.dart';
import 'journal/modal_class/notes.dart';
import 'journal/screens/note_detail.dart';
import 'journal/screens/note_list.dart';
import 'mainhabits/pages/LoadingScreen.dart';
import 'mainhabits/pages/TodayView.dart';
import 'screens/Welcome/welcome_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/primaryscreen.dart';
import 'shared/colors.dart';
import 'shared/widgets/my_header.dart';
import 'utils/const.dart';
import 'widgets/accinfo.dart';
import 'widgets/category_card.dart';
import 'widgets/category_sub.dart';
import 'widgets/mood_card.dart';
import 'widgets/pop_habits.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sqflite/sqflite.dart';

import 'journal/utils/widgets.dart';
import 'mainhabits/data/provider/ProviderFactory.dart';
import 'mainhabits/data/provider/WidgetDataProvider.dart';
import 'mainhabits/pages/AllHabits.dart';
import 'mainhabits/pages/AllTimeOfDay.dart';
import 'mainhabits/pages/EditHabit.dart';
import 'mainhabits/pages/HabitProgress.dart';
import 'mainhabits/pages/NewHabit.dart';
import 'mainhabits/pages/ProgressMain.dart';
import 'mainhabits/pages/SelectHabit.dart';
import 'mainhabits/pages/SelectTopic.dart';
import 'mainhabits/pages/Settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeAndroidWidgets();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([]).then((_) {
    runApp(MyApp());
  });
}

void initializeAndroidWidgets() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();

    final callback = PluginUtilities.getCallbackHandle(doWidgetUpdate);
    final handle = callback.toRawHandle();

    const MethodChannel channel = MethodChannel(channelAppWidget);
    channel.invokeMethod('initialize', handle);
  }
}

void doWidgetUpdate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProviderFactory.initDB();
  await ProviderFactory.settingsProvider.init();

  const MethodChannel channel = MethodChannel(channelAppWidget);
  channel.setMethodCallHandler(getAppWidgetData);
}

class MyApp extends StatefulWidget {
  final providerFactory = ProviderFactory();
  final sp = ProviderFactory.settingsProvider;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loading = true;

  @override
  initState() {
    super.initState();

    ProviderFactory.init().then(
      (sts) => setState(() {
        loading = false;
      }),
    );
  }

  @override
  void dispose() async {
    await ProviderFactory.close();
    super.dispose();
  }

  ThemeData _theme(BuildContext context) {
    var isDarkMode = widget.sp.darkMode;

    var lightThemeColor = CustomColors.darkhabit;
    var darkThemeColor = CustomColors.backgroundGreen;
    var lightSubtitleColor = Colors.black.withAlpha(130);
    var darkSubtitleColor = Colors.white.withAlpha(180);

    return ThemeData(
      fontFamily: "Nunito",
      accentColor: isDarkMode ? darkThemeColor : lightThemeColor,
      primaryColor: isDarkMode ? darkThemeColor : lightThemeColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
          subtitle2: TextStyle(
              color: isDarkMode ? darkSubtitleColor : lightSubtitleColor)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: isDarkMode ? Colors.grey.withOpacity(0.25) : Colors.white,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// Assign widget based on availability of currentUser
    return loading
        ? Loading()
        : MaterialApp(
            home: Welcome(),
            routes: {
              '/today': (context) => TodayView(),
              '/prime': (context) => PrimaryScreen(),
              '/habit/progress': (context) => HabitProgress(),
              '/habit/all': (context) => AllHabits(),
              '/progress': (context) => ProgressMain(),
              '/settings': (context) => Settings(
                    themeChanged: (val) => setState(() {
                      loading = false;
                    }),
                  ),
              '/settings/time-of-day': (context) => AllTimeOfDay(),
              '/new': (context) => NewHabit(),
              '/suggest/topic': (context) => SelectTopic(),
              '/suggest/habit': (context) => SelectHabit(),
              '/edit': (context) => EditHabit(),
              '/second': (context) => Welcome(),
            },
          );
  }
}

class MainScreen extends StatefulWidget {
  final String user;
  final String photo;
  const MainScreen({Key key, this.user, this.photo}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = ScrollController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  int axisCount = 2;
  double offset = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(onScroll);
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void dispose() async {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageList = [
      "assets/images/meditate.png",
      "assets/images/workout.png",
      "assets/images/health.png",
      "assets/images/water.png",
    ];
    final textList = [
      "Meditate",
      "Workout",
      "healthy Diet",
      "Water Intake",
    ];
    if (noteList == null) {
      noteList = [];
    }
//this gonna give us total height and with of our device
    return Scaffold(
      //bottomNavigationBar: BottomNavigationBarTravel(),
      extendBodyBehindAppBar: false,

      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: SafeArea(
            child: Container(
              color: const Color(0xFF8C2480),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: NoteList(),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.white)))),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/images/emhom.svg",
                              height: 22,
                              width: 22,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Mood",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )),
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
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(widget.photo))),
                            child: widget.photo != null
                                ? InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: widget.user,
                                              img: widget.photo,
                                            );
                                          });
                                    }, // Handle your callback
                                    child: Ink(
                                        height: 45,
                                        width: 45,
                                        color: Colors.transparent),
                                  )
                                : ClipOval(
                                    child: Material(
                                      color: CustomColors.backgroundGreen
                                          .withOpacity(0.3),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 60,
                                          color: CustomColors.backgroundGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
      body: Stack(
        children: <Widget>[
          new ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                MyHeader(
                  user: widget.user,
                )
              ]),
          new ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  padding:
                      new EdgeInsets.only(top: 320, right: 20.0, left: 20.0),
                  child: new Container(
                    height: 350,
                    // Here the height of the container is 45% of our total height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 17),
                          blurRadius: 17,
                          spreadRadius: -23,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipPath(
                            clipper: SubClipper(),
                            child: Container(
                              width: double.maxFinite,
                              // Here the height of the container is 45% of our total height
                              height: 140,

                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/images/selflo.jpg"),
                                ),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.wb_sunny,
                                        size: 16,
                                        color: CustomColors.backgroundGreen,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " Daily Journal",
                                      style: GoogleFonts.nunito(
                                        color: CustomColors.backgroundGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              // Text(
                              //   "Good Morning, Jai!",
                              //   style: GoogleFonts.nunito(
                              //     color: Colors.black,
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.w700,
                              //   ),
                              // ),
                              ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              "How are you feeling today?",
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SubCard(
                                  title: "Great",
                                  svgSrc: "assets/images/great.svg",
                                  accent: CustomColors.backgroundGreen,
                                  press: () {
                                    navigateToDetail(
                                        Note('', '', 0, 0), 'Feeling Great!');
                                  },
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                SubCard(
                                  title: "Good",
                                  svgSrc: "assets/images/good.svg",
                                  accent: CustomColors.backgroundGreen,
                                  press: () {
                                    navigateToDetail(
                                        Note('', '', 1, 0), 'Feeling Good!');
                                  },
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                SubCard(
                                  title: "Okay",
                                  svgSrc: "assets/images/okay.svg",
                                  accent: CustomColors.backgroundGreen,
                                  press: () {
                                    navigateToDetail(
                                        Note('', '', 2, 0), 'Feeling okay.');
                                  },
                                ),
                              ]),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SubCard(
                                  title: "Not Great",
                                  svgSrc: "assets/images/notokay.svg",
                                  accent: CustomColors.backgroundGreen,
                                  press: () {
                                    navigateToDetail(
                                        Note('', '', 3, 0), 'Not Okay.');
                                  },
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                SubCard(
                                  title: "Bad",
                                  svgSrc: "assets/images/sad.svg",
                                  accent: CustomColors.backgroundGreen,
                                  press: () {
                                    navigateToDetail(
                                        Note('', '', 4, 0), 'Feeling Sad.');
                                  },
                                ),
                              ])
                        ],
                      ),
                    ),
                  )),
              PopHabits(),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 40),
                    height: 600,
                    child: NoteList(),
                  ))
            ],
          ),

          // new Column(children: <Widget>[PopHabits()]),
          // Here the height of the container is 45% of our total height
        ],
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToDetail(this.noteList[index], 'Edit Note');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: colors[this.noteList[index].color],
                border: Border.all(width: 1.5, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset(
                      getPriorityText(this.noteList[index].priority),
                      height: 20,
                      width: 20,
                    ),
                    Text(
                        getPrioritykey(this.noteList[index].priority)
                            .toString(),
                        style: GoogleFonts.nunito(
                          color:
                              getPriorityColor(this.noteList[index].priority),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                              this.noteList[index].description == null
                                  ? ''
                                  : this.noteList[index].description,
                              style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              )))
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(this.noteList[index].date,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          )),
                    ])
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Color(0xFFfd8c00);
        break;
      case 2:
        return Color(0xFFc753ff);
        break;
      case 3:
        return Color(0xFF3f72ff);
        break;
      case 4:
        return Color(0xFFfe5485);
        break;
      case 5:
        return Color(0xFF2ecba0);
        break;
      default:
        return CustomColors.backgroundGreen;
    }
  }

  String getPrioritykey(int priority) {
    switch (priority) {
      case 1:
        return "Great";
        break;
      case 2:
        return "Good";
        break;
      case 3:
        return "Okay";
        break;
      case 4:
        return "Not Great";
        break;
      case 5:
        return "Bad";
        break;

      default:
        return "assets/images/great.svg";
    }
  }

  // Returns the priority icon
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return "assets/images/great.svg";
        break;
      case 2:
        return "assets/images/good.svg";
        break;
      case 3:
        return "assets/images/okay.svg";
        break;
      case 4:
        return "assets/images/notokay.svg";
        break;
      case 5:
        return "assets/images/sad.svg";
        break;

      default:
        return "assets/images/great.svg";
    }
  }

  // void _delete(BuildContext context, Note note) async {
  //   int result = await databaseHelper.deleteNote(note.id);
  //   if (result != 0) {
  //     _showSnackBar(context, 'Note Deleted Successfully');
  //     updateListView();
  //   }
  // }

  // void _showSnackBar(BuildContext context, String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
