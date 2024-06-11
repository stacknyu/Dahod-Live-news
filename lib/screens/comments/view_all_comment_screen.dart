import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/components/internet_connectivity_widget.dart';
import 'package:news_flutter/model/view_comment_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/comments/write_comment_screen.dart';
import 'package:news_flutter/screens/shimmerScreen/shimmer_component/comment_shimmer_component.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/utils/constant.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/utils/images.dart';

class ViewAllCommentScreen extends StatefulWidget {
  final int? id;

  final String? password;

  ViewAllCommentScreen({required this.id, this.password});

  @override
  _ViewAllCommentScreenState createState() => _ViewAllCommentScreenState();
}

class _ViewAllCommentScreenState extends State<ViewAllCommentScreen> {
  ScrollController _scrollController = ScrollController();

  Future<List<ViewCommentModel>>? future;

  List<ViewCommentModel> commentList = [];

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(CHANGE_COMMENT, (p0) {
      init();
    });
  }

  void init() async {
    future = getCommentList(widget.id.validate(), page: mPage, password: widget.password ?? '').then((value) {
      if (mPage == 1) commentList.clear();

      mIsLastPage = value.length != 20;
      commentList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      log(e.toString());
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage && commentList.isNotEmpty) {
          mPage++;
          future = getCommentList(widget.id.validate(), page: mPage).then((value) {
            if (mPage == 1) commentList.clear();

            mIsLastPage = value.length != 20;
            commentList.addAll(value);
            setState(() {});
            appStore.setLoading(false);
            return value;
          }).catchError((e) {
            log(e.toString());
          });
        }
      }
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
    return Scaffold(
      appBar: appBarWidget(
        language.comments,
        color: appStore.isDarkMode ? appBackGroundColor : white,
        backWidget: BackWidget(color: context.iconColor),
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        elevation: 0.2,
        center: true,
      ),
      body: InternetConnectivityWidget(
        retryCallback: () {
          init();
          setState(() {});
        },
        child: SnapHelperWidget<List<ViewCommentModel>>(
          future: future,
          loadingWidget: CommentShimmerWidget(),
          useConnectionStateForLoader: true,
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
            if (data.length == 0) {
              return NoDataWidget(title: language.noRecordFound, image: ic_no_data).center();
            } else {
              return AnimatedListView(
                itemCount: data.validate().length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(16),
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
                              ),
                              4.height,
                              Text(
                                comment.date != null ? convertDate(comment.date) : '',
                                style: secondaryTextStyle(size: 10),
                              ),
                            ],
                          ).expand(),
                          Spacer(),
                          if (comment.author == appStore.userId && appStore.userId.validate().toString() != '0')
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await showInDialog(
                                      context,
                                      shape: dialogShape(),
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
                                    ).then((value) {
                                      init();
                                    });
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
                      8.height,
                      ReadMoreText(
                        parseHtmlString(
                          comment.content!.rendered != null ? comment.content!.rendered : '',
                        ),
                        trimLines: 2,
                        style: secondaryTextStyle(size: textSizeSMedium),
                        colorClickableText: primaryColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...${language.readMore}',
                        trimExpandedText: language.readLess,
                      ),
                      if (comment.content!.rendered.validate().isNotEmpty && comment.content!.rendered.validate().length > 40) 16.height,
                      Divider(color: Colors.grey.shade500, thickness: 0.1),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
