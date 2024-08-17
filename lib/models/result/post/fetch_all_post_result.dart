import '../../response/posts/fetch_all_post_response.dart';

class FetchAllPostResult {
  final List<FetchAllPostResponse>? listResponse;
  final int statusCode;
  final String? error;

  FetchAllPostResult({this.listResponse, required this.statusCode, this.error});

  factory FetchAllPostResult.success(List<FetchAllPostResponse> listResponse, int statusCode) {
    return FetchAllPostResult(
      listResponse: listResponse,
      statusCode: statusCode,
    );
  }

  factory FetchAllPostResult.failure(int statusCode, String error) {
    return FetchAllPostResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
