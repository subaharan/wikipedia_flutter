import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:query_params/query_params.dart';
import 'package:shared_preferences/shared_preferences.dart';




class API {
  static final baseUrl = ".wikipedia.org/";
  static final https_ = "https://";

  static Future search(var searchString) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append('gpssearch', searchString);
    queryParams.append('action', 'query');
    queryParams.append('format', 'json');
    queryParams.append('prop', 'pageterms|pageimages');
    queryParams.append('generator', 'prefixsearch');
    queryParams.append('redirects', 1);
    queryParams.append('formatversion', 2);
    queryParams.append('piprop', 'thumbnail');
    queryParams.append('pithumbsize', 50);
    queryParams.append('pilimit', 20);
    queryParams.append('wbptterms', 'description');
    queryParams.append('gpslimit', 15);

    var url = https_+pref.getString('language')+baseUrl + "/w/api.php?"+queryParams.toString() ;
    print(url +pref.getString('language'));
    return http.get(url, headers: {"Accept": "application/json"});
  }




}
