import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/utils/images.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  var darkMode = false;
  var copyrightText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (getStringAsync(COPYRIGHT_TEXT).isNotEmpty) {
      copyrightText = getStringAsync(COPYRIGHT_TEXT);
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.about,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        center: true,
        elevation: 0.2,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                APP_ICON,
                width: 50,
                height: 50,
              ).cornerRadiusWithClipRRect(defaultRadius),
              8.height,
              Text(
                '$APP_NAME',
                style: boldTextStyle(size: 28),
              ),
              24.height,
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 15,
                    decoration: BoxDecoration(color: primaryColor),
                  ),
                  4.width,
                  Text(language.about, style: boldTextStyle(size: 18))
                ],
              ),
              8.height,
              Text(aboutApp, style: secondaryTextStyle(size: textSizeMedium)),
              16.height,
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      launchUrl(SITE_URL);
                    },
                    child: Text(language.ourWebsite, style: boldTextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      const uri = 'mailto:$MAILTO';
                      url_launcher.launchUrl(Uri.parse(uri));
                    },
                    child: Text(language.email, style: boldTextStyle(color: Colors.white)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: context.width(),
        height: context.height() * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              language.followUs,
              style: boldTextStyle(size: textSizeMedium),
            ).visible(getStringAsync(WHATSAPP).isNotEmpty),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(INSTAGRAM)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_inst, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(INSTAGRAM).isNotEmpty),
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(TWITTER)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_twitter, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(TWITTER).isNotEmpty),
                InkWell(
                  onTap: () => redirectUrl(getStringAsync(FACEBOOK)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(ic_fb, height: 35, width: 35),
                  ),
                ).visible(getStringAsync(FACEBOOK).isNotEmpty),
                if (getStringAsync(CONTACT).isNotEmpty)
                  InkWell(
                    onTap: () => redirectUrl('tel:${getStringAsync(CONTACT)}'),
                    child: Container(
                      margin: EdgeInsets.only(right: 16.toDouble()),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(ic_call_ring, height: 35, width: 35, color: primaryColor),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
