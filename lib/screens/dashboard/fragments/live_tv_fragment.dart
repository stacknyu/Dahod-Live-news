import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/screens/shimmerScreen/live_tv_fragment_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:news_flutter/utils/images.dart';

class LiveTvFragment extends StatefulWidget {
  const LiveTvFragment({Key? key}) : super(key: key);

  @override
  State<LiveTvFragment> createState() => _LiveTvFragmentState();
}

class _LiveTvFragmentState extends State<LiveTvFragment> {
  int index = 0;

  bool isHideTvChannelList = false;
  BannerAd? myBanner;
  bool isAdBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColor(Colors.transparent, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
  }

  Future<void> init() async {
    myBanner = buildBannerAd()..load();
    await Duration(milliseconds: 100).delay;
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdBannerLoaded = !isAdBannerLoaded;
          setState(() {});
        },
      ),
      request: AdRequest(),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: context.statusBarHeight),
        child: Observer(
          builder: (BuildContext context) {
            return SizedBox(
              height: context.height(),
              width: context.width(),
              child: Stack(
                children: [
                  appStore.isLoading
                      ? LiveTvFragmentShimmer()
                      : liveTvChannels.isNotEmpty
                          ? Column(
                              children: [
                                if (!isHideTvChannelList)
                                  Container(
                                    padding: EdgeInsets.only(left: 16, top: 16),
                                    width: context.width(),
                                    height: 56,
                                    child: Row(
                                      children: [
                                        Text(liveTvChannels[index].channelName.validate(), style: boldTextStyle(size: 20)).expand(),
                                      ],
                                    ),
                                  ),
                                LiveYoutubePlayerWidget(
                                  ValueKey(index),
                                  liveTvChannels[index].channelURL.validate(),
                                  (isHideList) {
                                    isHideTvChannelList = isHideList;
                                    setState(() {});
                                  },
                                ).expand(flex: isHideTvChannelList ? 1 : 0),
                                if (!isHideTvChannelList)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(height: 0).paddingTop(8),
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (!isAdBannerLoaded)
                                              ShimmerWidget(
                                                child: Container(
                                                  height: 50,
                                                  margin: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                                                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius(0)),
                                                ),
                                              )
                                            else if (isAdsDisabled && myBanner != null)
                                              Container(
                                                color: context.scaffoldBackgroundColor,
                                                height: 60,
                                                child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                                              ).paddingSymmetric(vertical: 16),
                                            Text(language.watchLiveNews, style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16, vertical: 16),
                                            Wrap(
                                              runSpacing: 16,
                                              spacing: 16,
                                              children: List.generate(liveTvChannels.length, (i) {
                                                return Container(
                                                  width: context.width() / 2 - 24,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: index == i ? primaryColor : Colors.transparent, width: index == i ? 1 : 0),
                                                    borderRadius: BorderRadius.circular(defaultRadius),
                                                    color: context.cardColor,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      cachedImage(
                                                        liveTvChannels[i].channelURL.validate().getYouTubeThumbnail(),
                                                        fit: BoxFit.cover,
                                                        height: 100,
                                                        width: context.width() / 2,
                                                      ).cornerRadiusWithClipRRect(defaultRadius),
                                                      Container(
                                                        height: 100,
                                                        width: context.width() / 2,
                                                        decoration: boxDecorationDefault(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              ...List.generate(
                                                                6,
                                                                (index) => Colors.black.withAlpha(index * 36),
                                                              )
                                                            ],
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        child: Text(
                                                          liveTvChannels[i].channelName.validate(),
                                                          style: boldTextStyle(size: 14, color: Colors.white),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        bottom: 8,
                                                        left: 8,
                                                        right: 8,
                                                      )
                                                    ],
                                                  ),
                                                ).onTap(() {
                                                  index = i;
                                                  setState(() {});
                                                }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                                              }),
                                            ).paddingSymmetric(horizontal: 16)
                                          ],
                                        ),
                                      ).expand(),
                                    ],
                                  ).expand(),
                              ],
                            )
                          : NoDataWidget(title: language.noRecordFound, image: ic_no_data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LiveYoutubePlayerWidget extends StatefulWidget {
  final String liveTvURL;
  final Key key;
  final Function(bool) onScreenChange;

  LiveYoutubePlayerWidget(this.key, this.liveTvURL, this.onScreenChange);

  @override
  _YoutubePlayerWidgetState1 createState() => _YoutubePlayerWidgetState1();
}

class _YoutubePlayerWidgetState1 extends State<LiveYoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.liveTvURL.toYouTubeId(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: true,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      key: widget.key,
      onEnterFullScreen: () {
        widget.onScreenChange.call(true);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      },
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        widget.onScreenChange.call(false);
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
