import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class NotificationsListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          5,
          (index) => ShimmerWidget(
            child: Container(
              padding: EdgeInsets.all(16),
              width: context.width() - 32,
              decoration: boxDecorationDefault(borderRadius: radius(), color: Colors.white10, boxShadow: []),
              child: Row(
                children: [
                  ShimmerWidget(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: boxDecorationDefault(
                        borderRadius: radius(),
                        color: Colors.white12,
                        boxShadow: [],
                      ),
                    ),
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        child: Container(
                          height: 20,
                          decoration: boxDecorationDefault(
                            borderRadius: radius(0),
                            color: Colors.white12,
                            boxShadow: [],
                          ),
                        ),
                      ),
                      8.height,
                      ShimmerWidget(
                        child: Container(
                          height: 20,
                          width: 140,
                          decoration: boxDecorationDefault(
                            borderRadius: radius(0),
                            color: Colors.white12,
                            boxShadow: [],
                          ),
                        ),
                      ),
                      16.height,
                      ShimmerWidget(
                        child: Container(
                          height: 15,
                          width: 120,
                          decoration: boxDecorationDefault(
                            borderRadius: radius(0),
                            color: Colors.white12,
                            boxShadow: [],
                          ),
                        ),
                      ),
                    ],
                  ).expand()
                ],
              ),
            ).paddingSymmetric(vertical: 8),
          ),
        ),
      ),
    );
  }
}
