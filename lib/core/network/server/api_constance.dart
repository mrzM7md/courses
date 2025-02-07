import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiConstance {
  // base link
  static const String _hostName = "http://courses.runasp.net";
  // static const String _hostName = "https://localhost:7272";
  static const String _httpServerLink = "$_hostName/api";
  static const String _httpServerLinkWithCategories =
      "$_httpServerLink/Categories";
  static const String _httpServerLinkWithCourses = "$_httpServerLink/Course";
  static const String _httpServerLinkWithUnits = "$_httpServerLink/Units";
  static const String _httpServerLinkWithLessons = "$_httpServerLink/Lessons";
  static const String _httpServerLinkWithPosts = "$_httpServerLink/Posts";
  static const String _httpServerLinkWithSurveys = "$_httpServerLink/Surveys";

  static String getImageLink({required String imageUri}) =>
      "$_hostName$imageUri";

  // ################ START CATEGORIES ENDPOINTS LINK ################
  static String httpLinkGetAllCategories(
          {required int pageNumber,
          required int pageSize,
          required String keywordSearch}) =>
      '$_httpServerLinkWithCategories/GetAllCategoriesAsync?PageNumber=$pageNumber&PageSize=$pageSize${keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';

  static String httpLinkCreateCategory =
      '$_httpServerLinkWithCategories/CreateCategoryAsync';
  static String httpLinkUpdateCategory =
      '$_httpServerLinkWithCategories/UpdateCategoryAsync';

  static String httpLinkDeleteCategory({required int categoryId}) =>
      '$_httpServerLinkWithCategories/RemoveCategoryAsync?categoryId=$categoryId';

  // ################ END CATEGORIES ENDPOINTS LINK ################

  // ################ START COURSES ENDPOINTS LINK ################
  static String httpLinkGetAllCourses(
          {required int pageNumber,
          required int pageSize,
          required String keywordSearch}) =>
      '$_httpServerLinkWithCourses/GetAllCoursesAsync?PageNumber=$pageNumber&PageSize=$pageSize${keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';
  static String httpLinkCreateCourse =
      '$_httpServerLinkWithCourses/CreateCourseAsync';
  static String httpLinkUpdateCourse =
      '$_httpServerLinkWithCourses/UpdateCourseAsync';

  static String httpLinkDeleteCourse({required int courseId}) =>
      '$_httpServerLinkWithCourses/RemoveCourseAsync/$courseId';

  // ################ END COURSES ENDPOINTS LINK ################

  // ################ START UNITS ENDPOINTS LINK ################
  static String httpLinkCreateUnit =
      '$_httpServerLinkWithUnits/CreateUnitAsync';
  static String httpLinkUpdateUnit =
      '$_httpServerLinkWithUnits/UpdateUnitAsync';

  static String httpLinkDeleteUnit({required int unitId}) =>
      '$_httpServerLinkWithUnits/RemoveUnitAsync?unitId=$unitId';

  // ################ END UNITS ENDPOINTS LINK ################

  // ################ START LESSONS ENDPOINTS LINK ################
  static String httpLinkCreateLesson =
      '$_httpServerLinkWithLessons/CreateLessonAsync';
  static String httpLinkUpdateLesson =
      '$_httpServerLinkWithLessons/UpdateLessonAsync';

  static String httpLinkDeleteLesson({required int lessonId}) =>
      '$_httpServerLinkWithLessons/RemoveLessonAsync?id=$lessonId';

  // ################ END LESSONS ENDPOINTS LINK ################

  // ################ START POSTS ENDPOINTS LINK ################
  static String httpLinkGetAllPosts(
          {required int pageNumber,
          required int pageSize,
          required String keywordSearch}) =>
      '$_httpServerLinkWithPosts/GetAllPostsAsync?PageNumber=$pageNumber&PageSize=$pageSize${keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';
  static String httpLinkCreatePost =
      '$_httpServerLinkWithPosts/CreatePostAsync';
  static String httpLinkUpdatePost =
      '$_httpServerLinkWithPosts/UpdatePostAsync';

  static String httpLinkDeletePost({required int postId}) =>
      '$_httpServerLinkWithPosts/RemovePostAsync/$postId';

  // ################ END POSTS ENDPOINTS LINK ################

  // ################ START SURVEYS ENDPOINTS LINK ################
  static String httpLinkGetAllSurveys(
          {required int pageNumber,
          required int pageSize,
          required String keywordSearch}) =>
      '$_httpServerLinkWithSurveys/GetAllSurveysAsync?PageNumber=$pageNumber&PageSize=$pageSize${keywordSearch.trim().isEmpty ? '' : '&Search=$keywordSearch'}';

  static String httpLinkCreateSurvey =
      '$_httpServerLinkWithSurveys/CreateSurveyAsync';
  static String httpLinkUpdateSurvey =
      '$_httpServerLinkWithSurveys/UpdateSurveyAsync';

  static String httpLinkDeleteSurvey({required int surveyId}) =>
      '$_httpServerLinkWithSurveys/RemoveSurveyAsync/$surveyId';

  // ################ END SURVEYS ENDPOINTS LINK ################



  static Future<http.Response> getData(
      {required String url, required String accessToken}) async {
    var response = await http.get(
      Uri.parse(url),
      // headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  static Future<http.Response> postData(
      {required String url,
      required String accessToken,
      required Map<String, dynamic> data}) async {
    return await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
  }

  static Future<http.Response> putData(
      {required String url,
      required String accessToken,
      required Map<String, dynamic> data}) async {
    return await http.put(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
  }

  static Future<http.Response> deleteData({
    required String url,
    required String accessToken,
  }) async {
    return await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
  }

  static Future<http.Response> login(
      {required String url,
      required String email,
      required String password}) async {
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

  // static Future<http.Response> postRequestWithFile({required String url, required Map data, required File file, required String accessToken}) async {
  //   var request = http.MultipartRequest("POST",
  //       Uri.parse(url),
  //   );
  //   var length = await file.length();
  //   var stream = http.ByteStream(file.openRead());
  //   var multipartFile = http.MultipartFile(
  //     "imageFile", stream, length,
  //       filename: basename(file.path),
  //   );
  //   request.files.add(multipartFile);
  //   data.forEach((key, value) {
  //     request.fields[key] = value;
  //   });
  //   var myRequest = await request.send();
  //
  //   var response = await http.Response.fromStream(myRequest);
  //
  //   return response;
  // }

  static Future<http.Response> putRequestWithFile(
      {required String url,
      required Map data,
      required File file,
      required String accessToken}) async {
    var request = http.MultipartRequest("PUT", Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("imageFile", stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myRequest = await request.send();

    var response = await http.Response.fromStream(myRequest);

    return response;
  }

  static Future<http.Response> postAndPutForm({
    required String url,
    required Uint8List? fileBytes,
    required String accessToken,
    required String fileFieldName,
    required Map<String, dynamic> data,
    required bool isPost,
  }) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest(isPost ? 'POST' : 'PUT', uri);

    // التحقق من ملف الصورة وإضافته
    if (fileBytes != null) {
      if (fileBytes.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes(
          fileFieldName,
          fileBytes,
          filename: 'xsaupload.jpg',
        ));
      } else {
        throw Exception('Image file is null or empty');
      }
    }

    // إضافة الحقول الإضافية بعد التحقق
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      } else {
        throw Exception('Field $key is null');
      }
    });

    // التحقق من رمز الوصول وإضافته
    if (accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    request.headers['Content-Type'] = 'application/form';

    // إرسال الطلب
    var response = await http.Response.fromStream(await request.send());

    return response;
  }
}
