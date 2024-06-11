import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/notification_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/news/news_detail_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/notifications_list_shimmer.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
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
      appBar: appBarWidget(
        language.notification,
        elevation: 0.2,
        center: true,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        backWidget: BackWidget(color: context.iconColor),
      ),
      body: SnapHelperWidget<NotificationModel>(
        future: getNotificationList(),
        onSuccess: (NotificationModel data) {
          if (data.data.validate().isEmpty) return EmptyStateWidget(height: context.height(), width: context.width(), emptyWidgetTitle: 'No Notifications Yet');
          return AnimatedListView(
            slideConfiguration: SlideConfiguration(delay: 250.milliseconds, curve: Curves.easeOutQuad, verticalOffset: context.height() * 0.1),
            itemCount: data.data.validate().length,
            itemBuilder: (context, index) {
              NotificationData model = data.data![index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cachedImage(model.image.validate(), width: 70, height: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              parseHtmlString(model.title.validate()),
                              style: primaryTextStyle(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            8.height,
                            Text(DateFormat('yyyy-MM-dd').parse(model.datetime.validate()).timeAgo, style: secondaryTextStyle(size: 12)),
                          ],
                        ).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 8).onTap(() {
                      NewsDetailScreen(newsId: model.postId.validate()).launch(context);
                    }),
                  ),
                  //Divider(thickness: 0.1, color: Colors.grey.shade500, height: 0)
                ],
              );
            },
          ).paddingSymmetric(vertical: 8);
        },
        errorWidget: ErrorStateWidget(),
        loadingWidget: NotificationsListShimmer(),
      ),
    );
  }
}
