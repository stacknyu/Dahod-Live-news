import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/bookmark_widget.dart';
import 'package:news_flutter/components/see_all_button_widget.dart';
import 'package:news_flutter/components/un_bookmark_widget.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/news/latest_news_list_screen.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/extensions/string_extensions.dart';
import 'package:news_flutter/utils/images.dart';

import '../../../main.dart';

class FeaturedNewsHomeWidget extends StatefulWidget {
  final List<PostModel> recentNewsListing;

  FeaturedNewsHomeWidget({required this.recentNewsListing});

  @override
  State<FeaturedNewsHomeWidget> createState() => _FeaturedNewsHomeWidgetState();
}

class _FeaturedNewsHomeWidgetState extends State<FeaturedNewsHomeWidget> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentIndex, viewportFraction: 0.9);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.recentNewsListing.isNotEmpty
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    language.featuredNews,
                    style: boldTextStyle(size: textSizeMedium),
                  ).paddingOnly(left: 8.0),
                  SeeAllButtonWidget(
                    onTap: () {
                      LatestNewsListScreen(
                        title: language.featuredNews,
                        newsType: NewsListType.FEATURE_NEWS,
                      ).launch(context);
                    },
                    widget: Text(
                      language.seeAll,
                      style: primaryTextStyle(color: primaryColor, size: textSizeSMedium),
                    ).paddingRight(8.0),
                  ),
                ],
              ).paddingSymmetric(horizontal: 8),
              16.height,
              Container(
                width: context.width(),
                height: 220,
                child: PageView.builder(
                  controller: _pageController,
                  pageSnapping: true,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    PostModel postModel = widget.recentNewsListing[index % 4];

                    return Observer(
                      builder: (_) {
                        return GestureDetector(
                          onTap: () async {
                            bool? res = await NewsDetailScreen(newsId: postModel.iD.toString()).launch(context);

                            if (res ?? false) {
                              setState(() {});
                            }
                          },
                          child: AnimatedScale(
                            scale: index == currentIndex ? 1.0 : 0.9,
                            duration: const Duration(milliseconds: 270),
                            curve: Curves.easeInOutCubic,
                            child: Stack(
                              children: [
                                cachedImage(
                                  postModel.image.validate().toString(),
                                  height: context.height(),
                                  width: context.width(),
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: context.width(),
                                  height: context.height(),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                      stops: [0.0, 1.0],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate())
                                      ? BookmarkWidget(
                                          icon: cachedImage(
                                            bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                            height: 22,
                                            width: 22,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            if (appStore.isLoggedIn) {
                                              bookmarkStore.addToWishList(postModel);
                                            } else {
                                              SignInScreen().launch(context);
                                            }
                                            setState(() {});
                                          },
                                        )
                                      : UnBookMarkIconWidget(
                                          icon: cachedImage(
                                            bookmarkStore.mBookmark.any((e) => e.iD == postModel.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                            height: 22,
                                            width: 22,
                                            color: primaryColor,
                                          ),
                                          onTap: () {
                                            if (appStore.isLoggedIn) {
                                              bookmarkStore.addToWishList(postModel);
                                            } else {
                                              SignInScreen().launch(context);
                                            }
                                            setState(() {});
                                          },
                                        ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      if (postModel.postTitle.validate().toLowerCase().contains('protected')) ic_passwordProtected.iconImageColored().paddingSymmetric(vertical: 8),
                                      Text(
                                        parseHtmlString(postModel.postTitle.validate().replaceFirstMapped('Protected:', (match) => '')),
                                        style: boldTextStyle(color: Colors.white, size: textSizeLargeMedium),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      4.height,
                                      Text(postModel.readableDate.validate(), style: secondaryTextStyle(size: textSizeSmall, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                ),
                              ],
                            ).cornerRadiusWithClipRRect(defaultRadius),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              16.height,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.recentNewsListing.take(4).map((e) {
                  return AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(color: (currentIndex % 4) == widget.recentNewsListing.indexOf(e) ? primaryColor : primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
                    duration: Duration(milliseconds: 270),
                  );
                }).toList(),
              )
            ],
          )
        : Offstage();
  }
}
