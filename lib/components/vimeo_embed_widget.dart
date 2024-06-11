import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VimeoEmbedWidget extends StatelessWidget {
  final String videoId;

  VimeoEmbedWidget(this.videoId);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(Colors.transparent)
            ..loadRequest(
              Uri.dataFromString(
                '<html><iframe src="https://player.vimeo.com/video/$videoId" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen" mozallowfullscreen="mozallowfullscreen" msallowfullscreen="msallowfullscreen" oallowfullscreen="oallowfullscreen" webkitallowfullscreen="webkitallowfullscreen"></iframe></html>',
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ),
            ),
        ),
        // child: Html(
        //   data:
        //       '<iframe src="https://player.vimeo.com/video/$videoId" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen" mozallowfullscreen="mozallowfullscreen" msallowfullscreen="msallowfullscreen" oallowfullscreen="oallowfullscreen" webkitallowfullscreen="webkitallowfullscreen"></iframe>',
        // ),
      ),
    ).onTap(() {
      url_launcher.launchUrl(Uri.parse('https://player.vimeo.com/video/$videoId'), mode: LaunchMode.inAppWebView);
    });
  }
}
