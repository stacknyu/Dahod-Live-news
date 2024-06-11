import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class HomeFragmentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      physics: NeverScrollableScrollPhysics(),
      listAnimationType: ListAnimationType.FadeIn,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ShimmerWidget(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(32)),
                width: 100,
                height: 45,
              ),
            ),
            16.width,
            ShimmerWidget(
              child: Container(
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(32)),
              ),
            ).expand(),
            16.width,
            ShimmerWidget(
              child: Container(
                height: 48,
                width: 48,
                decoration: boxDecorationDefault(boxShadow: [], shape: BoxShape.circle, color: Colors.white10),
              ),
            ),
          ],
        ).paddingOnly(left: 16, top: 16, bottom: 8, right: 16),
        8.height,
        ShimmerWidget(child: Container(height: 30, decoration: BoxDecoration(color: Colors.white10))).paddingSymmetric(horizontal: 16),
        24.height,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(
              height: 25,
              child: Container(
                height: 25,
                width: context.width() - 32,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: radius(2)),
              ),
            ),
            16.height,
            ShimmerWidget(
              child: Container(
                width: context.width(),
                height: 220,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: radius()),
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 16),
        16.height,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => ShimmerWidget(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                height: 8,
                width: 8,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ),
        24.height,
        ShimmerWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: 25,
                child: Container(
                  height: 25,
                  width: context.width() - 32,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: radius(2)),
                ),
              ),
              16.height,
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 16,
                  children: List.generate(
                    5,
                    (index) => ShimmerWidget(
                      child: Container(
                        height: 90,
                        width: context.width() / 2 - 42,
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: radius()),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        24.height,
        ShimmerWidget(
          child: Container(
            height: 60,
            width: context.width() - 32,
            decoration: BoxDecoration(color: Colors.white10),
          ),
        ),
        24.height,
        ShimmerWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: 25,
                child: Container(
                  height: 25,
                  width: context.width() - 32,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: radius(2)),
                ),
              ),
              16.height,
              Wrap(
                runSpacing: 16,
                spacing: 16,
                children: List.generate(
                  8,
                  (index) => ShimmerWidget(
                    child: Container(
                      height: 180,
                      width: context.width() - 32,
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: radius()),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ).paddingTop(context.statusBarHeight + 16);
  }
}
