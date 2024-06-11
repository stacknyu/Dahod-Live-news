import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetWebView extends StatefulWidget {
  final String? tweetUrl;

  final double? aspectRatio;

  TweetWebView({this.tweetUrl, this.aspectRatio});

  @override
  _TweetWebViewState createState() => new _TweetWebViewState();
}

class _TweetWebViewState extends State<TweetWebView> {
  WebViewController? wbController;
  String? _postHTML;
  double _height = 490;

  @override
  void initState() {
    super.initState();
    _postHTML = widget.tweetUrl;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wbController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(context.scaffoldBackgroundColor)
      ..addJavaScriptChannel('PageHeight', onMessageReceived: (JavaScriptMessage message) {
        _setHeight(double.parse(message.message));
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => CircularProgressIndicator(),
          onPageFinished: (String url) {
            final color = colorToHtmlRGBA(getBackgroundColor(context));
            wbController?.runJavaScriptReturningResult('document.body.style= "background-color: $color"');
            wbController?.runJavaScriptReturningResult('setTimeout(() => sendHeight(), 0)');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) {
            final url = navigation.url;
            if (navigation.isMainFrame) {
              launchUrl(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.dataFromString(getHtmlBody(), mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));

    final ar = widget.aspectRatio;
    return (ar != null)
        ? Container(
            constraints: BoxConstraints(
              maxHeight: context.height() / 1.25,
              maxWidth: context.width(),
            ),
            decoration: boxDecorationDefault(boxShadow: [], color: context.cardColor, borderRadius: radius()),
            child: AspectRatio(
              aspectRatio: ar,
              child: WebViewWidget(controller: wbController!).cornerRadiusWithClipRRect(defaultRadius),
            ),
          )
        : Container(
            height: _height,
            color: Colors.transparent,
            child: WebViewWidget(controller: wbController!).cornerRadiusWithClipRRect(defaultRadius),
            width: context.width(),
          );
  }

  void _setHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  String colorToHtmlRGBA(Color c) {
    return 'rgba(${c.red},${c.green},${c.blue},${c.alpha / 255})';
  }

  Color getBackgroundColor(BuildContext context) {
    return context.scaffoldBackgroundColor;
  }

  String getHtmlBody() => """
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            *{box-sizing: border-box;margin:0px; padding:0px;}
            .twitter-tweet, .ttter-tweet {display: none;}
             widget {
                        display: bloc; 
                        justify-content: center;
                        margin: 0 auto;
                        max-width:100%;
                        max-height:100%;
                        height: 100%;
                        clear: both;
                    }              
          </style>
        </head>
        <body>
        <blockquote class="twitter-tweet">  
            <div id="widget">$_postHTML $htmlScriptUrl</div>               
          </blockquote>      
         <blockquote class="instagram-media">
                 $_postHTML $htmlScriptUrlInstagram 
          </blockquote>         
        </body>
      </html>
    """;

// <div id="widget">$_postHTML $htmlScriptUrl</div>
// $dynamicHeightScriptSetup
//           $dynamicHeightScriptCheck

  // static const String dynamicHeightScriptSetup = """
  //   <script type="text/javascript">
  //     const widget = document.getElementById('widget');
  //     const sendHeight = () => PageHeight.postMessage(widget.clientHeight);
  //   </script>
  // """;

  // static const String dynamicHeightScriptCheck = """
  //   <script type="text/javascript">
  //     const onWidgetResize = (widgets) => sendHeight();
  //     const resize_ob = new ResizeObserver(onWidgetResize);
  //     resize_ob.observe(widget);
  //   </script>
  // """;

  String get htmlScriptUrl => _postHTML!.contains("twitter") ? "<script type='text/javascript' src='https://platform.twitter.com/widgets.js'></script>" : "";

  String get htmlScriptUrlInstagram => _postHTML!.contains("instagram") ? "<script type='text/javascript' src='https://www.instagram.com/embed.js'></script>" : "";

  // String get htmlStyle => _postHTML!.contains("twitter")
  //     ? "<style>*{box-sizing: border-box;margin:1px; padding:0px;}widget {display: flex;justify-content: center;margin: 0 auto;max-width:100%;}</style>"
  //     : "";
}
