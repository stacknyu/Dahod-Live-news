import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
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

class NewsDetailPageVariantFirstWidget extends StatefulWidget {
  final PostModel? post;
  final BlogModel? blogPost;
  final String? postContent;

  NewsDetailPageVariantFirstWidget({this.post, this.postContent, this.blogPost});

  @override
  NewsDetailPageVariantFirstWidgetState createState() => NewsDetailPageVariantFirstWidgetState();
}

class NewsDetailPageVariantFirstWidgetState extends State<NewsDetailPageVariantFirstWidget> {
  ScrollController _scrollController = ScrollController();

  bool isPostLoaded = false;
  String newsTitle = '';
  bool isBookMark = false;
  bool isPasswordProtected = false;

  String password = '';

  int fontSize = 18;

  String postContent = '';

  PostType postType = PostType.HTML;
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    myBanner = buildBannerAd()..load();
    postContent = widget.postContent.validate();
    isPasswordProtected = widget.post!.isPasswordProtected;
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

  @override
  void dispose() {
    myBanner?.dispose();
    _scrollController.dispose();
    setStatusBarColor(
      appStore.isDarkMode ? card_color_dark : card_color_light,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
    super.dispose();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          //
        },
      ),
      request: AdRequest(),
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
      appBar: appBarWidget('',
          color: context.scaffoldBackgroundColor,
          showBack: true,
          elevation: 0,
          backWidget: Icon(Icons.arrow_back_ios, size: 20).onTap(() {
            finish(context);
          }),
          actions: [
            IconButton(
              icon: Icon(Icons.text_increase, color: primaryColor),
              onPressed: () {
                appStore.onFontSizeChange();
              },
            ),
            IconButton(
              icon: cachedImage(ic_send, width: 20, height: 20, color: primaryColor),
              onPressed: () {
                onShareTap(widget.post!.shareUrl.validate() + '${widget.post!.iD}');
              },
            ),
            bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate())
                ? IconButton(
                    icon: cachedImage(
                      bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                      height: 20,
                      width: 20,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      if (appStore.isLoggedIn) {
                        bookmarkStore.addToWishList(widget.post!);
                      } else {
                        SignInScreen().launch(context);
                      }
                      setState(() {});
                    },
                  )
                : IconButton(
                    icon: cachedImage(
                      bookmarkStore.mBookmark.any((e) => e.iD == widget.post!.iD.validate()) ? ic_bookmarked : ic_bookmark,
                      height: 22,
                      width: 22,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      if (appStore.isLoggedIn) {
                        bookmarkStore.addToWishList(widget.post!);
                      } else {
                        SignInScreen().launch(context);
                      }
                      setState(() {});
                    },
                  ),
            IconButton(
              icon: cachedImage(ic_voice, height: 20, width: 20, color: primaryColor),
              onPressed: () async {
                showInDialog(
                  context,
                  shape: RoundedRectangleBorder(borderRadius: radius()),
                  builder: (_) => ReadAloudDialog(parseHtmlString(widget.post!.postContent.validate())),
                  contentPadding: EdgeInsets.zero,
                  barrierDismissible: false,
                );
              },
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: () async {
          await 2.seconds.delay;
          setState(() {});
        },
        child: InternetConnectivityWidget(
          retryCallback: () {
            init();
            setState(() {});
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32, top: 8),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: widget.post!.category.validate().map((e) {
                        return Text(parseHtmlString(e.name.validate()), style: boldTextStyle(color: primaryColor));
                      }).toList(),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    Text(
                      '${parseHtmlString(widget.post!.postTitle.validate())}',
                      style: boldTextStyle(size: textSizeNormal),
                      maxLines: 5,
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ).expand(),
                            ],
                          ).expand(),
                        Text(
                          widget.post!.readableDate.validate(),
                          style: secondaryTextStyle(fontStyle: FontStyle.normal),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    widget.post!.postFormat.validate() == "video"
                        ? PostMediaWidget(widget.post!).paddingBottom(16)
                        : Hero(
                            tag: widget.post!,
                            child: cachedImage(
                              widget.post!.image.validate(),
                              height: 250,
                              width: context.width(),
                              fit: BoxFit.cover,
                            ),
                          ),
                    if (!isAdsDisabled && myBanner != null)
                      Container(
                        color: context.scaffoldBackgroundColor,
                        height: 60,
                        child: myBanner != null ? AdWidget(ad: myBanner!) : SizedBox(),
                      ).paddingSymmetric(vertical: 16),
                    if (!isPasswordProtected)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Observer(
                            builder: (context) {
                              return HtmlWidget(
                                postContent: postContent.validate(),
                                fontSize: appStore.textFontSize,
                              ).paddingSymmetric(horizontal: 8);
                            },
                          ),
                          if(!getBoolAsync(HAS_IN_REVIEW))...[
                            8.height,
                            Divider(color: Colors.grey.shade500, thickness: 0.3),
                            8.height,
                            ViewCommentWidget(id: widget.post!.iD.validate(), itemLength: 3, password: password),
                            Divider(color: Colors.grey.shade500, thickness: 0.1).paddingTop(8),
                            WriteCommentScreen(
                              id: widget.post!.iD.validate(),
                              password: password,
                            ).paddingSymmetric(horizontal: 16),
                          ]
                        ],
                      ),
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
              Observer(builder: (context) => LoadingDotsWidget().center().visible(appStore.isLoading)),
              if (!isPasswordProtected)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CommentButtonWidget(_scrollController),
                ).visible(!getBoolAsync(HAS_IN_REVIEW)),
            ],
          ),
        ),
      ),
    );
  }
}
