
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/components/internet_connectivity_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';
import 'package:news_flutter/model/category_model.dart';
import 'package:news_flutter/model/post_list_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/components/news_item_widget.dart';
import 'package:news_flutter/screens/shimmerScreen/category_list_component_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';
import 'package:news_flutter/utils/cached_data.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';

import '../../main.dart';

class CategoryNewsListScreen extends StatefulWidget {
  static String tag = '/NewsListScreen';

  final String? title;
  final int? id;
  final List? recentPost;
  final CategoryModel? categoryModel;

  CategoryNewsListScreen({this.id, this.title, this.recentPost, this.categoryModel});

  @override
  CategoryNewsListScreenState createState() => CategoryNewsListScreenState();
}

class CategoryNewsListScreenState extends State<CategoryNewsListScreen> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late Animation _iconTweenColor;

  List<PostModel> categoriesWiseNewListing = [];
  List<CategoryModel> mSubCategory = [];
  List<String> subCategories = [];

  Future<PostListModel>? future;

  int page = 1;
  int numPages = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 0));
    _iconTweenColor = ColorTween(begin: Colors.white, end: appStore.isDarkMode ? Colors.white : Colors.black).animate(_controller);

    super.initState();

    afterBuildCreated(() => init());
    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (numPages > page) {
          page++;
          fetchCategoriesWiseNewsData(widget.id);
        }
      }
    });
  }

  Future<void> init() async {
    if (allowPreFetched) {
      if ((CachedData.getCachedData(cachedKey: '$cachedCategoryWiseNewsList${widget.id}') != null))
        categoriesWiseNewListing.addAll((CachedData.getCachedData(cachedKey: '$cachedCategoryWiseNewsList${widget.id}') as List).map((e) => PostModel.fromJson(e)).toList());
    }

    fetchCategoriesWiseNewsData(widget.id);
    fetchSubCategoriesData();
  }

  void fetchSubCategoriesData() {
    getCategories(parent: widget.id.validate()).then((res) {
      if (!mounted) return;
      mSubCategory = res;

      if (mSubCategory.length > 0) {
        subCategories.clear();
        subCategories.add('All');

        mSubCategory.forEach((element) {
          subCategories.add(element.name.toString());
        });

        setState(() {});
      }
    }).catchError((error) {
      if (!mounted) return;
      toast(error.toString());
    });
  }

  Future<void> fetchCategoriesWiseNewsData(int? id, {int? subCatId}) async {
    appStore.setLoading(true);

    Map req = {
      'category': id,
      'filter': 'by_category',
    };

    if (subCatId != null) {
      req.putIfAbsent('subcategory', () => subCatId);
    }

    await getBlogList(req, page).then((res) {
      appStore.setLoading(false);
      CachedData.storeResponse(responseKey: '$cachedCategoryWiseNewsList$id', listData: res.posts.validate().map((e) => e.toJson()).toList());
      numPages = res.num_pages!.toInt();
      if (page == 1) {
        categoriesWiseNewListing.clear();
      }
      categoriesWiseNewListing.addAll(res.posts!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      if (!mounted) return;
      toast(error.toString());
    });
    appStore.setLoading(false);
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _controller.animateTo(scrollInfo.metrics.pixels / 200);

      return true;
    }
    return false;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldBackgroundDarkColor : Colors.white,
      statusBarBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener(
        onNotification: _scrollListener,
        child: Observer(
          builder: (context) => InternetConnectivityWidget(
            retryCallback: () {
              init();
              setState(() {});
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return SliverAppBar(
                      pinned: true,
                      onStretchTrigger: () async {},
                      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => finish(context),
                        color: _iconTweenColor.value,
                      ),
                      expandedHeight: 200.0,
                      backgroundColor: context.cardColor,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        title: Text(parseHtmlString(widget.categoryModel!.name.validate()), style: boldTextStyle(color: _iconTweenColor.value)),
                        background: DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                            ),
                          ),
                          child: Hero(
                            tag: widget.categoryModel!,
                            child: cachedImage(widget.categoryModel!.image.validate(), width: context.width(), height: 200, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: HorizontalList(
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      if (appStore.isLoading)
                        return ShimmerWidget(
                          child: Row(
                            children: List.generate(
                              subCategories.length,
                              (index) => ShimmerWidget(
                                child: Container(width: 60, margin: EdgeInsets.only(right: 16), height: 30, decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10)),
                              ).paddingTop(16),
                            ),
                          ),
                        );
                      else
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              page = 1;
                              if (index == 0) {
                                categoriesWiseNewListing.clear();
                                fetchCategoriesWiseNewsData(widget.id);
                              } else {
                                categoriesWiseNewListing.clear();
                                fetchCategoriesWiseNewsData(widget.id, subCatId: mSubCategory[index - 1].cat_ID);
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: selectedIndex == index ? 20 : 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedIndex == index ? primaryColor : context.cardColor,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Text(
                              parseHtmlString(subCategories[index]),
                              style: boldTextStyle(
                                  color: appStore.isDarkMode
                                      ? selectedIndex == index
                                          ? Colors.white
                                          : Colors.white54
                                      : selectedIndex == index
                                          ? Colors.white
                                          : Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                          ).paddingTop(8),
                        );
                    },
                  ).visible(subCategories.isNotEmpty),
                ),
                if (categoriesWiseNewListing.isEmpty)
                  SliverFillRemaining(child: Observer(builder: (context) {
                    if (!appStore.isLoading)
                      return EmptyStateWidget(emptyWidgetTitle: language.lblNoNewsFoundOfThisCategory);
                    else
                      return ShimmerWidget(child: CategoryListComponentShimmer());
                  }))
                else
                  SliverPadding(
                    padding: EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          PostModel post = categoriesWiseNewListing[i];

                          return NewsItemWidget(post, index: i);
                        },
                        childCount: categoriesWiseNewListing.length,
                        addAutomaticKeepAlives: true,
                        addRepaintBoundaries: false,
                      ),
                    ),
                  ),
                SliverFillRemaining(
                  fillOverscroll: false,
                  hasScrollBody: false,
                  child: Observer(
                    builder: (_) => LoadingDotsWidget().paddingSymmetric(vertical: 16).visible(appStore.isLoading).center(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
