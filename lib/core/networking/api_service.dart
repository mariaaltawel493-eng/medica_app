// lib/core/network/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:medica_app/core/helpers/constants.dart';
import 'package:medica_app/core/helpers/shared_pref_helper.dart';

class ApiService {
  // دالة عامة لإرسال البيانات (مثل التسجيل والدخول)
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    String? token = await SharedPrefHelper.getUserToken();
    print("Final Data sent to server:${jsonEncode(body)}");
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // دالة عامة لجلب البيانات (بيستخدمها الكل في شاشات العرض)
  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      String? token = await SharedPrefHelper.getUserToken();
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('لايوجد اتصال بالإنترنت،يرجى التأكد من الشبكة');
    } on http.ClientException {
      throw Exception("خطأ في الأتصال في السيرفر");
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع:${e.toString()}");
    }
  }

  ////دالة PUT التي سنحتاجها  لتحديث البروفايل
  Future<dynamic> put(String endpoint, {Object? body, String? token}) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('لايوجد اتصال بالإنترنت،يرجى التأكد من الشبكة');
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع:${e.toString()}");
    }
  }

  // دالة خاصة لرفع الصور والبيانات (بيستخدمها الـ Register وأي مكان فيه رفع ملفات)
  Future<dynamic> postMultipart({
    required String endpoint,
    required Map<String, String> fields, // البيانات النصية
    File? imageFile, // ملف الصورة
  }) async {
    try {
      String? token = await SharedPrefHelper.getUserToken();
      final uri = Uri.parse("$baseUrl/$endpoint");
      // 1. تجهيز الطلب من نوع Multipart
      var request = http.MultipartRequest('POST', uri);
      // 2. إضافة الهيدرز (Headers)
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      // 3. إضافة الحقول النصية (الاسم، الهاتف، إلخ)
      request.fields.addAll(fields);
      // 4. إضافة الصورة إذا كانت موجودة
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile', imageFile.path),
        );
      }

      // 5. إرسال الطلب
      final streamedResponse = await request.send();

      // 6. تحويل الرد من Stream لـ Response عادي مشان نقدر نعالجه بدالتك _handleResponse
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت، يرجى التأكد من الشبكة');
    } catch (e) {
      throw Exception("حدث خطأ أثناء رفع البيانات: ${e.toString()}");
    }
  }

  // معالجة الأخطاء في مكان واحد لكل الفريق
  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      // نرمي رسالة الخطأ القادمة من الباك أند ليعرضها الـ Bloc في الـ UI
      throw body['message'] ?? "Something went wrong";
    }
  }
}
