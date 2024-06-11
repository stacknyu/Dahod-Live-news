import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/configs.dart';
import 'package:news_flutter/utils/common.dart';
import 'package:news_flutter/utils/constant.dart';
import 'dart:developer' as dev;

import '../main.dart';

Future<Map<String, String>> buildHeaderTokens({bool requireToken = false, bool isBearer = false}) async {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
  };

  if (requireToken) {
    String token = getStringAsync(TOKEN);
    if (isBearer) {
      token = "Bearer ${getStringAsync(TOKEN)}";
    }
    int? id = appStore.userId;
    if (isBearer) {
      header.putIfAbsent('Authorization', () => token);
    } else {
      header.putIfAbsent('token', () => token);
    }
    print("Token" + token.toString());
    print("Token" + id.toString());

    header.putIfAbsent('id', () => id.toString());
  }
  return header;
}

getRequest(String endPoint, {bool requireToken = false, bool isBearer = false}) async {
  if (await isNetworkAvailable()) {
    var header = await buildHeaderTokens(requireToken: requireToken, isBearer: isBearer);

    print(header);
    print('$BASE_URL$endPoint');

    Response response = await get(Uri.parse('$BASE_URL$endPoint'), headers: header);

    print('${response.statusCode} ${jsonDecode(response.body)}');
    return response;
  } else {
    throw noInternetMsg;
  }
}

Future<Response> postRequest(String endPoint, Map request, {bool requireToken = false, bool isBearer = false}) async {
  if (await isNetworkAvailable()) {
    log('URL: $BASE_URL$endPoint');
    log('Request: $request');
    log('id: ${appStore.userId}');

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (requireToken) {
      String token = '${getStringAsync(TOKEN)}';
      if (isBearer) {
        token = "Bearer ${getStringAsync(TOKEN)}";
      }
      var header = {"id": "${appStore.userId}"};
      if (isBearer) {
        header.putIfAbsent('Authorization', () => token);
      } else {
        headers.putIfAbsent('token', () => token);
      }
      headers.addAll(header);
    }
    log(headers);

    Response response = await post(Uri.parse('$BASE_URL$endPoint'), body: jsonEncode(request), headers: headers);
    log('Response : ${response.body}');
    return response;
  } else {
    throw noInternetMsg;
  }
}

Future<Response> putRequest(String endPoint, Map request, {bool requireToken = false, bool isBearer = false}) async {
  if (await isNetworkAvailable()) {
    log('URL: $BASE_URL$endPoint');
    log('Request: $request');
    log('id: ${appStore.userId}');

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (requireToken) {
      String token = '${getStringAsync(TOKEN)}';
      if (isBearer) {
        token = "Bearer ${getStringAsync(TOKEN)}";
      }
      var header = {"id": "${appStore.userId}"};
      if (isBearer) {
        header.putIfAbsent('Authorization', () => token);
      } else {
        headers.putIfAbsent('token', () => token);
      }
      headers.addAll(header);
    }
    log(headers);

    Response response = await put(Uri.parse('$BASE_URL$endPoint'), body: jsonEncode(request), headers: headers);
    log('Method Type : ${response..request}');
    log('Response : ${response.body}');

    return response;
  } else {
    throw noInternetMsg;
  }
}

Future<Response> deleteRequest(String endPoint,{ required Map request, bool requireToken = false, bool isBearer = false}) async {
  if (await isNetworkAvailable()) {
    log('URL: $BASE_URL$endPoint');
    log('Request: $request');
    log('id: ${appStore.userId}');

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (requireToken) {
      String token = '${getStringAsync(TOKEN)}';
      if (isBearer) {
        token = "Bearer ${getStringAsync(TOKEN)}";
      }
      var header = {"id": "${appStore.userId}"};
      if (isBearer) {
        header.putIfAbsent('Authorization', () => token);
      } else {
        headers.putIfAbsent('token', () => token);
      }
      headers.addAll(header);
    }
    log(headers);

    Response response = await delete(Uri.parse('$BASE_URL$endPoint'), body: jsonEncode(request), headers: headers);
    log('Response : ${response.body}');
    return response;
  } else {
    throw noInternetMsg;
  }
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw noInternetMsg;
  }

  log('Response : ${response.body}');
  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    if (response.body.isJson()) {
      throw parseHtmlString(jsonDecode(response.body)['message']);
    } else {
      //throw errorMsg;
      if (response.statusCode == 403) {
        if (response.body.contains('jwt_auth')) {
          throw "Login msg Test";
        }
      }
    }
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
  bool fullLog = false,
}) {
  // fullLog = statusCode.isSuccessful();
  if (fullLog) {
    dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('MethodType ($methodtype) | StatusCode ($statusCode)');
    dev.log('\x1B[32m${formatJson(responseBody)}\x1B[0m', name: 'Response');
    //dev.log('Response ($methodtype) : statusCode:{$responseBody}');
    dev.log("\u001B[0m");
    dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m${headers.split(',').join(',\n')}\u001B[39m");
    if (hasRequest) {
      log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('MethodType ($methodtype) | statusCode: ($statusCode)');
    log('Response : ');
    log('$responseBody');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}
