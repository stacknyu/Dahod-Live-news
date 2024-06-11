import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class ShortNewsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height(),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            child: Container(
              height: 300,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          8.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          4.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              width: 120,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          32.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          4.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          4.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          4.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
          4.height,
          ShimmerWidget(
            child: Container(
              height: 25,
              width: 120,
              decoration: boxDecorationDefault(color: Colors.white10, borderRadius: radius(0), boxShadow: []),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24),
    );
  }
}
