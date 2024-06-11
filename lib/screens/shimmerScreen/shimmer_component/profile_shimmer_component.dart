import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class ProfileShimmerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() / 2,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        color: context.cardColor,
      ),
      child: ShimmerWidget(
        child: Stack(
          children: [
            Column(
              children: [
                ShimmerWidget(
                  child: Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white10),
                  ).paddingTop(16),
                ),
                if (!appStore.isLoggedIn)
                  Stack(
                    children: [
                      ShimmerWidget(
                        child: Row(
                          children: [
                            ShimmerWidget(
                              child: Container(height: 50, decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius(24))),
                            ).expand(),
                            32.width,
                            ShimmerWidget(child: Container(height: 50, width: 50, decoration: boxDecorationDefault(boxShadow: [], shape: BoxShape.circle, color: Colors.white10))),
                            8.width,
                            ShimmerWidget(child: Container(height: 50, width: 50, decoration: boxDecorationDefault(boxShadow: [], shape: BoxShape.circle, color: Colors.white10))),
                            if (isIOS) ShimmerWidget(child: Container(height: 50, width: 50, decoration: boxDecorationDefault(boxShadow: [], shape: BoxShape.circle, color: Colors.white10))),
                          ],
                        ).paddingSymmetric(vertical: 32),
                      )
                    ],
                  ),
                if (appStore.isLoggedIn)
                  ShimmerWidget(
                    child: Row(
                      children: [
                        ShimmerWidget(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        16.width,
                        ShimmerWidget(
                          child: Column(
                            children: [
                              ShimmerWidget(
                                child: Container(
                                  height: 10,
                                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius()),
                                ),
                              ),
                              16.height,
                              ShimmerWidget(
                                child: Container(
                                  height: 10,
                                  decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius()),
                                ),
                              ),
                            ],
                          ),
                        ).expand(),
                        16.width,
                        ShimmerWidget(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(color: Colors.white10, borderRadius: radius()),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 32),
                  ),
                ShimmerWidget(child: Divider(thickness: 0.7, color: Colors.white10)),
                24.height,
                ShimmerWidget(
                  child: Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: List.generate(
                      3,
                      (index) => ShimmerWidget(
                        child: Container(
                          height: 100,
                          width: context.width() / 3 - 24,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [],
                            border: Border.all(color: Colors.white10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                24.height,
                ShimmerWidget(
                  child: Container(
                    height: 20,
                    decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius()),
                  ),
                ),
                ShimmerWidget(
                  child: Container(
                    height: 10,
                    decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
