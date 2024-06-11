import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/banner_ads_widget.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/components/see_all_button_widget.dart';
import 'package:news_flutter/model/category_model.dart';
import 'package:news_flutter/model/dashboard_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/category/category_list_screen.dart';
import 'package:news_flutter/screens/category/category_news_list_screen.dart';
import 'package:news_flutter/screens/dashboard/components/featured_news_home_widget.dart';
import 'package:news_flutter/screens/dashboard/components/greeting_widget.dart';
import 'package:news_flutter/screens/dashboard/components/news_list_view_widget.dart';
import 'package:news_flutter/screens/dashboard/components/news_sliding_widget.dart';
import 'package:news_flutter/screens/dashboard/short_news_screen.dart';
import 'package:news_flutter/screens/news/latest_news_list_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/home_fragment_shimmer.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

import 'package:news_flutter/main.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> with TickerProviderStateMixin {
  int page = 1;

  bool showNoData = false;
  bool isLoadingSwipeToRefresh = false;
  bool isDashboardDataLoaded = false;

  DateTime? currentBackPressTime;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
      init();
    });
  }

  Future<void> init() async {
    appStore.setToScrolling(true);

    _controller.addListener(() {
      /// scroll down
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        appStore.setToScrolling(false);
      }

      /// scroll up
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        appStore.setToScrolling(true);
      }
    });
    if (allowPreFetched) {
      if (appStore.getDashboardData() != null) setData(appStore.getDashboardData()!);
    }
  }

  void setData(DashboardModel dashboardData) {
    cachedDashBoardData = dashboardData;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast(language.lblPressBack);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SnapHelperWidget<DashboardModel>(
              initialData: cachedDashBoardData,
              future: getDashboardApi(page),
              errorWidget: NoDataWidget(title: language.somethingWentWrong, image: ic_no_data),
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  imageWidget: ErrorStateWidget(),
                  retryText: language.reload,
                  onRetry: () {
                    init();

                    setState(() {});
                  },
                );
              },
              loadingWidget: HomeFragmentShimmer(),
              onSuccess: (data) {
                return SingleChildScrollView(
                  controller: _controller,
                  padding: EdgeInsets.only(top: context.statusBarHeight + 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingWidget().paddingOnly(left: 16, top: 16, bottom: 8),

                      /// News Ticker
                      if (data.featureNewsMarquee.validate().isNotEmpty) ...[
                        SizedBox(
                          height: 36,
                          child: NewsSlidingWidget(
                              key: UniqueKey(),
                              text: parseHtmlString(data.featureNewsMarquee.validate()),
                              style: boldTextStyle(size: textSizeLargeMedium, weight: FontWeight.w700),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: context.width() * 0.8,
                              velocity: 50,
                              pauseAfterRound: const Duration(seconds: 1),
                              showFadingOnlyWhenScrolling: true,
                              fadingEdgeStartFraction: 0.1,
                              fadingEdgeEndFraction: 0.1,
                              numberOfRounds: 10,
                              startPadding: 20,
                              accelerationDuration: const Duration(seconds: 1),
                              decelerationDuration: const Duration(milliseconds: 500)),
                        ),
                        8.height,
                        Divider(),
                      ],
                      if (data.featurePost.validate().isNotEmpty) FeaturedNewsHomeWidget(recentNewsListing: data.featurePost.validate()),
                      16.height,
                      FutureBuilder<List<CategoryModel>>(
                        future: getCategories(page: page, perPage: 5),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            List<CategoryModel> categoryItems = snap.hasData ? snap.data! : jsonDecode(getStringAsync(categoryData)).map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
                            if (categoryItems.validate().isNotEmpty) {
                              setValue(categoryData, jsonEncode(categoryItems));
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(language.categories, style: boldTextStyle(size: textSizeMedium)).expand(),
                                      SeeAllButtonWidget(
                                        onTap: () => CategoryListScreen(isTab: false).launch(context),
                                        widget: Text(language.seeAll, style: primaryTextStyle(color: primaryColor, size: textSizeSMedium)),
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 16),
                                  SingleChildScrollView(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    scrollDirection: Axis.horizontal,
                                    child: AnimatedWrap(
                                      listAnimationType: ListAnimationType.FadeIn,
                                      fadeInConfiguration: FadeInConfiguration(delay: 250.milliseconds, curve: Curves.easeOutQuad),
                                      itemCount: categoryItems.take(5).length,
                                      itemBuilder: (context, index) {
                                        CategoryModel data = categoryItems[index];
                                        return GestureDetector(
                                          onTap: () {
                                            CategoryNewsListScreen(title: data.name, id: data.cat_ID, categoryModel: data).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 160,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: Stack(
                                              children: [
                                                Hero(
                                                  tag: data,
                                                  child: cachedImage(data.image.validate(), height: 100, width: 160, fit: BoxFit.cover),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                                      stops: [0.0, 1.0],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  left: 8,
                                                  right: 8,
                                                  child: Text(
                                                    parseHtmlString(data.name.validate()),
                                                    style: boldTextStyle(size: textSizeMedium, color: Colors.white),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ).paddingAll(8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ).paddingAll(4);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                      16.height,
                      if (!isAdsDisabled && data.banner.validate().isNotEmpty) ...[
                        BannerAdsWidget(bannerData: data.banner.validate()),
                        16.height,
                      ],
                      if (data.recentPost.validate().isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  language.latestNews,
                                  style: boldTextStyle(size: textSizeMedium),
                                ),
                                SeeAllButtonWidget(
                                  onTap: () {
                                    LatestNewsListScreen(
                                      title: language.latestNews,
                                      newsType: NewsListType.LATEST_NEWS,
                                    ).launch(context);
                                  },
                                  widget: Text(
                                    language.seeAll,
                                    style: primaryTextStyle(color: primaryColor, size: textSizeSMedium),
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 16),
                            NewsListViewWidget(latestNewsList: data.recentPost.validate())
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: Observer(
          builder: (_) => appStore.isFeatureListEmpty
              ? Offstage()
              : AnimatedSlide(
                  duration: Duration(milliseconds: 350),
                  offset: appStore.isScrolling ? Offset.zero : Offset(1, 0),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    child: Icon(Icons.newspaper, color: Colors.white),
                    onPressed: () {
                      ShortNewsScreen().launch(context);
                    },
                    backgroundColor: context.primaryColor,
                  ),
                ),
        ),
      ),
    );
  }
}
