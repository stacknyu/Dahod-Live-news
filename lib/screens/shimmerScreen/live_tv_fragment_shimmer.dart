import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/advertisement_shimmer.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';
import 'package:news_flutter/utils/constant.dart';

class LiveTvFragmentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height(),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          64.height,
          ShimmerWidget(
            child: Container(
              height: 200,
              width: context.width(),
              decoration: boxDecorationDefault(boxShadow: [], color: Colors.white12, borderRadius: radius(0)),
            ),
          ),
          ShimmerWidget(child: Divider(height: 9, color: Colors.white10)).paddingSymmetric(horizontal: 16, vertical: 4),
          AdvertisementBannerShimmer(),
          24.height,
          ShimmerWidget(child: Container(height: 25, decoration: BoxDecoration(color: Colors.white10))).paddingSymmetric(horizontal: 16),
          24.height,
          Wrap(
            runSpacing: 10,
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              liveTvChannels.length,
              (index) => ShimmerWidget(
                child: Container(
                  width: context.width() / 3 - 18,
                  height: 85,
                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                ),
              ),
            ),
          ).paddingSymmetric(horizontal: 16)
        ],
      ),
    );
  }
}
