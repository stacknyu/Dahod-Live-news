import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/html_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';
import 'package:news_flutter/components/password_protected_post.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/short_news_shimmer.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/images.dart';

class ShortNewsScreen extends StatefulWidget {
  const ShortNewsScreen({Key? key}) : super(key: key);

  @override
  State<ShortNewsScreen> createState() => _ShortNewsScreenState();
}

class _ShortNewsScreenState extends State<ShortNewsScreen> with TickerProviderStateMixin {
  int page = 1;
  int recentNumPages = 1;
  List<PostModel> recentNewsListing = [];

  PostModel? currentPost;

  int index = 0;

  bool showBottom = true;

  bool isPasswordProtected = false;
  bool showLoader = false;

  String? postContent;

  late AnimationController _animationControllerNext;
  late AnimationController _animationControllerPrevious;

  @override
  void initState() {
    super.initState();

    _animationControllerNext = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animationControllerNext.addStatusListener((status) {});

    _animationControllerPrevious = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animationControllerPrevious.addStatusListener((status) {});

    _animationControllerNext.value = 1;
    _animationControllerPrevious.value = 0;

    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
      getFeaturePostList();
    });
  }

  Future<void> getFeaturePostList() async {
    appStore.setLoading(true);

    await getDashboardApi(page).then((value) {
      if (page == 1) {
        recentNewsListing.clear();
      }
      recentNumPages = value.featureNumPages.validate();
      recentNewsListing.addAll(value.featurePost.validate());
      setCurrentPost();
      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      log(e.toString());
    });
    appStore.setLoading(false);
  }

  void setCurrentPost() {
    setState(() {
      currentPost = recentNewsListing[index];
      isPasswordProtected = parseHtmlString(getPostContent(currentPost?.postTitle)).startsWith('Protected:');
      postContent = null;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getPostContent(String? postContent) {
    return postContent
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>')
        .replaceAll('[blockquote]', '<blockquote>')
        .replaceAll('[/blockquote]', '</blockquote>');
  }

  Future<void> getPostDetail(String postId, {String pwd = ''}) async {
    setState(() {
      showLoader = true;
    });
    await getPostDetails(postId: postId, password: pwd).then((value) {
      postContent = getPostContent(value.content?.rendered.validate());
      isPasswordProtected = false;
      showLoader = false;
      setState(() {});
    }).catchError((e) {
      setState(() {
        showLoader = false;
      });

      toast(e.toString());
      throw e;
    });
  }

  @override
  void dispose() {
    _animationControllerNext.dispose();
    _animationControllerPrevious.dispose();
    super.dispose();
  }

  void toggleNext() {
    if (index != recentNewsListing.length - 1) {
      _animationControllerNext.reverse().then((value) {
        _animationControllerNext.value = 1;
        index += 1;
        setCurrentPost();
        setState(() {});
      });
    }
  }

  void togglePrevious() {
    if (index != 0) {
      showBottom = false;
      setState(() {});

      _animationControllerPrevious.forward().then((value) {
        _animationControllerPrevious.value = 0;
        index--;
        showBottom = true;
        setCurrentPost();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.shortNews,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        center: true,
        elevation: 0.2,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        backWidget: BackWidget(color: context.iconColor),
        actions: [
          TextButton(
            onPressed: () {
              NewsDetailScreen(
                newsId: recentNewsListing[index].iD.validate().toString(),
              ).launch(context);
            },
            child: Text(
              language.readMore,
              style: secondaryTextStyle(color: primaryColor),
              textAlign: TextAlign.end,
            ),
          ).paddingSymmetric(vertical: 10, horizontal: 8),
        ],
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            if (!appStore.isLoading && recentNewsListing.isNotEmpty) placeHolderWidget(height: context.height() / 3, width: context.width(), fit: BoxFit.cover),
            if (recentNewsListing.isNotEmpty)
              SizedBox(
                height: context.height(),
                width: context.width(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _animationControllerPrevious,
                        builder: (BuildContext context, Widget? child) {
                          final angle = _animationControllerPrevious.value * pi;

                          return Transform(
                            alignment: Alignment.bottomCenter,
                            transform: Matrix4.identity()
                              ..setEntry(2, 2, 0.001)
                              ..rotateX(angle),
                            child: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                if (details.delta.dy > 0) {
                                  ///Scroll Down
                                  togglePrevious();
                                } else {
                                  ///Scroll Up
                                  toggleNext();
                                }
                              },
                              onHorizontalDragUpdate: (details) {
                                //
                              },
                              child: SizedBox(
                                height: context.height() / 2.4,
                                child: angle <= 1.5708
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          cachedImage(
                                            recentNewsListing[index].image.validate(),
                                            height: context.height() / 3,
                                            width: context.width(),
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            parseHtmlString(getPostContent(recentNewsListing[index].postTitle.validate().replaceFirst('Protected:', ''))),
                                            style: boldTextStyle(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ).paddingSymmetric(horizontal: 16, vertical: 8),
                                        ],
                                      )
                                    : Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationX(pi),
                                        child: isPasswordProtected
                                            ? Blur(
                                                blur: 2,
                                                child: Container(
                                                  width: context.width(),
                                                  height: context.height(),
                                                  child: Text(
                                                    parseHtmlString(getPostContent(recentNewsListing[index].postContent)),
                                                    style: secondaryTextStyle(),
                                                    maxLines: 12,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                ),
                                              )
                                            : postContent != null
                                                ? HtmlWidget(postContent: postContent).paddingSymmetric(horizontal: 8)
                                                : Text(
                                                    parseHtmlString(getPostContent(recentNewsListing[index].postContent)),
                                                    style: secondaryTextStyle(),
                                                    maxLines: 12,
                                                    textAlign: TextAlign.justify,
                                                    overflow: TextOverflow.ellipsis,
                                                  ).paddingSymmetric(horizontal: 24),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _animationControllerNext,
                        builder: (BuildContext context, Widget? child) {
                          final angle = _animationControllerNext.value * pi;

                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(2, 2, 0.001)
                              ..rotateX(angle),
                            child: Transform(
                              transform: Matrix4.rotationX(pi),
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.dy > 0) {
                                    ///Scroll Down
                                    togglePrevious();
                                  } else {
                                    ///Scroll Up
                                    toggleNext();
                                  }
                                },
                                onHorizontalDragUpdate: (details) {
                                  //
                                },
                                child: Container(
                                  color: context.scaffoldBackgroundColor,
                                  child: angle >= 1.5708
                                      ? isPasswordProtected
                                          ? Blur(
                                              blur: 2,
                                              child: Container(
                                                width: context.width(),
                                                height: context.height(),
                                                child: Text(
                                                  parseHtmlString(getPostContent(recentNewsListing[index].postContent)),
                                                  style: secondaryTextStyle(),
                                                  maxLines: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            )
                                          : postContent != null
                                              ? HtmlWidget(postContent: postContent.validate()).paddingSymmetric(horizontal: 8)
                                              : Text(
                                                  parseHtmlString(getPostContent(recentNewsListing[index].postContent)),
                                                  style: secondaryTextStyle(),
                                                  maxLines: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.justify,
                                                ).paddingSymmetric(horizontal: 16)
                                      : Transform(
                                          transform: Matrix4.rotationX(pi),
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                cachedImage(
                                                  recentNewsListing[index + 1].image.validate(),
                                                  height: context.height() / 3,
                                                  width: context.width(),
                                                  fit: BoxFit.cover,
                                                ),
                                                16.height,
                                                Text(
                                                  parseHtmlString(getPostContent(recentNewsListing[index + 1].postTitle.validate().replaceFirst('Protected:', ''))),
                                                  style: boldTextStyle(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ).paddingSymmetric(horizontal: 16),
                                              ],
                                            ),
                                            color: context.scaffoldBackgroundColor,
                                            height: context.height() / 2.2,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).visible(showBottom)
                    ],
                  ),
                ),
              ),
            if (isPasswordProtected)
              Align(
                child: Blur(
                  blur: 4,
                  child: SizedBox(
                    height: context.height(),
                    width: context.width(),
                    child: PasswordProtectedPost(
                      (password) {
                        getPostDetail(currentPost!.iD.toString(), pwd: password.validate());
                      },
                      height: 200,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 8,
              bottom: 0,
              left: 0,
              child: Blur(
                blur: 4,
                child: Row(
                  mainAxisAlignment: index != 0 && !appStore.isLoading && recentNewsListing.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        togglePrevious();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.navigate_before, color: context.iconColor, size: 22),
                          Text(language.previous, style: primaryTextStyle()),
                        ],
                      ),
                    ).visible(index != 0 && !appStore.isLoading && recentNewsListing.isNotEmpty),
                    TextButton(
                      onPressed: () {
                        toggleNext();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language.next, style: primaryTextStyle()),
                          Icon(Icons.navigate_next, color: context.iconColor, size: 22),
                        ],
                      ),
                    ).visible(index != recentNewsListing.length - 1 && !appStore.isLoading && recentNewsListing.isNotEmpty),
                  ],
                ),
              ),
            ),
            if (!appStore.isLoading && recentNewsListing.isEmpty) NoDataWidget(title: language.noRecordFound, image: ic_no_data).center(),
            ShortNewsShimmer().visible(appStore.isLoading),
            LoadingDotsWidget().center().visible(showLoader)
          ],
        ),
      ),
    );
  }
}
