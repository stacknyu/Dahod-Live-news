import 'dart:async';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoFileWidget extends StatefulWidget {
  final String url;

  VideoFileWidget({required this.url});

  @override
  VideoFileWidgetState createState() => VideoFileWidgetState();
}

class VideoFileWidgetState extends State<VideoFileWidget> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url))..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CustomVideoPlayer(
      customVideoPlayerController: _customVideoPlayerController,
    );
  }
}
