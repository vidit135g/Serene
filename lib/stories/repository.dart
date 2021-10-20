import 'dart:convert';

import 'package:http/http.dart';

enum MediaType { image, video, text }

class WhatsappStory {
  final MediaType mediaType;
  final String media;
  final double duration;
  final String when;
  final String color;

  WhatsappStory({
    this.mediaType,
    this.media,
    this.duration,
    this.when,
    this.color,
  });
}

class Highlight {
  final String image;
  final String headline;

  Highlight({this.image, this.headline});
}

class Gnews {
  final String title;
  final List<Highlight> highlights;

  Gnews({this.title, this.highlights});
}

/// The repository fetches the data from the same directory from git.
/// This is just to demonstrate fetching from a remote (workflow).
class Repository {
  static MediaType _translateType(String type) {
    if (type == "image") {
      return MediaType.image;
    }

    if (type == "video") {
      return MediaType.video;
    }

    return MediaType.text;
  }

  static Future<List<WhatsappStory>> getWhatsappStories(int index) async {
    var list = [
      "https://raw.githubusercontent.com/vidit135g/Jour/main/set1/whatsapp.json",
      "https://raw.githubusercontent.com/vidit135g/Jour/main/set2/whatsapp.json",
      "https://raw.githubusercontent.com/vidit135g/Jour/main/set3/whatsapp.json",
      "https://raw.githubusercontent.com/vidit135g/Jour/main/set4/whatsapp.json"
    ];
    final response = await get(Uri.parse(list[index]));

    final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];

    final res = data.map<WhatsappStory>((it) {
      return WhatsappStory(
          media: it['media'],
          duration: double.parse(it['duration']),
          when: it['when'],
          mediaType: _translateType(it['mediaType']),
          color: it['color']);
    }).toList();

    return res;
  }

  static Future<Gnews> getNews() async {
    final response = await get(Uri.parse(
        "https://raw.githubusercontent.com/blackmann/storyexample/master/lib/data/gnews.json"));

    // use utf8.decode to make emojis work
    final data = jsonDecode(utf8.decode(response.bodyBytes))['data'];

    final title = data['title'];
    final highlights = data['highlights'].map<Highlight>((it) {
      return Highlight(headline: it['headline'], image: it['image']);
    }).toList();

    return Gnews(title: title, highlights: highlights);
  }
}
