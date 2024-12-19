import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConstance {
  // base link
  // static const String httpServerLink = "http://127.0.0.1:8000/api/v1";
  static const String _httpServerLink = "https://localhost:7272/api";

  // start endpoints
  static String httpLinkGetAllCategories({required int pageNumber, required int pageSize, required String? keywordSearch}) => '$_httpServerLink/categories/GetAllCategoriesAsync?PageNumber=$pageNumber&PageSize=$pageSize';

  static Future<http.Response> getData({required String url ,required String accessToken}) async {
    var response = await http.get(
      Uri.parse(url),
      // headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  static Future<http.Response> postData({required String url ,required String accessToken, required Map<String, dynamic> data}) async {
    return await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'},
    );
  }


  static Future<http.Response> putData({required String url ,required String accessToken, required Map<String, dynamic> data}) async {
    return await http.put(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'},
    );
  }


  static Future<http.Response> deleteData({required String url ,required String accessToken,}) async {
    return await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'},
    );
  }


  static Future<http.Response> login({required String url, required String email, required String password}) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
    return await http.get(
      Uri.parse(url),
      headers: <String, String>{'authorization': basicAuth},
    );
  }

  static Future<http.Response> getRequest({required String url}) async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    return response;
  }
}
