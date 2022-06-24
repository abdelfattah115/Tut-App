import 'package:udvanced_flutter/data/network/error_handler.dart';

import '../response/responses.dart';

var CACHE_HOME_KEY = 'CACHE_KEY_DATA';
var CACHE_DETAILS_KEY = 'CACHE_DETAILS_KEY';
var CACHE_HOME_INTERVAL = 60 * 1000;
var CACHE_DETAILS_INTERVAL = 60 * 1000;

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();

  Future<DetailsResponse> getStoreDetails();

  Future<void> saveDataToCache(HomeResponse homeResponse);

  Future<void> saveStoreDetailsToCache(DetailsResponse detailsResponse);

  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  // run time cache
  Map<String, CacheItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHomeData() async {
    CacheItem? cacheItem = cacheMap[CACHE_HOME_KEY];
    if (cacheItem != null && cacheItem.isValid(CACHE_HOME_INTERVAL)) {
      // return the response from cache
      return cacheItem.data;
    } else {
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveDataToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CacheItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<DetailsResponse> getStoreDetails() {
    CacheItem? cacheItem = cacheMap[CACHE_DETAILS_KEY];
    if (cacheItem != null && cacheItem.isValid(CACHE_DETAILS_INTERVAL)) {
      // return the response from cache
      return cacheItem.data;
    } else {
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(DetailsResponse detailsResponse) async{
   cacheMap[CACHE_DETAILS_KEY] = CacheItem(detailsResponse);
  }
}

class CacheItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CacheItem(this.data);
}

extension CacheItemExtension on CacheItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool isValidTime = currentTime - cacheTime <= expirationTimeInMillis;
    return isValidTime;
  }
}
