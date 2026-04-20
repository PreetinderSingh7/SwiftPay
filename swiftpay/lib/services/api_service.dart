// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ApiService {
//   // ⚠️ Replace with your actual backend URL
//   // For local testing: use your PC's IP address (e.g., http://192.168.1.5:5000)
//   // For production: use your deployed URL (Render, Railway, etc.)
//   static const String baseUrl = 'http://192.168.1.5:5000/api';
  
//   static const storage = FlutterSecureStorage();

//   static Future<String?> getToken() async {
//     return await storage.read(key: 'jwt_token');
//   }

//   static Future<void> saveToken(String token) async {
//     await storage.write(key: 'jwt_token', value: token);
//   }

//   static Future<void> deleteToken() async {
//     await storage.delete(key: 'jwt_token');
//   }

//   static Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   // Auth
//   static Future<Map<String, dynamic>> register(
//       String name, String email, String phone, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/auth/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'password': password
//       }),
//     );
//     return jsonDecode(response.body);
//   }

//   static Future<Map<String, dynamic>> login(
//       String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/auth/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//     return jsonDecode(response.body);
//   }

//   // Products
//   static Future<Map<String, dynamic>> getProductByBarcode(
//       String barcode) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/products/barcode/$barcode'),
//       headers: await _headers(),
//     );
//     return jsonDecode(response.body);
//   }

//   // Payments
//   static Future<Map<String, dynamic>> createOrder(
//       List<Map<String, dynamic>> items) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/payments/create-order'),
//       headers: await _headers(),
//       body: jsonEncode({'items': items}),
//     );
//     return jsonDecode(response.body);
//   }

//   static Future<Map<String, dynamic>> verifyPayment(
//       String orderId,
//       String paymentId,
//       String signature,
//       String transactionId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/payments/verify'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'razorpayOrderId': orderId,
//         'razorpayPaymentId': paymentId,
//         'razorpaySignature': signature,
//         'transactionId': transactionId,
//       }),
//     );
//     return jsonDecode(response.body);
//   }

//   // Transactions
//   static Future<Map<String, dynamic>> getMyTransactions() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/transactions/my'),
//       headers: await _headers(),
//     );
//     return jsonDecode(response.body);
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // ⚠️ Replace with your actual backend URL
  // static const String baseUrl = 'http://172.17.40.14:5000/api';
  static const String baseUrl = 'https://swift-pay-phi.vercel.app/api';


  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'jwt_token');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth
  static Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password
        }),
      ).timeout(const Duration(seconds: 10));

      print("Register API response: ${response.statusCode} ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Register API error: $e");
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      print("Login API response: ${response.statusCode} ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Login API error: $e");
      return {'success': false, 'error': e.toString()};
    }
  }

  // Products
  static Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/barcode/$barcode'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 10));

    print("Product API response: ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

  // Payments
  static Future<Map<String, dynamic>> createOrder(
      List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/create-order'),
      headers: await _headers(),
      body: jsonEncode({'items': items}),
    ).timeout(const Duration(seconds: 10));

    print("CreateOrder API response: ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyPayment(
      String orderId, String paymentId, String signature, String transactionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/verify'),
      headers: await _headers(),
      body: jsonEncode({
        'razorpayOrderId': orderId,
        'razorpayPaymentId': paymentId,
        'razorpaySignature': signature,
        'transactionId': transactionId,
      }),
    ).timeout(const Duration(seconds: 10));

    print("VerifyPayment API response: ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

  // Transactions
  static Future<Map<String, dynamic>> getMyTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/my'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 10));

    print("Transactions API response: ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }
}
