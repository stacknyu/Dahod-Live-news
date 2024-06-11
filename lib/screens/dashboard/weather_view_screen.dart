import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/model/weather_model.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';

import '../../main.dart';

class WeatherViewScreen extends StatefulWidget {
  final WeatherModel weatherModel;

  WeatherViewScreen(this.weatherModel);

  @override
  WeatherViewScreenState createState() => WeatherViewScreenState();
}

class WeatherViewScreenState extends State<WeatherViewScreen> {
  int dayWeather = 0;
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    myBanner = buildBannerAd()..load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BANNER_AD_ID_FOR_ANDROID,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
      ),
      request: AdRequest(),
    );
  }

  @override
  void setState(fn) {
    myBanner = buildBannerAd()..load();
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  Color getColor(int count) {
    if (count >= 0 && count <= 50) {
      return Color(0xFF34A12B);
    } else if (count > 50 && count <= 100) {
      return Color(0xFFD4CC0F);
    } else if (count > 100 && count <= 200) {
      return Color(0xFFE9572A);
    } else if (count > 200 && count <= 300) {
      return Color(0xFFEC4D9F);
    } else if (count > 300 && count <= 400) {
      return Color(0xFF9858A2);
    } else {
      return Color(0xFFC11E2F);
    }
  }

  Widget airQualityData(String image, int data, {double width = 35, double height = 35}) {
    return SizedBox(
      width: context.width() / 3 - 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cachedImage(image, height: height, width: width, color: context.dividerColor),
          8.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$data', style: boldTextStyle(color: Colors.black)),
              4.width,
              Text(suffixText, style: secondaryTextStyle(size: 14, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    ).paddingAll(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appStore.isDarkMode ? context.cardColor : Colors.grey.shade100,
                  image: DecorationImage(image: AssetImage(appStore.isDarkMode ? ic_night : ic_morning), fit: BoxFit.fitHeight),
                ),
              ),
              Positioned(
                top: 100,
                left: 28,
                child: Column(
                  children: [
                    cachedImage(wind_fan, width: 80),
                    Text('${widget.weatherModel.current!.wind_kph.validate()}km/h', style: primaryTextStyle(color: appStore.isDarkMode ? textBlueColor : Colors.white)),
                    Text(language.windSpeed, style: secondaryTextStyle(color: Colors.white70))
                  ],
                ),
              ),
              Positioned(
                top: 132,
                right: 28,
                child: Column(
                  children: [
                    Text('${widget.weatherModel.current!.feelslike_c.validate().round()}°C', style: boldTextStyle(size: 32, color: Colors.white)),
                    Text('${DateFormat(weatherDisplayFormat).format(DateTime.now())}', style: primaryTextStyle(color: Colors.white)),
                    Text('${widget.weatherModel.location!.name.validate()}', style: secondaryTextStyle(size: 16, color: Colors.white70))
                  ],
                ),
              ),
            ],
          ),
          AnimatedScrollView(
            padding: EdgeInsets.only(top: 260),
            children: [
              if (!isAdsDisabled && myBanner != null)
                Container(
                  height: 60,
                  child: myBanner != null ? AdWidget(ad: myBanner!) : Offstage(),
                ),
              Divider(
                color: Colors.grey.shade200,
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(language.thisWeek, style: boldTextStyle(size: 20, color: appStore.isDarkMode ? Colors.white : Colors.black)).paddingSymmetric(horizontal: 16, vertical: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(widget.weatherModel.forecast!.forecastday.validate().length, (index) {
                        Day day = widget.weatherModel.forecast!.forecastday.validate()[index].day!;
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(color: dayWeather == index ? primaryColor.withOpacity(0.4) : context.cardColor, borderRadius: BorderRadius.circular(defaultRadius)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${DateFormat.MMMd().format(DateFormat('yyyy-MM-dd').parse(widget.weatherModel.forecast!.forecastday.validate()[index].date.validate()))}',
                                style: secondaryTextStyle(size: 16, color: Colors.white70),
                              ),
                              cachedImage('https:${day.condition!.icon.validate()}'),
                              Text('${day.maxtemp_c}° ${day.mintemp_c}°', style: boldTextStyle(size: 14)),
                            ],
                          ),
                        ).onTap(
                          () {
                            dayWeather = index;
                            setState(() {});
                          },
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        );
                      }),
                    ),
                  )
                ],
              ).paddingTop(32).visible(widget.weatherModel.forecast!.forecastday.validate().isNotEmpty),
              Container(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 66),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.shade200),
                      if (widget.weatherModel.current!.air_quality != null)
                        Stack(
                          children: [
                            Positioned(bottom: 0, child: cachedImage(ic_wave, width: context.width(), color: primaryColor)),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(language.majorAirPollutant, style: boldTextStyle(size: 20, color: appStore.isDarkMode ? Colors.white : Colors.black)),
                                ).paddingOnly(top: 8, bottom: 8),
                                Wrap(
                                  children: [
                                    if (widget.weatherModel.current!.air_quality!.pm2_5.validate() != 0) airQualityData(ic_pm2, widget.weatherModel.current!.air_quality!.pm2_5.validate().round()),
                                    if (widget.weatherModel.current!.air_quality!.pm10.validate() != 0) airQualityData(ic_pm10, widget.weatherModel.current!.air_quality!.pm10.validate().round()),
                                    if (widget.weatherModel.current!.air_quality!.so2.validate() != 0) airQualityData(ic_so2, widget.weatherModel.current!.air_quality!.so2.validate().round()),
                                    if (widget.weatherModel.current!.air_quality!.co.validate() != 0) airQualityData(ic_co, widget.weatherModel.current!.air_quality!.co.validate().round()),
                                    if (widget.weatherModel.current!.air_quality!.o3.validate() != 0) airQualityData(ic_o3, widget.weatherModel.current!.air_quality!.o3.validate().round(), width: 40),
                                    if (widget.weatherModel.current!.air_quality!.no2.validate() != 0)
                                      airQualityData(ic_no2, widget.weatherModel.current!.air_quality!.no2.validate().round(), width: 40),
                                  ],
                                ).paddingAll(8),
                              ],
                            ).paddingSymmetric(
                              horizontal: 16,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 32,
            left: 16,
            child: BackWidget(),
          ),
        ],
      ),
    );
  }
}
