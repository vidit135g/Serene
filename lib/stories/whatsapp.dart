import 'package:flutter/material.dart';
import '../shared/colors.dart';
import 'repository.dart';
import 'util.dart';
import 'widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:story_view/story_view.dart';

class Whatsapp extends StatelessWidget {
  final int index;
  static int passedindex;
  const Whatsapp({
    Key key,
    this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    passedindex = index;
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoryViewDelegate(
              stories: snapshot.data,
            );
          }

          if (snapshot.hasError) {
            return ErrorView();
          }

          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: CustomColors.backgroundGreen,
              ),
            ),
          );
        },
        future: Repository.getWhatsappStories(index),
      ),
    );
  }
}

class StoryViewDelegate extends StatefulWidget {
  final List<WhatsappStory> stories;

  final Map<int, String> images = {
    0: "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/logo.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44",
    1: "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/logo.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44",
    2: "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/logo.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44",
    3: "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/logo.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44"
  };
  StoryViewDelegate({this.stories});

  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  String when = "";

  @override
  void initState() {
    super.initState();
    widget.stories.forEach((story) {
      if (story.mediaType == MediaType.image) {
        storyItems.add(StoryItem.pageImage(
          url: story.media,
          imageFit: BoxFit.scaleDown,
          controller: controller,
          duration: Duration(
            milliseconds: (story.duration * 1000).toInt(),
          ),
        ));
      }

      if (story.mediaType == MediaType.video) {
        storyItems.add(
          StoryItem.pageVideo(
            story.media,
            controller: controller,
            duration: Duration(milliseconds: (story.duration * 1000).toInt()),
          ),
        );
      }
    });

    when = widget.stories[0].when;
  }

  Widget _buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: Whatsapp.passedindex != 3
                ? NetworkImage(
                    "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/logo.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44")
                : NetworkImage(
                    "https://raw.githubusercontent.com/vidit135g/Jour/main/set4/calm.png?token=AEZC7NYD4WXTBLP2B7LDEX3AXRS44")),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Whatsapp.passedindex != 3
                    ? Text(
                        "Miss Mental",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Text(
                        "Calm",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              // Text(
              //   when,
              //   style: TextStyle(
              //     color: Colors.white38,
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StoryView(
          storyItems: storyItems,
          controller: controller,
          onComplete: () {
            Navigator.of(context).pop();
          },
          onVerticalSwipeComplete: (v) {
            if (v == Direction.down) {
              Navigator.pop(context);
            }
          },
          onStoryShow: (storyItem) {
            int pos = storyItems.indexOf(storyItem);

            // the reason for doing setState only after the first
            // position is becuase by the first iteration, the layout
            // hasn't been laid yet, thus raising some exception
            // (each child need to be laid exactly once)
            if (pos > 0) {
              setState(() {
                when = widget.stories[pos].when;
              });
            }
          },
        ),
        Container(
          padding: EdgeInsets.only(
            top: 45,
            left: 16,
            right: 16,
          ),
          child: _buildProfileView(),
        )
      ],
    );
  }
}
