// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListComponentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      listAnimationType: ListAnimationType.FadeIn,
      children: List.generate(
        10,
        (index) => ShimmerWidget(
          child: Container(
            height: 220,
            margin: EdgeInsets.only(bottom: 16),
            width: context.width() - 32,
            decoration: boxDecorationDefault(
              boxShadow: [],
              color: Colors.white10,
              borderRadius: radius(),
            ),
          ),
        ),
      ),
    );
  }
}
