import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class NewsDetailPageVariantThirdShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Wrap(
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                width: context.width(),
                height: context.height() / 2 + 200,
              ),
              Positioned(
                top: 0,
                left: 4,
                right: 4,
                child: Container(
                  width: context.width(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          4,
                          (index) => ShimmerWidget(
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.only(left: 10),
                              decoration: boxDecorationDefault(
                                boxShadow: [],
                                color: Colors.white12,
                                shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      24.height,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: BorderRadius.circular(24)),
                              ),
                            ),
                            16.height,
                            ShimmerWidget(
                              child: Container(
                                height: 15,
                                decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                              ),
                            ),
                            16.height,
                            ShimmerWidget(
                              child: Container(
                                height: 15,
                                decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                              ),
                            ),
                            16.height,
                            ShimmerWidget(
                              child: Container(
                                height: 15,
                                decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                              ),
                            ),
                          ],
                        ),
                      ).paddingSymmetric(vertical: 16),
                      ShimmerWidget(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
                          decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                        ),
                      )
                    ],
                  ).paddingTop(250),
                ),
              ),
            ],
          ),
          AnimatedWrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              6,
              (index) => ShimmerWidget(
                child: Container(
                  height: 15,
                  width: context.width() - 32,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                ),
              ),
            ),
          ),
          AnimatedWrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              6,
              (index) => ShimmerWidget(
                child: Container(
                  height: 15,
                  width: context.width() - 32,
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10),
                ),
              ),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
