class ImageUploadResponse {
  final String filename;

  ImageUploadResponse({required this.filename});

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      filename: json['filename'],
    );
  }
}
