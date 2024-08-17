import '../../response/posts/fetch_one_post_response.dart';


class FetchOnePostResult {
  final FetchOnePostResponse? response;
  final int statusCode;
  final String? error;

  FetchOnePostResult({this.response, required this.statusCode, this.error});

  factory FetchOnePostResult.success(FetchOnePostResponse response, int statusCode) {
    return FetchOnePostResult(
      response: response,
      statusCode: statusCode,
    );
  }

  factory FetchOnePostResult.failure(int statusCode, String error) {
    return FetchOnePostResult(
      statusCode: statusCode,
      error: error,
    );
  }
}
