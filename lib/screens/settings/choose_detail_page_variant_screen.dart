import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/main.dart';

class ChooseDetailPageVariantScreen extends StatefulWidget {
  @override
  ChooseDetailPageVariantScreenState createState() => ChooseDetailPageVariantScreenState();
}

class ChooseDetailPageVariantScreenState extends State<ChooseDetailPageVariantScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.chooseDetailPageVariant, center: true, backWidget: BackWidget(color: context.iconColor), elevation: 0.2, color: appStore.isDarkMode ? appBackGroundColor : white),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Wrap(
          runSpacing: 16,
          spacing: 16,
          children: [
            itemWidget(
              context,
              title: language.variant + '1',
              code: 1,
              onTap: () {
                setValue(DETAIL_PAGE_VARIANT, 1);
                setState(() {});
              },
            ),
            itemWidget(
              context,
              title: language.variant + '2',
              code: 2,
              onTap: () {
                setValue(DETAIL_PAGE_VARIANT, 2);
                setState(() {});
              },
            ),
            itemWidget(
              context,
              title: language.variant + ' 3',
              code: 3,
              onTap: () {
                setValue(DETAIL_PAGE_VARIANT, 3);
                setState(() {});
              },
            ),
          ],
        ).center(),
      ),
    );
  }
}

Widget itemWidget(BuildContext context, {required Function onTap, String? title, int code = 1, String? img}) {
  return Container(
    width: (context.width() - (2 * 16) - 16) * 0.50,
    height: 310,
    alignment: Alignment.center,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/news/images/image_variant_$code.jpg',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 800),
          color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code ? Colors.black45 : Colors.black12,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 800),
          child: Text(title.validate(), style: boldTextStyle(color: textPrimaryColor)),
          decoration: BoxDecoration(color: getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code ? Colors.white : Colors.white54, borderRadius: radius(defaultRadius)),
          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        ).center(),
        Positioned(
          top: 8,
          right: 8,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 800),
            padding: EdgeInsets.all(4),
            child: Icon(Icons.check, size: 18, color: primaryColor),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: defaultBoxShadow()),
          ).visible(getIntAsync(DETAIL_PAGE_VARIANT, defaultValue: 1) == code),
        ),
      ],
    ),
  ).onTap(() {
    onTap.call();
  }, splashColor: Colors.transparent, highlightColor: Colors.transparent).cornerRadiusWithClipRRect(8.0);
}
