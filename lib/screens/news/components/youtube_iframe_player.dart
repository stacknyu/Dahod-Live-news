import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String iframe;

  YoutubePlayerWidget({required this.iframe});

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  bool _isPlayerReady = false;
  String iframeId = "";

  @override
  void initState() {
    super.initState();
    setStatusBarColor(
      appStore.isDarkMode ? card_color_dark : card_color_light,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );

    if (widget.iframe.startsWith("http")) {
      iframeId = widget.iframe.toYouTubeId();
    } else {
      var document = parse(widget.iframe);
      dom.Element? link = document.querySelector('iframe');
      String? iframeUrl = link != null ? link.attributes['src'] : '';
      iframeId = iframeUrl.toYouTubeId();
    }

    _controller = YoutubePlayerController(
      initialVideoId: "GO_diH5XB0I",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      _controller.setVolume(100);
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        liveUIColor: primaryColor,
        progressColors: ProgressBarColors(
          playedColor: primaryColor,
          bufferedColor: Colors.grey.shade400,
          backgroundColor: Colors.white.withOpacity(0.2),
          handleColor: primaryColor,
        ),
        progressIndicatorColor: primaryColor,
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller.pause();
        },
      ),
      builder: (context, player) {
        return player;
      },
    );
  }
}
