import 'dart:async';
import "dart:collection";
import 'dart:convert';
import "dart:core";
import 'dart:io';
import "dart:math";
import 'package:crypto/crypto.dart' as crypto;

import 'package:http/http.dart' as http;

class QueryString {
  static Map parse(String query) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);
    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1))] = decode(match.group(2));
    }
    return result;
  }
}

class WooCommerceAPI {
  String url;
  String consumerKey;
  String consumerSecret;
  bool isHttps;

  WooCommerceAPI({this.url, this.consumerKey, this.consumerSecret}) {
    if (this.url.startsWith("https")) {
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }
  }

  getOAuthURL(String requestMethod, String endpoint) {
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;

    var token = "";
    var url = this.url + endpoint;
    var containsQueryParams = url.contains("?");
    // print('getURL: $url');

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (this.isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret
              : "?consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret);
    }
    // random nonce value create
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });
// nonce value will get change as per the timestamp changes
    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

    var method = requestMethod;
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }
//to add all named parameter in map so that we can values of all params correctly & easily
    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    var signingKey = consumerSecret + "&" + token;

    var hmacSha1 =
        new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    var finalSignature = base64Encode(signature.bytes);

    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
      print('requestUrl: $requestUrl');
    }

  // print('network: $requestUrl');

    print('requestUrl: $requestUrl');
    return requestUrl;
  }

  //--------------------------get method-------------

  Future<dynamic> getAsync(String endPoint, {Map data}) async {

    var url = this.getOAuthURL("GET", endPoint);
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

//--------------------------post method-------------
  Future<dynamic> postAsync(String endPoint, Map data) async {
    var url = this.getOAuthURL("POST", endPoint);
    // print(url);
    var client = new http.Client();
    Map<String, String> headers = HashMap();
    headers.update(
        HttpHeaders.contentTypeHeader, (_) => 'application/json; charset=utf-8',
        ifAbsent: () => 'application/json; charset=utf-8');
    headers.update(HttpHeaders.cacheControlHeader, (_) => 'no-cache',
        ifAbsent: () => 'no-cache');
    var response = await client.post(Uri.parse(url),
        headers: headers, body: json.encode(data));

    return json.decode(response.body);
  }

  Future<dynamic> deleteAsync(String endPoint, {Map data}) async {
    var url = this.getOAuthURL("DELETE", endPoint);
    // print(url);
    final response = await http.delete(url);
    // print(response.body);
    return json.decode(response.body);
  }

  Future<dynamic> putAsync(String endPoint, Map data) async {
    var url = this.getOAuthURL("PUT", endPoint);
    // print(url);
    var client = new http.Client();
    Map<String, String> headers = HashMap();
    headers.update(
        HttpHeaders.contentTypeHeader, (_) => 'application/json; charset=utf-8',
        ifAbsent: () => 'application/json; charset=utf-8');
    headers.update(HttpHeaders.cacheControlHeader, (_) => 'no-cache',
        ifAbsent: () => 'no-cache');
    var response = await client.put(Uri.parse(url),
        headers: headers, body: json.encode(data));

    return json.decode(response.body);
  }
}
