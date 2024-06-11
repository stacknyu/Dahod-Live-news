import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:share_plus/share_plus.dart';

import 'utils/images.dart';

void onShareTap(BuildContext context) async {
  setStatusBarColor(
    appStore.isDarkMode ? card_color_dark : card_color_light,
    statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
  );
  Share.share('Share $APP_NAME app $playStoreBaseURL${packageInfo.packageName}');
}

BoxDecoration boxDecoration(
  BuildContext context, {
  double radius = 1.0,
  Color color = Colors.transparent,
  Color? bgColor = white_color,
  double borderWidth = 0.0,
  Color shadowColor = shadow_color,
  var showShadow = false,
}) {
  return BoxDecoration(
    color: bgColor == white_color ? Theme.of(context).cardTheme.color : bgColor,
    boxShadow: showShadow ? [BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.2), blurRadius: 10, spreadRadius: 3)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color, width: borderWidth),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

class NewsButton extends StatefulWidget {
  final Widget content;
  final VoidCallback? onPressed;
  final bool isStroked;
  final double? height;
  final double? width;
  final Color backGroundColor;
  final double? borderRadius;

  NewsButton({
    required this.content,
    required this.onPressed,
    this.isStroked = false,
    this.height,
    this.backGroundColor = primaryColor,
    this.borderRadius,
    this.width,
  });

  @override
  NewsButtonState createState() => NewsButtonState();
}

class NewsButtonState extends State<NewsButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        alignment: Alignment.center,
        child: FittedBox(child: widget.content),
        decoration: widget.isStroked
            ? boxDecoration(context, bgColor: Colors.transparent, color: widget.backGroundColor, radius: widget.borderRadius ?? defaultRadius)
            : boxDecoration(context, bgColor: widget.backGroundColor, radius: widget.borderRadius ?? defaultRadius),
      ),
    );
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(
    grey_image,
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
    color: appStore.isDarkMode ? appBackGroundColor : null,
  );
}

Widget cachedImage(
  String url, {
  Key? key,
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      key: key,
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
    );
  } else if (url.validate().startsWith('/data')) {
    return Image.file(
      File(url),
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  } else {
    return Image.asset(
      url,
      key: key,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      color: color,
    ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget authorImage({String? userImage}) {
  return Container(
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
    child: Image.asset(userImage.validate(), width: 18, height: 18, color: primaryColor),
  );
}
