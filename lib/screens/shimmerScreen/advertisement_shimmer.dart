import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/shimmer_widget.dart';

class AdvertisementBannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        decoration: boxDecorationDefault(boxShadow: [], color: Colors.white10, borderRadius: radius(0)),
      ),
    );
  }
}
