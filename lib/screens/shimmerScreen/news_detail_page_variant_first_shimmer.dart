import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class NewsDetailPageVariantFirstShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: Wrap(
        runSpacing: 6,
        children: [
          ShimmerWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                4,
                (index) => ShimmerWidget(
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 12),
                    decoration: boxDecorationDefault(
                      borderRadius: radius(),
                      boxShadow: [],
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ).paddingSymmetric(horizontal: 16),
          Container(
            width: context.width() - 32,
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(boxShadow: [], borderRadius: BorderRadius.circular(8), color: Colors.white10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: boxDecorationDefault(boxShadow: [], borderRadius: BorderRadius.circular(8), color: Colors.white10),
                  ),
                ),
                16.height,
                ShimmerWidget(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(boxShadow: [], borderRadius: BorderRadius.circular(8), color: Colors.white10),
                  ),
                ),
                16.height,
                ShimmerWidget(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(boxShadow: [], borderRadius: BorderRadius.circular(8), color: Colors.white10),
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 24),
          ShimmerWidget(
            child: Container(
              height: 200,
              decoration: boxDecorationDefault(borderRadius: radius(0), boxShadow: [], color: Colors.white10),
            ),
          ).paddingSymmetric(vertical: 24),
          ShimmerWidget(
            child: Container(
              height: 50,
              width: context.width() - 64,
              decoration: boxDecorationDefault(borderRadius: radius(4), boxShadow: [], color: Colors.white10),
            ),
          ).paddingSymmetric(vertical: 24, horizontal: 16),
          ...List.generate(
            10,
            (index) => ShimmerWidget(
              child: Container(
                width: context.width() - 32,
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(borderRadius: radius(8), boxShadow: [], color: Colors.white10),
              ),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 42),
    );
  }
}
