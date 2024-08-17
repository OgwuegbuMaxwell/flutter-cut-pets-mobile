import 'dart:convert';
import 'package:http/http.dart' as https;
import '../config.dart';
import '../../models/request/signUp/signup_request.dart';
import '../../models/response/signUp/signup_response.dart';

class SignUpResult {
  final SignUpResponse? response;
  final int statusCode;
  final String? error;

  SignUpResult({this.response, required this.statusCode, this.error});
}

class SignUpHelper {
  static Future<SignUpResult> signUp(SignUpRequest request) async {
    var url = Uri.parse('${Config.apiUrl}/user'); // Adjust the endpoint as needed

    // Convert the request object to JSON
    var body = request.toJson();

    // Send the request
    var response = await https.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Handle the response
    if (response.statusCode == 201 || response.statusCode == 200) {
      // Parse the response body into SignUpResponse
      return SignUpResult(
        response: SignUpResponse.fromJson(jsonDecode(response.body)),
        statusCode: response.statusCode,
      );
    } else {
      print('Sign up failed: ${response.statusCode}');
      print('Error: ${response.body}');
      return SignUpResult(
        statusCode: response.statusCode,
        error: response.body,
      );
    }
  }
}
