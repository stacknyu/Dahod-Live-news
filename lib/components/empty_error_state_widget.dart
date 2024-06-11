import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

class EmptyStateWidget extends StatelessWidget {
  final double? height;
  final double? width;
  Widget? imageWidget;
  String? emptyWidgetTitle;

  EmptyStateWidget({this.height, this.width, this.imageWidget, this.emptyWidgetTitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: NoDataWidget(
        imageWidget: imageWidget ?? Image.asset(ic_no_data, height: 100),
        title: emptyWidgetTitle ?? noRecord,
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final double? height;
  final double? width;

  final String? errorText;

  const ErrorStateWidget({this.height, this.width, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Image.asset(ic_no_internet, height: 160);
  }
}
