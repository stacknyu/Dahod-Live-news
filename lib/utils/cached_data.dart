import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

class CachedData {
  static void storeResponse({Map<String, dynamic>? response, List<Map>? listData, required String responseKey}) async {
    await setValue(responseKey, jsonEncode(response != null ? response : listData));
  }

  static dynamic getCachedData({required String cachedKey}) {
    return getStringAsync(cachedKey).isNotEmpty ? jsonDecode(getStringAsync(cachedKey)) : null;
  }
}
