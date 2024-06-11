import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class NewsDetailPageVariantSecondShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        64.height,
        ShimmerWidget(
          child: Container(
            height: 200,
            width: context.width() - 32,
            padding: EdgeInsets.all(16),
            alignment: Alignment.topRight,
            decoration: boxDecorationDefault(borderRadius: radius(), boxShadow: [], color: Colors.white10),
            child: Container(
              height: 50,
              width: 50,
              decoration: boxDecorationDefault(borderRadius: radius(), boxShadow: [], color: Colors.white10, shape: BoxShape.circle),
            ),
          ),
        ),
        24.height,
        Row(
          children: [
            ShimmerWidget(
              child: Container(
                height: 40,
                width: 100,
                decoration: boxDecorationDefault(
                  borderRadius: radius(),
                  boxShadow: [],
                  color: Colors.white10,
                ),
              ),
            ),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                2,
                (index) => ShimmerWidget(
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(left: 16),
                    decoration: boxDecorationDefault(
                      borderRadius: radius(),
                      boxShadow: [],
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ).expand()
          ],
        ).paddingSymmetric(horizontal: 16),
        24.height,
        ShimmerWidget(
          child: Container(
            height: 15,
            width: context.width() - 32,
            decoration: boxDecorationDefault(
              borderRadius: radius(8),
              boxShadow: [],
              color: Colors.white10,
            ),
          ),
        ),
        8.height,
        ShimmerWidget(
          child: Container(
            height: 15,
            width: context.width() - 32,
            decoration: boxDecorationDefault(
              borderRadius: radius(8),
              boxShadow: [],
              color: Colors.white10,
            ),
          ),
        ),
        24.height,
        ShimmerWidget(
          child: Container(
            height: 50,
            width: context.width() - 64,
            decoration: boxDecorationDefault(
              borderRadius: BorderRadius.circular(2),
              boxShadow: [],
              color: Colors.white10,
            ),
          ),
        ),
        42.height,
        AnimatedWrap(
          runSpacing: 4,
          spacing: 4,
          children: List.generate(
            7,
            (index) => ShimmerWidget(
              child: Container(
                height: 12,
                width: context.width() - 32,
                decoration: boxDecorationDefault(
                  borderRadius: radius(8),
                  boxShadow: [],
                  color: Colors.white10,
                ),
              ),
            ),
          ),
        ),
        16.height,
        AnimatedWrap(
          runSpacing: 4,
          spacing: 4,
          children: List.generate(
            6,
            (index) => ShimmerWidget(
              child: Container(
                height: 12,
                width: context.width() - 32,
                decoration: boxDecorationDefault(
                  borderRadius: radius(8),
                  boxShadow: [],
                  color: Colors.white10,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
