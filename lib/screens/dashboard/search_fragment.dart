import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/components/back_widget.dart';
import 'package:news_flutter/components/empty_error_state_widget.dart';
import 'package:news_flutter/components/loading_dot_widget.dart';
import 'package:news_flutter/main.dart';
import 'package:news_flutter/model/post_list_model.dart';
import 'package:news_flutter/model/post_model.dart';
import 'package:news_flutter/network/rest_apis.dart';
import 'package:news_flutter/screens/dashboard/voice_search_screen.dart';
import 'package:news_flutter/screens/news/components/news_item_widget.dart';
import 'package:news_flutter/screens/shimmerScreen/news_item_shimmer.dart';
import 'package:news_flutter/utils/colors.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/extensions/string_extensions.dart';

// ignore: unused_import
import 'package:news_flutter/utils/images.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchFragment extends StatefulWidget {
  final bool? isVoiceSearch;
  final String? voiceText;

  SearchFragment({this.isVoiceSearch, this.voiceText});

  @override
  _SearchFragmentState createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> with WidgetsBindingObserver {
  List<PostModel> searchList = [];

  //Future<List<PostModel>>? future;
  Future<PostListModel>? future;
  TextEditingController searchCont = TextEditingController();
  FocusNode searchNode = FocusNode();

  int page = 1;
  int numPages = 0;

  //Add Code
  SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _lastWords = '';
  bool showClear = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) appStore.setLoading(false);
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init({bool showLoader = false}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    if (widget.voiceText.validate().isNotEmpty) {
      searchCont.text = widget.voiceText.toString();
    }

    future = getSearchBlogList(
      {"text": searchCont.text},
      page,
    ).then((postListModel) {
      if (page == 1) searchList.clear();

      searchList.addAll(postListModel.posts.validate());
      appStore.setLoading(false);
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      return postListModel;
    }).catchError((e) {
      appStore.setLoading(false);

      throw e;
    });

    afterBuildCreated(() {
      _initSpeech();
      if (widget.isVoiceSearch.validate()) {
        startListening(context);
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening(BuildContext context) async {
    hideKeyboard(context);
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// listen method.
  Future<void> stopListening(BuildContext context) async {
    hideKeyboard(context);
    await _speechToText.stop();
    setState(() {});
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    _lastWords = result.recognizedWords;
    searchCont.text = _lastWords;
    if (_lastWords.isNotEmpty) {
      stopListening(context);
      init(showLoader: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (_speechToText.isListening) {
      stopListening(context);
    }
    super.dispose();
  }

  Future<void> _onClearSearch() async {
    searchCont.clear();
    hideKeyboard(context);
    init(showLoader: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: context.scaffoldBackgroundColor,
        systemOverlayStyle: defaultSystemUiOverlayStyle(context),
        leading: BackWidget(color: context.iconColor),
        leadingWidth: 20,
        title: AppTextField(
          controller: searchCont,
          textFieldType: TextFieldType.NAME,
          cursorColor: primaryColor,
          decoration: inputDecoration(
            context,
            hintText: language.search,
            prefixIcon: ic_search.iconImageColored().paddingAll(16),
            suffixIcon: !showClear
                ? Offstage()
                : ic_clear.iconImageColored(color: primaryColor, size: 20).onTap(
                    () {
                      _onClearSearch();
                    },
                  ),
          ),
          onChanged: (newValue) {
            if (newValue.isEmpty) {
              showClear = false;
              _onClearSearch();
            } else {
              Timer(Duration(milliseconds: 800), () {
                init(showLoader: true);
              });
              showClear = true;
            }
            setState(() {});
          },
          onFieldSubmitted: (searchString) async {
            hideKeyboard(context);
            init(showLoader: true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic, color: primaryColor),
            color: primaryColor,
            onPressed: () async {
              String? val = await VoiceSearchScreen().launch(context);
              if (val is String && val.validate().isNotEmpty) {
                searchCont.text = val.validate();
                init(showLoader: true);
              }
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SnapHelperWidget(
              future: future,
              loadingWidget: NewsItemShimmer(),
              onSuccess: (data) {
                if (searchList.isEmpty && !appStore.isLoading) {
                  return EmptyStateWidget(
                    emptyWidgetTitle: language.noRecentSearchesFound,
                    width: context.width(),
                    height: 200,
                  ).center();
                } else
                  return AnimatedScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 90, left: 8, right: 8, top: 0),
                    onNextPage: () async {
                      setState(() {
                        page++;
                      });
                      init(showLoader: true);
                      await 1.seconds.delay;
                    },
                    onSwipeRefresh: () async {
                      setState(() {
                        page = 1;
                      });
                      init(showLoader: false);
                      await 1.seconds.delay;
                    },
                    children: List.generate(
                      searchList.length,
                      (index) {
                        return NewsItemWidget(
                          searchList[index],
                          index: index,
                        );
                      },
                    ),
                  );
              },
            ).paddingSymmetric(vertical: 16),
            //Observer(builder: (context) => LoadingDotsWidget().visible(appStore.isLoading && showClear).center()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: searchCont.text.isNotEmpty
                  ? 16
                  : page < 1
                      ? 0
                      : null,
              child: Observer(builder: (context) {
                return ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0, tileMode: TileMode.mirror),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: LoadingDotsWidget(),
                      color: context.cardColor.withOpacity(0.3),
                    ),
                  ),
                ).visible(appStore.isLoading);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
