
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/category_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/category/category_news_list_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/category_list_component_shimmer.dart';
import 'package:news_flutter/utils/cached_data.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

class CategoryListScreen extends StatefulWidget {
  final bool? isTab;

  CategoryListScreen({this.isTab});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> with TickerProviderStateMixin {
  List<CategoryModel> categoryList = [];
  var scrollController = ScrollController();

  bool isLastPage = false;
  bool isError = false;
  String error = '';

  int page = 1;

  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);

    myBanner = buildBannerAd()..load();
    init();

    fetchCategoryData(page: 1, perPageItem: perPageItemInCategory);
    scrollController.addListener(() {
      if (!isLastPage && (scrollController.position.pixels - 100 == scrollController.position.maxScrollExtent - 100)) {
        page++;
        appStore.setLoading(true);
        setState(() {});
        fetchCategoryData(page: page);
        appStore.setLoading(false);
      }
    });
    afterBuildCreated(() {});
  }

  Future<void> init() async {
    if (allowPreFetched) {
      if (CachedData.getCachedData(cachedKey: cachedCategoryList) != null)
        categoryList.addAll((CachedData.getCachedData(cachedKey: cachedCategoryList) as List).map((e) => CategoryModel.fromJson(e)).toList());
    }

    if (await isNetworkAvailable()) {
      fetchCategoryData(page: 1, perPageItem: perPageItemInCategory);
    }
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

  Future<void> fetchCategoryData({int page = 1, int perPageItem = perPageItemInCategory}) async {
    appStore.setLoading(true);
    await getCategories(page: page, perPage: perPageItem).then((res) async {
      appStore.setLoading(false);
      if (page == 1) {
        categoryList.clear();
        CachedData.storeResponse(responseKey: cachedCategoryList, listData: res.map((e) => e.toJson()).toList());
      }

      setData(res);
      return res;
    }).catchError((e) {
      isError = !isError;
      error = error.toString();
      setState(() {});
      appStore.setLoading(false);
      throw e;
    });
  }

  void setData(List<CategoryModel> res) {
    isLastPage = res.length != perPageCategory;
    categoryList.addAll(res);

    afterBuildCreated(() {});
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.categories,
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        elevation: 0.2,
        showBack: !widget.isTab!,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: Stack(
        children: [
          if (categoryList.validate().isEmpty && !appStore.isLoading)
            NoDataWidget(title: language.noRecordFound, image: ic_no_data).center().visible(!appStore.isLoading && categoryList.isEmpty)
          else if (categoryList.validate().isEmpty && appStore.isLoading)
            CategoryListComponentShimmer()
          else
            AnimatedScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              onSwipeRefresh: () {
                return fetchCategoryData();
              },
              children: [
                AnimatedWrap(
                  listAnimationType: ListAnimationType.Scale,
                  scaleConfiguration: ScaleConfiguration(delay: 100.milliseconds, curve: Curves.easeOutQuad),
                  spacing: 8,
                  runSpacing: 8,
                  itemCount: categoryList.length,
                  itemBuilder: (ctx, index) {
                    CategoryModel category = categoryList[index];

                    return GestureDetector(
                      onTap: () {
                        CategoryNewsListScreen(title: category.name, id: category.cat_ID, categoryModel: category).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                      },
                      child: Container(
                        height: 120,
                        width: context.width() / 2 - 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          color: context.cardColor,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            Hero(
                              tag: category,
                              child: cachedImage(category.image.validate(), height: 120, width: (context.width() / 2) - 12, fit: BoxFit.cover),
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
                                parseHtmlString(category.name.validate()),
                                style: boldTextStyle(size: textSizeLargeMedium, color: Colors.white),
                              ).paddingAll(8),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).paddingSymmetric(vertical: 16).visible(appStore.isLoading && page != 1);
                  },
                )
              ],
            ),
          NoDataWidget(
            title: error,
            retryText: language.reload,
            onRetry: () {
              setState(() {
                page = 1;
                isError = false;
              });
              fetchCategoryData();
            },
          ).visible(isError)
        ],
      ),
      bottomNavigationBar: !isAdsDisabled && !widget.isTab!
          ? Container(
              height: AdSize.banner.height.toDouble(),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
            )
          : SizedBox(),
    );
  }
}
