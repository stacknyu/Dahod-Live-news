import 'dart:ui';

import 'package:flutter/material.dart';
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
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/blog_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/comments/components/view_comment_widget.dart';
import 'package:news_flutter/screens/comments/write_comment_screen.dart';
import 'package:news_flutter/screens/news/components/comment_button_widget.dart';
import 'package:news_flutter/screens/news/components/post_media_widget.dart';
import 'package:news_flutter/screens/news/components/read_aloud_dialog.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:share_plus/share_plus.dart';

import '../../../main.dart';

class NewsDetailPageVariantSecondWidget extends StatefulWidget {
  PostModel? post;
  final String? postContent;
  final BlogModel? blogPost;

  NewsDetailPageVariantSecondWidget({this.post, this.postContent, this.blogPost});

  @override
  _NewsDetailPageVariantSecondWidgetState createState() => _NewsDetailPageVariantSecondWidgetState();
}

class _NewsDetailPageVariantSecondWidgetState extends State<NewsDetailPageVariantSecondWidget> {
  ScrollController _controller = ScrollController();
  bool isPostLoaded = false;
  String newsTitle = '';
  String postContent = '';
  String password = '';

  bool isPasswordProtected = false;

  BannerAd? myBanner;

  int fontSize = 18;

  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
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
      request: AdRequest(
          //  testDevices: [testDeviceId],
          ),
    );
  }

  void onShareTap(String url) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share('$url', subject: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void dispose() async {
    _controller.dispose();
    if (mInterstitialAdCount < 5) {
      mInterstitialAdCount++;
    } else {
      mInterstitialAdCount = 0;
      buildInterstitialAd();
    }

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
          buildInterstitialAd();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        '',
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await 2.seconds.delay;
          setState(() {});
        },
        child: Observer(
          builder: (context) => InternetConnectivityWidget(
            retryCallback: () {
              init();
              setState(() {});
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _controller,
                  padding: EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.post!.postFormat.validate() == "video"
                          ? PostMediaWidget(widget.post!).paddingBottom(16)
                          : Stack(
                              children: [
                                Hero(
                                  tag: widget.post!,
                                  child: cachedImage(
                                    widget.post!.image.validate(),
                                    fit: BoxFit.cover,
                                    width: context.width(),
                                    height: 280,
                                  ).cornerRadiusWithClipRRect(defaultRadius),
                                ),
                                Positioned(
                                  right: 16,
                                  top: 16,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: context.scaffoldBackgroundColor),
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                                      offset: Offset(-12, 45),
                                      icon: Icon(Icons.more_vert_rounded, color: appStore.isDarkMode ? white : primaryColor),
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                        PopupMenuItem(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          onTap: () {
                                            onShareTap(widget.post!.shareUrl.validate() + '${widget.post!.iD}');
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              cachedImage(ic_send, width: 22, height: 22, color: primaryColor),
                                              8.width,
                                              Text(language.share.validate(), style: primaryTextStyle()),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          onTap: () {
                                            if (appStore.isLoggedIn) {
                                              bookmarkStore.addToWishList(widget.post!);
                                            } else {
                                              SignInScreen().launch(context);
                                            }
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              cachedImage(bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                                                  height: 22, width: 22, color: primaryColor),
                                              8.width,
                                              Text(language.bookmark, style: primaryTextStyle()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ).paddingAll(16),
                      Row(
                        children: [
                          if (widget.post!.category != null)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: widget.post!.category.validate().map((e) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: Text(parseHtmlString(e.name.validate()), style: primaryTextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ).expand(),
                          8.width,
                          if (widget.post!.category == null) Spacer(),
                          BookmarkWidget(
                            icon: Icon(Icons.text_increase, size: 22, color: Colors.white),
                            onTap: () {
                              appStore.onFontSizeChange();
                            },
                          ),
                          8.width,
                          BookmarkWidget(
                            icon: cachedImage(ic_voice, height: 22, width: 22, color: Colors.white),
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
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 8),
                      Text('${parseHtmlString(widget.post!.postTitle.validate())}', style: boldTextStyle(size: textSizeNormal)).paddingSymmetric(horizontal: 16, vertical: 8),
                      Row(
                        children: [
                          if (widget.post!.postAuthorName.validate().isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //authorImage(userImage: ic_profile), not get from API
                                //6.width,
                                Text(
                                  '${language.by + ' ${parseHtmlString(admin_author.any((e) => e == widget.post!.postAuthorName.validate()) ? APP_NAME : widget.post!.postAuthorName.validate())}'}',
                                  style: secondaryTextStyle(fontStyle: FontStyle.italic, size: textSizeSMedium),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ).expand(),
                          Text(
                            widget.post!.readableDate.validate(),
                            style: secondaryTextStyle(fontStyle: FontStyle.normal),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 8),
                      !isAdsDisabled && myBanner != null
                          ? Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              height: 60,
                              child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                            ).paddingSymmetric(vertical: 16)
                          : SizedBox(),
                      if (!isPasswordProtected)
                        Observer(builder: (context) {
                          return HtmlWidget(postContent: postContent.validate(), fontSize: appStore.textFontSize).paddingSymmetric(horizontal: 8);
                        }),
                      if(!getBoolAsync(HAS_IN_REVIEW))...[
                        if (!isPasswordProtected) Divider(color: Colors.grey.shade500, thickness: 0.3),
                        if (!isPasswordProtected) ViewCommentWidget(id: widget.post!.iD.validate(), itemLength: 3, password: password),
                        if (widget.post!.postContent != null) Divider(color: Colors.grey.shade500, thickness: 0.3).paddingTop(8),
                        if (widget.post!.postContent != null)
                          WriteCommentScreen(
                            id: widget.post!.iD.validate(),
                            password: password,
                          ).paddingSymmetric(horizontal: 16),
                      ]

                    ],
                  ),
                ),
                if (isPasswordProtected)
                  ClipRect(
                    clipBehavior: Clip.antiAlias,
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 3.7, sigmaY: 3.7),
                      child: PasswordProtectedPost(
                        (pass) {
                          setState(() {
                            password = pass.validate();
                          });
                          getPostDetail(pwd: pass.validate());
                        },
                      ),
                    ),
                  ),
                LoadingDotsWidget().center().visible(appStore.isLoading),
                if (!isPasswordProtected)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: CommentButtonWidget(_controller),
                  ).visible(!getBoolAsync(HAS_IN_REVIEW)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
