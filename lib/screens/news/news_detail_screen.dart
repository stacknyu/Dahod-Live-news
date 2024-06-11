import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/blog_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/components/news_detail_page_variant_first_widget.dart';
import 'package:news_flutter/screens/news/components/news_detail_page_variant_second_widget.dart';
import 'package:news_flutter/screens/news/components/news_detail_page_variant_third_widget.dart';
import 'package:news_flutter/screens/shimmerScreen/news_detail_page_variant_first_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/news_detail_page_variant_second_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/news_detail_page_variant_third_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  NewsDetailScreen({required this.newsId});

  @override
  NewsDetailScreenState createState() => NewsDetailScreenState();
}

class NewsDetailScreenState extends State<NewsDetailScreen> {
  Future<PostModel>? future;

  BlogModel? blogDetail;

  int fontSize = 18;
  String postContent = '';

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    future = getBlogDetail({'post_id': widget.newsId});
    await getPostDetails(postId: widget.newsId).then((value) {
      blogDetail = value;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
    if (!isAdsDisabled) {
      if (mInterstitialAdCount < 5) {
        mInterstitialAdCount++;
      } else {
        mInterstitialAdCount = 0;
        buildInterstitialAd();
      }
    }
  }

  void buildInterstitialAd() {
    InterstitialAd.load(
      adUnitId: INTERSTITIAL_AD_ID_FOR_ANDROID,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          print('$ad loaded');
          await Future.delayed(Duration.zero);
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
        },
      ),
    );
  }

  Future<void> savePostResponse(PostModel res, int id) async {
    setValue('$newsDetailData${widget.newsId}', jsonEncode(res));
    appStore.setCachedNewsAndArticles(res);
  }

  Widget getShimmer() {
    if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
      return NewsDetailPageVariantFirstShimmer();
    } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2) {
      return NewsDetailPageVariantSecondShimmer();
    } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 3) {
      return NewsDetailPageVariantThirdShimmer();
    } else {
      return ShimmerWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnapHelperWidget<PostModel>(
            future: future,
            initialData: appStore.getCachedNews(widget.newsId),
            onSuccess: (data) {
              postContent = getPostContent(data.postContent.validate());
              if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 1) {
                return NewsDetailPageVariantFirstWidget(post: data, blogPost: blogDetail, postContent: postContent);
              } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 2) {
                return NewsDetailPageVariantSecondWidget(post: data, blogPost: blogDetail, postContent: postContent);
              } else if (getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == 3) {
                return NewsDetailPageVariantThirdWidget(post: data, blogPost: blogDetail, postContent: postContent);
              } else
                return SizedBox();
            },
            loadingWidget: getShimmer(),
            errorBuilder: (error) {
              return NoDataWidget(
                title: error.toString(),
                retryText: language.reload,
                onRetry: () {
                  init();

                  setState(() {});
                },
              );
            },
            errorWidget: ErrorStateWidget(),
          ),
        ],
      ),
    );
  }
}
