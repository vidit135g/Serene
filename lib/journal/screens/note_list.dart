import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db_helper/db_helper.dart';
import '../modal_class/notes.dart';
import 'note_detail.dart';
import '../utils/widgets.dart';
import '../../shared/colors.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView();
    }

    Widget myAppBar() {
      return PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
              child: Container(
                  child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            toolbarHeight: 60,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mood',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' Journal',
                  style: GoogleFonts.nunito(
                    color: CustomColors.backgroundGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: <Widget>[
              noteList.length == 0
                  ? Container()
                  : IconButton(
                      icon: Icon(
                        axisCount == 2 ? Icons.list_alt_rounded : Icons.grid_on,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          axisCount = axisCount == 2 ? 4 : 2;
                        });
                      },
                    )
            ],
          ))));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: myAppBar(),
      body: noteList.length == 0
          ? Container(
              color: Colors.transparent,
              child: Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Click on the button \n  to make an entry!',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              padding:
                  EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18)),
              ),
              child: getNotesList(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: InkWell(
              onTap: () {
                navigateToDetail(Note('', '', 5, 0), 'Add Note');
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 14),
                decoration: BoxDecoration(
                  color: CustomColors.backgroundGreen,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.mood_sharp,
                      size: 20,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'HOW ARE YOU?',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ],
                ),
              ))),
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
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: colors[this.noteList[index].color],
                border: Border.all(width: 1, color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(20.0)),
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
      case 0:
        return Color(0xFFfd8c00);
        break;
      case 1:
        return Color(0xFFc753ff);
        break;
      case 2:
        return Color(0xFF3f72ff);
        break;
      case 3:
        return Color(0xFFfe5485);
        break;
      case 4:
        return Color(0xFF2ecba0);
        break;
      case 5:
        return Color(0xFfc3494e);
        break;
      default:
        return CustomColors.backgroundGreen;
    }
  }

  String getPrioritykey(int priority) {
    switch (priority) {
      case 0:
        return "Great";
        break;
      case 1:
        return "Good";
        break;
      case 2:
        return "Okay";
        break;
      case 3:
        return "Not Great";
        break;
      case 4:
        return "Bad";
        break;
      case 5:
        return "Amazed";
        break;
      default:
        return "Meh!";
    }
  }

  // Returns the priority icon
  String getPriorityText(int priority) {
    switch (priority) {
      case 0:
        return "assets/images/great.svg";
        break;
      case 1:
        return "assets/images/good.svg";
        break;
      case 2:
        return "assets/images/okay.svg";
        break;
      case 3:
        return "assets/images/notokay.svg";
        break;
      case 4:
        return "assets/images/sad.svg";
        break;
      case 5:
        return "assets/images/emhom.svg";
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
