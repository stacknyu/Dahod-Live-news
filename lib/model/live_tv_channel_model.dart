import 'package:news_flutter/utils/constant.dart';

class LiveTvChannelModel {
  String? channelName;
  String? channelURL;

  LiveTvChannelModel({this.channelName, this.channelURL});
}

List<LiveTvChannelModel> getLiveTvChannels() {
  return liveTvChannels;
}
