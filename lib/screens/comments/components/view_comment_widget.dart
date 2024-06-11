import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/model/view_comment_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/comments/view_all_comment_screen.dart';
import 'package:news_flutter/screens/comments/write_comment_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/comment_shimmer_component.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/components/see_all_button_widget.dart';
import 'package:news_flutter/main.dart';

class ViewCommentWidget extends StatefulWidget {
  final int? id;
  final int itemLength;

  final String? password;

  ViewCommentWidget({required this.id, required this.itemLength, this.password});

  @override
  _ViewCommentWidgetState createState() => _ViewCommentWidgetState();
}

class _ViewCommentWidgetState extends State<ViewCommentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getCommentList(widget.id.validate(), page: 1, password: widget.password ?? '');
    LiveStream().on(CHANGE_COMMENT, (p0) {
      appStore.setLoading(true);
      setState(() {});
      appStore.setLoading(false);
    });
  }

  Future<void> deleteComment({int? id}) async {
    Map req = {"id": id};

    appStore.setLoading(true);

    await deleteCommentList(req).then((value) {
      appStore.setLoading(false);
      LiveStream().emit(CHANGE_COMMENT);
      toast(language.commentDeleted);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SnapHelperWidget<List<ViewCommentModel>>(
          future: getCommentList(widget.id.validate(), page: 1, password: widget.password ?? ''),
          loadingWidget: CommentShimmerWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                init();

                setState(() {});
              },
            );
          },
          errorWidget: ErrorStateWidget(),
          onSuccess: (data) {
            if (data.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.comments, style: boldTextStyle(size: textSizeMedium)).paddingSymmetric(horizontal: 16),
                  24.height,
                  Text(language.noCommentsYet, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(language.comment + ' (${data.validate().length})', style: boldTextStyle(size: textSizeMedium)).expand(),
                      if (data.length > 3)
                        SeeAllButtonWidget(
                          onTap: () {
                            ViewAllCommentScreen(id: widget.id.validate(), password: widget.password ?? '').launch(context);
                          },
                          widget: Text(language.seeAll, style: primaryTextStyle(color: primaryColor)),
                        )
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 8),
                  AnimatedListView(
                    itemCount: data.take(3).length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    physics: NeverScrollableScrollPhysics(),
                    slideConfiguration: SlideConfiguration(delay: 250.milliseconds, curve: Curves.easeOutQuad, verticalOffset: context.height() * 0.1),
                    itemBuilder: (context, i) {
                      ViewCommentModel comment = data[i];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: boxDecoration(context, bgColor: Colors.grey, radius: 23.0),
                                child: cachedImage(
                                  comment.author == appStore.userId ? appStore.userProfileImage.validate() : comment.author_avatar_urls!.avatarFortyEight.toString(),
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(24),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.authorName.validate().capitalizeFirstLetter(),
                                    style: boldTextStyle(size: textSizeMedium),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  4.height,
                                  Text(comment.date != null ? convertDate(comment.date) : '', style: secondaryTextStyle(size: 10)),
                                ],
                              ).expand(),
                              Spacer(),
                              if (comment.author == appStore.userId && appStore.userId != 0)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showInDialog(
                                          context,
                                          shape: dialogShape(),
                                          backgroundColor: context.cardColor,
                                          builder: (context) {
                                            return WriteCommentScreen(
                                              id: widget.id.validate(),
                                              hideTitle: true,
                                              commentId: comment.id,
                                              isUpdate: true,
                                              password: widget.password ?? '',
                                              editCommentText: parseHtmlString(comment.content!.rendered),
                                            );
                                          },
                                        );
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showConfirmDialogCustom(
                                          context,
                                          title: language.deleteComment,
                                          primaryColor: primaryColor,
                                          onAccept: (c) async {
                                            deleteComment(id: comment.id);
                                          },
                                          dialogType: DialogType.DELETE,
                                          negativeText: language.no,
                                          positiveText: language.yes,
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                )
                            ],
                          ),
                          4.height,
                          ReadMoreText(
                            parseHtmlString(comment.content!.rendered != null ? comment.content!.rendered : ''),
                            trimLines: 2,
                            style: secondaryTextStyle(size: textSizeSMedium),
                            colorClickableText: primaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...${language.readMore}',
                            trimExpandedText: language.readLess,
                          ),
                          if (comment.content!.rendered.validate().isNotEmpty && comment.content!.rendered.validate().length > 40) 16.height,
                        ],
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
        Observer(builder: (context) => Loader(color: primaryColor, valueColor: AlwaysStoppedAnimation(Colors.white)).visible(appStore.isLoading).center())
      ],
    );
  }
}
