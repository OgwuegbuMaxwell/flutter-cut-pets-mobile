import '../../response/image_upload/image_upload.dart';

class ImageUploadResult {
  final ImageUploadResponse? response;
  final int statusCode;
  final String? error;

  ImageUploadResult({this.response, required this.statusCode, this.error});

  factory ImageUploadResult.success(ImageUploadResponse response, int statusCode) {
    return ImageUploadResult(
      response: response,
      statusCode: statusCode,
    );
  }

  factory ImageUploadResult.failure(int statusCode, String error) {
    return ImageUploadResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
