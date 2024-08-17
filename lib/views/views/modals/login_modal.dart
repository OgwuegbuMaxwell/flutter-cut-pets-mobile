import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_constants.dart';
import '../../../models/request/login/login_request.dart';
import '../../../services/helpers/login_helper.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key}); 


  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Create an instance of LoginRequest with the provided username and password
    LoginRequest loginRequest = LoginRequest(username: username, password: password);

    // Pass the LoginRequest object to LoginHelper's login method
    LoginResult loginResult = await LoginHelper.login(loginRequest, context);

    if (!mounted) return; // Ensure the widget is still mounted before proceeding

    if (loginResult.statusCode == 200) {
      // Handle successful login
      print('Login successful: ${loginResult.response?.accessToken}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
    } else {
      // Handle login failure
      print('Login failed with status code: ${loginResult.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed!")),
      );
    }

    // Close the modal
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: kDarkBlue)),
        ),
        ElevatedButton(
          onPressed: _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: kNewBlue,
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }
}
