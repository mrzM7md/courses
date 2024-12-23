import 'dart:convert';
import 'dart:io';

import 'package:course_dashboard/features/sections/courses/data/models/add_course_model.dart';
import 'package:http/http.dart' as http;

class ApiConstance {
  // base link
  // static const String httpServerLink = "http://127.0.0.1:8000/api/v1";
  static const String _hostName = "https://localhost:7272";
  static const String _httpServerLink = "$_hostName/api";
  static const String _httpServerLinkWithCategories = "$_httpServerLink/Categories";
  static const String _httpServerLinkWithCourses = "$_httpServerLink/Course";

  static String getImageLink({required String imageUri}) => "$_hostName$imageUri";


  // ################ START CATEGORIES ENDPOINTS LINK ################
  static String httpLinkGetAllCategories({required int pageNumber, required int pageSize, required String keywordSearch}) => '$_httpServerLinkWithCategories/GetAllCategoriesAsync?PageNumber=$pageNumber&PageSize=$pageSize${
      keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';

  static String httpLinkCreateCategory = '$_httpServerLinkWithCategories/CreateCategoryAsync';
  static String httpLinkUpdateCategory = '$_httpServerLinkWithCategories/UpdateCategoryAsync';
  static String httpLinkDeleteCategory({required int categoryId}) => '$_httpServerLinkWithCategories/RemoveCategoryAsync?categoryId=$categoryId';
  // ################ END CATEGORIES ENDPOINTS LINK ################


  // ################ START COURSES ENDPOINTS LINK ################
  static String httpLinkGetAllCourses({required int pageNumber, required int pageSize, required String keywordSearch}) => '$_httpServerLinkWithCourses/GetAllCoursesAsync?PageNumber=$pageNumber&PageSize=$pageSize${
      keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';

  // ################ END COURSES ENDPOINTS LINK ################

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












  static Future<http.Response> postForm({
    required String url,
    required String accessToken,
    required Map<String, String> data,
    String? filePath,
  }) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    // إضافة حقول البيانات إلى الطلب
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    // إضافة ملف إذا كان موجودًا
    if (filePath != null && filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    // إضافة رؤوس الطلب
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    // إرسال الطلب
    var response = await request.send();

    // تحويل الاستجابة إلى http.Response
    return http.Response.fromStream(response);
  }


}
