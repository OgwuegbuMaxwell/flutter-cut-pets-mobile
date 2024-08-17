import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:provider/provider.dart';
import '../../models/response/login/login_response.dart';
import '../../models/request/login/login_request.dart'; // Import LoginRequest
import '../config.dart';
import '../../providers/user_provider.dart'; // Import UserProvider

class LoginResult {
  final LoginResponse? response;
  final int statusCode;
  final String? error;

  LoginResult({this.response, required this.statusCode, this.error});
}

class LoginHelper {
  static Future<LoginResult> login(LoginRequest loginRequest, context) async {
    var url = Uri.parse('${Config.apiUrl}/auth/login');

    // Creating a MultipartRequest to send the form data
    var request = https.MultipartRequest('POST', url);
    request.fields['username'] = loginRequest.username;
    request.fields['password'] = loginRequest.password;

    // Send the request
    var response = await request.send();

    // Read the response body
    final responseBody = await response.stream.bytesToString();

    // Handle the response
    if (response.statusCode == 200) {
      var data = jsonDecode(responseBody);
      print(data);

      // Use UserProvider to save user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.saveUserData(
        data['access_token'],
        data['token_type'],
        data['user_id'],
        data['username'],
      );

      return LoginResult(
        response: LoginResponse.fromJson(data),
        statusCode: response.statusCode,
      );
    } else {
      print('Login failed: ${response.statusCode}');
      return LoginResult(
        statusCode: response.statusCode,
        error: 'Login failed: $responseBody', // Include the actual response body here
      );
    }
  }
}
