import '../../response/posts/post_comment_response.dart';

class PostCommentResult {
  final PostCommentResponse? response;
  final int statusCode;
  final String? error;

  PostCommentResult({this.response, required this.statusCode, this.error});

  factory PostCommentResult.success(PostCommentResponse response, int statusCode) {
    return PostCommentResult(
      response: response,
      statusCode: statusCode,
    );
  }

  factory PostCommentResult.failure(int statusCode, String error) {
    return PostCommentResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
