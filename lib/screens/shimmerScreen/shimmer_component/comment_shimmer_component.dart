import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class CommentShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        children: [
          ShimmerWidget(
            child: Container(
              width: context.width() - 32,
              decoration: boxDecorationDefault(
                color: Colors.white10,
                boxShadow: [],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Wrap(
            runSpacing: 16,
            spacing: 16,
            children: List.generate(
              5,
              (index) => ShimmerWidget(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: Colors.transparent,
                    boxShadow: [],
                    borderRadius: radius(),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: boxDecorationDefault(color: Colors.white10, boxShadow: [], shape: BoxShape.circle),
                            ),
                          ),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                decoration: boxDecorationDefault(
                                  color: Colors.white10,
                                  boxShadow: [],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              16.height,
                              Container(
                                height: 20,
                                width: context.width() / 2 - 24,
                                decoration: boxDecorationDefault(
                                  color: Colors.white10,
                                  boxShadow: [],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )
                            ],
                          ).expand(),
                        ],
                      ),
                      16.height,
                      Container(
                        height: 20,
                        decoration: boxDecorationDefault(
                          color: Colors.white10,
                          boxShadow: [],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
