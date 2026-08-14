import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:medica_app/core/helpers/constants.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';

class ApiService {
  // دالة مساعدة مركزية لجلب الهيدرز لعدم تكرار الكود وضمان ثبات التوكن
  Future<Map<String, String>> _getHeaders(String? customToken) async {
    final token = customToken ?? await SharedPrefHelper.getUserToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer ${token.trim()}',
    };
  }

  // دالة عامة لإرسال البيانات (محمية الآن بالكامل)
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      print("Final Data sent to server: ${jsonEncode(body)}");
      final headers = await _getHeaders(token);

      final response = await http.post(
        Uri.parse("$baseUrl/$endpoint"),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('errors.no_internet'.tr());
    } on http.ClientException {
      throw Exception("errors.connection_error".tr());
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }

  // دالة عامة لجلب البيانات
  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final headers = await _getHeaders(token);

      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: headers,
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('errors.no_internet'.tr());
    } on http.ClientException {
      throw Exception("errors.connection_error".tr());
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }

  // دالة PUT لتحديث البيانات
  Future<dynamic> put(String endpoint, {Object? body, String? token}) async {
    try {
      final headers = await _getHeaders(token);

      final response = await http.put(
        Uri.parse("$baseUrl/$endpoint"),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('errors.no_internet'.tr());
    } on http.ClientException {
      throw Exception("errors.connection_error".tr());
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }

  // دالة DELETE لحذف البيانات
  Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final headers = await _getHeaders(token);
      final response = await http.delete(
        Uri.parse("$baseUrl/$endpoint"),
        headers: headers,
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('errors.no_internet'.tr());
    } on http.ClientException {
      throw Exception("errors.connection_error".tr());
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }

  // دالة خاصة لرفع الصور والبيانات المتعددة
  Future<dynamic> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    File? File,
    required String fileKey,
    String? token,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/$endpoint");
      var request = http.MultipartRequest('POST', uri);

      // جلب الهيدرز الموحدة وتعديلها لتناسب الميكسد داتا
      final headers = await _getHeaders(token);
      request.headers.addAll({
        'Accept': 'application/json',
        if (headers.containsKey('Authorization'))
          'Authorization': headers['Authorization']!,
      });

      request.fields.addAll(fields);

      if (File != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileKey, File.path),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('errors.no_internet'.tr());
    } on http.ClientException {
      throw Exception("errors.connection_error".tr());
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }

  // معالجة الردود بشكل آمن يمنع الانهيار تماماً
  dynamic _handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      // إذا فشل فك التشفير (السيرفر أرجع HTML أو نص عادي بسبب عطل ما)
      throw Exception(
        "خطأ في بنية البيانات المستلمة من السيرفر (Status: ${response.statusCode})",
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      SharedPrefHelper.setData('user_token', null);
      throw Exception("errors.session_expired".tr());
    } else {
      // إرجاع رسالة السيرفر أو رسالة افتراضية
      final errorMessage = body is Map
          ? (body['message'] ?? "Something went wrong")
          : "Something went wrong";
      throw Exception(errorMessage);
    }
  }
}
