class SignUpResponse {
  final String username;
  final String email;

  SignUpResponse({
    required this.username,
    required this.email,
  });

  // Factory method to create an instance from JSON
  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      username: json['username'],
      email: json['email'],
    );
  }
}
