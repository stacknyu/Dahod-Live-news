import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/model/dashboard_model.dart';
import 'package:news_flutter/utils/common.dart';

class BannerAdsWidget extends StatefulWidget {
  final List<BannerData> bannerData;

  const BannerAdsWidget({Key? key, required this.bannerData}) : super(key: key);

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      if (_currentPage < widget.bannerData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.bannerData.length,
            itemBuilder: (ctx, index) {
              return cachedImage(widget.bannerData[index].image.validate(), fit: BoxFit.fill).onTap(() {
                launchUrl(widget.bannerData[index].url.validate());
              });
            },
          ),
          Positioned(
            top: 0,
            right: 4,
            child: DotIndicator(
              pageController: _pageController,
              pages: widget.bannerData,
              currentDotSize: 8,
              dotSize: 6,
            ),
          ),
        ],
      ),
    );
  }
}
