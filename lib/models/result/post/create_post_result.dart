
import '../../response/posts/create_post_response.dart';

class CreatePostResult {
  final CreatePostResponse? singleResponse;
  final List<CreatePostResponse>? listResponse; // Added to handle lists of posts
  final int statusCode;
  final String? error;

  CreatePostResult({this.singleResponse, this.listResponse, required this.statusCode, this.error});

  factory CreatePostResult.successSingle(CreatePostResponse response, int statusCode) {
    return CreatePostResult(
      singleResponse: response,
      statusCode: statusCode,
    );
  }

  factory CreatePostResult.successList(List<CreatePostResponse> response, int statusCode) {
    return CreatePostResult(
      listResponse: response,
      statusCode: statusCode,
    );
  }

  factory CreatePostResult.failure(int statusCode, String error) {
    return CreatePostResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
