class DeletePostResponse {
  final String message;

  DeletePostResponse({required this.message});

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) {
    return DeletePostResponse(
      message: json['message'],
    );
  }

  factory DeletePostResponse.fromString(String response) {
    return DeletePostResponse(
      message: response,
    );
  }
}
