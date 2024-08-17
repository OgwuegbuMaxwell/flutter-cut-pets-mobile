import '../../response/posts/delete_post_response.dart';

class DeletePostResult {
  final DeletePostResponse? response;
  final int statusCode;
  final String? error;

  DeletePostResult({this.response, required this.statusCode, this.error});

  factory DeletePostResult.success(DeletePostResponse response, int statusCode) {
    return DeletePostResult(
      response: response,
      statusCode: statusCode,
    );
  }

  factory DeletePostResult.failure(int statusCode, String error) {
    return DeletePostResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
