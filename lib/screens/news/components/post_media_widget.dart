import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/screens/news/components/video_file_widget.dart';
import 'package:news_flutter/screens/news/components/youtube_iframe_player.dart';

class PostMediaWidget extends StatelessWidget {
  final PostModel postModel;

  PostMediaWidget(this.postModel);

  @override
  Widget build(BuildContext context) {
    if (postModel.videoType.validate() == "iframe") {
      if (postModel.videoUrl.validate().contains('https://player.vimeo.com/')) {
        String iframe = getVideoLink(postModel.videoUrl.validate());
        String videoId = iframe.validate().split('/').last.split('?').first;
        return FutureBuilder<String>(
          future: getQualitiesAsync(videoId),
          builder: (ctx, snap) {
            if (snap.hasData) {
              return VideoFileWidget(url: snap.data.validate());
            }
            return SizedBox(width: context.width(), height: 280, child: Loader());
          },
        );
      } else {
        return YoutubePlayerWidget(iframe: postModel.videoUrl.validate());
      }
    } else if (postModel.videoType == "custom_url") {
      return VideoFileWidget(url: postModel.videoUrl.validate());
    } else {
      return YoutubePlayerWidget(iframe: postModel.videoUrl.validate());
    }
  }

  String getVideoLink(String htmlData) {
    var document = parse(htmlData);
    dom.Element? link = document.querySelector('iframe');
    String? iframeLink = link != null ? link.attributes['src'].validate() : '';
    return iframeLink.validate();
  }

  Future<String> getQualitiesAsync(String videoId) async {
    try {
      var response = await http.get(Uri.parse('https://player.vimeo.com/video/' + videoId.validate() + '/config'));
      var jsonData = jsonDecode(response.body)['request']['files']['progressive'];
      SplayTreeMap videoList = SplayTreeMap.fromIterable(jsonData, key: (item) => "${item['quality']} ${item['fps']}", value: (item) => item['url']);
      return videoList[videoList.lastKey()];
    } catch (error) {
      log('=====> REQUEST ERROR: $error');
      return "";
    }
  }
}
