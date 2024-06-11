import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/model/post_model.dart';

import '../../news/components/news_item_widget.dart';

class NewsListViewWidget extends StatelessWidget {
  final List<PostModel>? latestNewsList;

  NewsListViewWidget({this.latestNewsList});

  @override
  Widget build(BuildContext context) {
    if (latestNewsList.validate().isEmpty) return SizedBox();

    return AnimatedListView(
      slideConfiguration: SlideConfiguration(delay: 250.milliseconds, curve: Curves.easeOutQuad),
      itemCount: latestNewsList!.take(10).length,
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => NewsItemWidget(latestNewsList![i], index: i),
    );
  }
}
