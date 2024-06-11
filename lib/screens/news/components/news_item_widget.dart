import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/bookmark_widget.dart';
import 'package:news_flutter/components/un_bookmark_widget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/screens/auth/sign_in_screen.dart';
import 'package:news_flutter/screens/news/components/quick_news_post_dialog_widget.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/extensions/string_extensions.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:news_flutter/utils/overlay_handler.dart';
import 'package:palette_generator/palette_generator.dart';

class NewsItemWidget extends StatefulWidget {
  static String tag = '/NewsItemWidget';
  final PostModel post;
  final int index;

  NewsItemWidget(this.post, {this.index = 0});

  @override
  _NewsItemWidgetState createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  OverlayHandler _overlayHandler = OverlayHandler();
  PaletteGenerator? paletteGenerator;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return GestureDetector(
          onTap: () async {
            bool? res = await NewsDetailScreen(newsId: widget.post.iD.toString()).launch(context);

            if (res ?? false) {
              setState(() {});
            }
          },
          onLongPress: () {
            _overlayHandler.insertOverlay(
              context,
              OverlayEntry(builder: (context) => QuickNewsPostDialogWidget(postModel: widget.post)),
            );
          },
          onLongPressEnd: (details) => _overlayHandler.removeOverlay(context),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 250,
            width: context.width(),
            child: Stack(
              children: [
                cachedImage(
                  widget.post.image.validate(),
                  height: context.height(),
                  width: context.width(),
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(12),
                Container(
                  width: context.width(),
                  height: context.height(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                  child: bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate())
                      ? BookmarkWidget(
                          icon: cachedImage(
                            bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate()) ? ic_bookmarked : ic_bookmark,
                            height: 22,
                            width: 22,
                            color: Colors.white,
                          ),
                          onTap: () {
                            if (appStore.isLoggedIn) {
                              bookmarkStore.addToWishList(widget.post);
                            } else {
                              SignInScreen().launch(context);
                            }
                            setState(() {});
                          },
                        )
                      : UnBookMarkIconWidget(
                          icon: cachedImage(
                            bookmarkStore.mBookmark.any((e) => e.iD == widget.post.iD.validate()) ? ic_bookmarked : ic_bookmark,
                            height: 22,
                            width: 22,
                            color: primaryColor,
                          ),
                          onTap: () {
                            if (appStore.isLoggedIn) {
                              bookmarkStore.addToWishList(widget.post);
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
                    children: <Widget>[
                      if (widget.post.postTitle.validate().toLowerCase().contains('protected')) ic_passwordProtected.iconImageColored().paddingSymmetric(vertical: 8),
                      Text(
                        parseHtmlString(widget.post.postTitle.validate().replaceFirstMapped('Protected:', (match) => '')),
                        style: boldTextStyle(color: Colors.white, size: textSizeLargeMedium),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.post.readableDate.validate(), style: secondaryTextStyle(size: textSizeSmall, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ).paddingAll(8),
        );
      },
    );
  }
}
