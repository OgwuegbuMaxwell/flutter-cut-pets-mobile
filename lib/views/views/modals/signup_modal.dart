import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_constants.dart';
import '../../../models/request/login/login_request.dart';
import '../../../models/request/signUp/signup_request.dart';
import '../../../services/helpers/login_helper.dart';
import '../../../services/helpers/signUp_helper.dart';


class SignUpModal extends StatefulWidget {
  const SignUpModal({super.key}); 

  @override
  State<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

void _handleSignUp() async {
  final email = _emailController.text;
  final username = _usernameController.text;
  final password = _passwordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (password != confirmPassword) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
    }
    return;
  }

  SignUpRequest signUpRequest = SignUpRequest(
    username: username,
    email: email,
    password: password,
  );

  SignUpResult signUpResult = await SignUpHelper.signUp(signUpRequest);

  if (signUpResult.statusCode == 201 || signUpResult.statusCode == 200) {
    // Sign up was successful, proceed to login
    LoginRequest loginRequest = LoginRequest(username: username, password: password);
    LoginResult loginResult = await LoginHelper.login(loginRequest, context);

    if (mounted) {
      if (loginResult.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-up and login successful!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-up successful, but login failed!")),
        );
      }
    }
  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign-up failed")),
      );
    }
  }

  if (mounted) {
    Navigator.of(context).pop();
  }
}





  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign Up'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.h),
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
            SizedBox(height: 10.h),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
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
          child: const Text('Cancel', style: TextStyle(color: kDarkBlue)),
        ),
        ElevatedButton(
          onPressed: _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: kNewBlue, // Updated parameter
          ),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
