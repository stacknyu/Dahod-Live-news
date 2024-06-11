import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/app_widgets.dart';
import 'package:news_flutter/components/html_widget.dart';

import '../../../main.dart';

class QuickNewsPostDialogWidget extends StatefulWidget {
  final PostModel postModel;

  QuickNewsPostDialogWidget({required this.postModel});

  @override
  State<QuickNewsPostDialogWidget> createState() => _QuickNewsPostDialogWidgetState();
}

class _QuickNewsPostDialogWidgetState extends State<QuickNewsPostDialogWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String postContent = '';

  @override
  void initState() {
    super.initState();
    postContent = getPostContent(widget.postModel.postContent);

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 700));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: ScaleTransition(
            scale: _animation,
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: appStore.isDarkMode ? Colors.grey.shade500 : Colors.transparent)),
              backgroundColor: context.cardColor,
              insetPadding: EdgeInsets.only(left: 12, top: 24, right: 12, bottom: 24),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(parseHtmlString(widget.postModel.postTitle.validate()), style: boldTextStyle(size: 22)),
                        Divider(thickness: 0.1),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: cachedImage(
                            widget.postModel.image.validate(),
                            height: 180.0,
                            width: context.width(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Divider(thickness: 0.1, color: Colors.grey),
                        8.height,
                        HtmlWidget(postContent: postContent),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          width: context.width() - 24,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.15),
                              ],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional.topCenter,
                              end: AlignmentDirectional.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            language.readFullArticle,
                            style: boldTextStyle(color: primaryColor, size: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
