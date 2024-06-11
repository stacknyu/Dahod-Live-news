import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/bookmark_widget.dart';
import 'package:news_flutter/components/html_widget.dart';
import 'package:news_flutter/components/internet_connectivity_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';
import 'package:news_flutter/components/password_protected_post.dart';
import 'package:news_flutter/components/un_bookmark_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/blog_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/comments/components/view_comment_widget.dart';
import 'package:news_flutter/screens/comments/write_comment_screen.dart';
import 'package:news_flutter/screens/news/components/post_media_widget.dart';
import 'package:news_flutter/screens/news/components/read_aloud_dialog.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:share_plus/share_plus.dart';

import '../../../main.dart';

class NewsDetailPageVariantThirdWidget extends StatefulWidget {
  final PostModel? post;
  final String? postContent;
  final BlogModel? blogPost;

  NewsDetailPageVariantThirdWidget({this.post, this.postContent, this.blogPost});

  @override
  NewsDetailPageVariantThirdWidgetState createState() => NewsDetailPageVariantThirdWidgetState();
}

class NewsDetailPageVariantThirdWidgetState extends State<NewsDetailPageVariantThirdWidget> {
  BannerAd? myBanner;

  String postContent = '';
  String password = '';

  bool isPasswordProtected = false;
  InterstitialAd? myInterstitial;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    postContent = widget.postContent.validate();
    isPasswordProtected = widget.post!.isPasswordProtected;
    myBanner = buildBannerAd()..load();
    setState(() {});
  }

  getPostDetail({String pwd = ''}) async {
    appStore.setLoading(true);
    await getPostDetails(postId: widget.post!.iD.toString(), password: pwd).then((value) {
      postContent = getPostContent(value.content!.rendered.validate());
      isPasswordProtected = false;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
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
  void dispose() async {
    myBanner!.dispose();
    if (mInterstitialAdCount < 5) {
      mInterstitialAdCount++;
    } else {
      mInterstitialAdCount = 0;
      buildInterstitialAd();
    }
    setStatusBarColor(appStore.isDarkMode ? card_color_dark : white);
    super.dispose();
  }

  Future<void> buildInterstitialAd() {
    return InterstitialAd.load(
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

  void onShareTap(String url) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('$url', subject: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await 2.seconds.delay;
          setState(() {});
        },
        child: Observer(
          builder: (_) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                if (innerBoxIsScrolled) {
                  setStatusBarColor(appStore.isDarkMode ? card_color_dark : white);
                }
                return <Widget>[
                  SliverAppBar(
                    pinned: false,
                    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
                    expandedHeight: context.height() * 0.50,
                    flexibleSpace: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FlexibleSpaceBar(
                          background: widget.post!.postFormat.validate() == "video"
                              ? PostMediaWidget(widget.post!).paddingBottom(16)
                              : cachedImage(widget.post!.image.validate(), fit: BoxFit.cover, width: context.width(), height: 280),
                        ),
                        if (isPasswordProtected)
                          ClipRect(
                            clipBehavior: Clip.antiAlias,
                            child: BackdropFilter(
                              filter: new ImageFilter.blur(sigmaX: 3.7, sigmaY: 3.7),
                              child: SizedBox(
                                height: context.height(),
                                width: context.width(),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: -context.height() * 0.1,
                          left: 16,
                          right: 16,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 100),
                            opacity: innerBoxIsScrolled == true ? 0.0 : 1.0,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BookmarkWidget(
                                        backgroundColor: Colors.white,
                                        icon: Icon(Icons.text_increase, size: 22, color: primaryColor),
                                        onTap: () {
                                          appStore.onFontSizeChange();
                                        },
                                      ),
                                      16.width,
                                      BookmarkWidget(
                                        icon: cachedImage(ic_voice, height: 22, width: 22, color: primaryColor),
                                        backgroundColor: Colors.white,
                                        onTap: () async {
                                          await showInDialog(
                                            context,
                                            shape: RoundedRectangleBorder(borderRadius: radius()),
                                            builder: (_) => ReadAloudDialog(parseHtmlString(widget.post!.postContent.validate())),
                                            contentPadding: EdgeInsets.zero,
                                            barrierDismissible: false,
                                          );
                                        },
                                      ),
                                      16.width,
                                      BookmarkWidget(
                                        backgroundColor: Colors.white,
                                        icon: cachedImage(ic_send, width: 20, height: 20, color: primaryColor),
                                        onTap: () {
                                          onShareTap(widget.post!.shareUrl.validate() + '${widget.post!.iD}');
                                        },
                                      ),
                                      16.width,
                                      bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate())
                                          ? BookmarkWidget(
                                              icon: cachedImage(
                                                bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                                height: 20,
                                                width: 20,
                                                color: Colors.white,
                                              ),
                                              onTap: () {
                                                if (appStore.isLoggedIn) {
                                                  bookmarkStore.addToWishList(widget.post!);
                                                } else {
                                                  SignInScreen().launch(context);
                                                }
                                                setState(() {});
                                              },
                                            )
                                          : UnBookMarkIconWidget(
                                              icon: cachedImage(
                                                bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                                height: 22,
                                                width: 22,
                                                color: primaryColor,
                                              ),
                                              onTap: () {
                                                if (appStore.isLoggedIn) {
                                                  bookmarkStore.addToWishList(widget.post!);
                                                } else {
                                                  SignInScreen().launch(context);
                                                }
                                                setState(() {});
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                                16.height,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(defaultRadius),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      width: context.width(),
                                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                            spacing: 4,
                                            runSpacing: 4,
                                            children: widget.post!.category.validate().take(2).map((e) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(32.0),
                                                ),
                                                child: Text(parseHtmlString(e.name.validate()), style: primaryTextStyle(color: Colors.white)),
                                              );
                                            }).toList(),
                                          ),
                                          8.height,
                                          Text('${parseHtmlString(widget.post!.postTitle.validate())}', style: boldTextStyle(size: textSizeNormal, color: Colors.white)),
                                          8.height,
                                          Row(
                                            children: [
                                              if (widget.post!.postAuthorName.validate().isNotEmpty)
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    //authorImage(userImage: ic_profile),
                                                    //6.width,
                                                    Text(
                                                      '${language.by + ' ${parseHtmlString(admin_author.any((e) => e == widget.post!.postAuthorName.validate()) ? APP_NAME : widget.post!.postAuthorName.validate())}'}',
                                                      style: secondaryTextStyle(color: Colors.white, fontStyle: FontStyle.italic, size: textSizeSMedium),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ).expand(),
                                              Text(
                                                widget.post!.readableDate.validate(),
                                                style: secondaryTextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    leading: BackWidget(
                      color: innerBoxIsScrolled
                          ? appStore.isDarkMode
                              ? Colors.white
                              : Colors.black
                          : Colors.white,
                      onPressed: () async {
                        finish(context);
                      },
                    ),
                  )
                ];
              },
              body: InternetConnectivityWidget(
                retryCallback: () {
                  init();
                  setState(() {});
                },
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          64.height,
                          !isAdsDisabled && myBanner != null
                              ? Container(
                                  color: context.scaffoldBackgroundColor,
                                  height: 60,
                                  child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                                ).paddingSymmetric(vertical: 16)
                              : SizedBox(),
                          if (isPasswordProtected)
                            PasswordProtectedPost(
                              (pass) {
                                setState(() {
                                  password = pass.validate();
                                });
                                getPostDetail(pwd: pass.validate());
                              },
                              height: 200,
                            ),
                          if (!isPasswordProtected)
                            Observer(builder: (context) {
                              return HtmlWidget(postContent: postContent, fontSize: appStore.textFontSize).paddingOnly(left: 8, right: 8);
                            }),
                          if (!isPasswordProtected) Divider(color: Colors.grey.shade500, thickness: 0.3),
                          if(!getBoolAsync(HAS_IN_REVIEW))...[
                            if (!isPasswordProtected)
                              ViewCommentWidget(
                                id: widget.post!.iD.validate(),
                                itemLength: 3,
                                password: password,
                              ),
                            if (widget.post!.postContent != null) Divider(color: Colors.grey.shade500, thickness: 0.3).paddingTop(8),
                            if (widget.post!.postContent != null)
                              WriteCommentScreen(
                                id: widget.post!.iD.validate(),
                                password: password,
                              ).paddingSymmetric(horizontal: 16)
                          ],
                        ],
                      ),
                    ),
                    LoadingDotsWidget().center().visible(appStore.isLoading),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
