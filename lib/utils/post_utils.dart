import '../../../../models/response/posts/fetch_all_post_response.dart';

class PostUtils {
  static List<FetchAllPostResponse> sortPostsByLatest(List<FetchAllPostResponse> posts) {
    // Sorting posts by timestamp in descending order (latest first)
    posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return posts;
  }
}
