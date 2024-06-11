import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/news_item_shimmer.dart';
import 'package:news_flutter/utils/cached_data.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';
import 'package:news_flutter/screens/news/components/news_item_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/utils/constant.dart';

// ignore: unused_import
import 'package:news_flutter/utils/images.dart';

import '../../main.dart';

class LatestNewsListScreen extends StatefulWidget {
  final String? title;
  final NewsListType newsType;

  LatestNewsListScreen({this.title, required this.newsType});

  @override
  LatestNewsListScreenState createState() => LatestNewsListScreenState();
}

class LatestNewsListScreenState extends State<LatestNewsListScreen> {
  List<PostModel> recentNewsListing = [];

  String error = '';

  int page = 1;
  int recentNumPages = 1;

  BannerAd? myBanner;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (allowPreFetched) {
      if (CachedData.getCachedData(cachedKey: cachedLatestNewsList) != null) if (widget.newsType == NewsListType.FEATURE_NEWS) {
        recentNewsListing.addAll((CachedData.getCachedData(cachedKey: cachedLatestNewsList) as List).map((e) => PostModel.fromJson(e)).toList());
      } else {
        recentNewsListing.addAll((CachedData.getCachedData(cachedKey: cachedLatestNewsList) as List).map((e) => PostModel.fromJson(e)).toList());
      }
    }

    myBanner = buildBannerAd()..load();

    fetchLatestData();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.largeBanner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  Future<void> fetchLatestData() async {
    appStore.setLoading(true);
    await getDashboardApi(page).then((value) async {
      appStore.setLoading(false);
      if (page == 1) {
        recentNewsListing.clear();
        CachedData.storeResponse(responseKey: cachedFeatureNewsList, listData: value.featurePost.validate().map((e) => e.toJson()).toList());
        CachedData.storeResponse(responseKey: cachedLatestNewsList, listData: value.recentPost.validate().map((e) => e.toJson()).toList());
      }
      if (widget.newsType == NewsListType.FEATURE_NEWS) {
        recentNumPages = value.featureNumPages.validate();
        recentNewsListing.addAll(value.featurePost.validate());
      } else {
        recentNumPages = value.recentNumPages.validate();
        recentNewsListing.addAll(value.recentPost.validate());
      }
      setState(() {});
    }).catchError((e) {
      error = e.toString();
      isError = !isError;
      setState(() {});
      appStore.setLoading(false);

      throw e;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        parseHtmlString(widget.title),
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Stack(
        children: [
          if (recentNewsListing.isNotEmpty)
            AnimatedScrollView(
              slideConfiguration: SlideConfiguration(delay: 250.milliseconds, curve: Curves.easeOutQuad, verticalOffset: context.height() * 0.1),
              padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 50),
              onSwipeRefresh: () async {
                setState(() {
                  page = 1;
                });
                await fetchLatestData();
              },
              onNextPage: () {
                if (recentNumPages > page) {
                  page++;
                  appStore.setLoading(true);
                  fetchLatestData();
                }
              },
              children: [
                ...List.generate(recentNewsListing.length, (i) {
                  return NewsItemWidget(recentNewsListing[i], index: i).onTap(() {
                    NewsDetailScreen(newsId: recentNewsListing[i].toString()).launch(context);
                  });
                }),
                Observer(
                  builder: (context) {
                    return LoadingDotsWidget().paddingSymmetric(vertical: 32).visible(recentNumPages > 1 && appStore.isLoading);
                  },
                )
              ],
            ),
          NewsItemShimmer().visible(appStore.isLoading && recentNewsListing.isEmpty && recentNumPages == 1),
          EmptyStateWidget().visible(!appStore.isLoading && recentNewsListing.isEmpty && !isError),
          NoDataWidget(
            title: error,
            retryText: language.reload,
            onRetry: () {
              setState(() {
                page = 1;
                isError = false;
              });
              fetchLatestData();
            },
          ).visible(isError)
        ],
      ),
    );
  }
}
