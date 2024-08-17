class SignUpRequest {
  final String username;
  final String email;
  final String password;

  SignUpRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  // Convert the SignUpRequest instance to a Map to send as JSON in the API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
