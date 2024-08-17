import 'package:flutter/material.dart';
import '../../../../models/response/posts/fetch_all_post_response.dart';
import '../../../../services/helpers/post_helper.dart';
import '../../../../models/result/post/fetch_all_post_result.dart';
import '../models/response/posts/post_comment_response.dart';

class PostProvider with ChangeNotifier {
  List<FetchAllPostResponse> _posts = [];
  final ScrollController scrollController = ScrollController();

  List<FetchAllPostResponse> get posts => _posts;

  Future<void> fetchPosts() async {
    FetchAllPostResult result = await PostHelper.getAllPosts();
    if (result.listResponse != null) {
      _posts = result.listResponse!;
      notifyListeners();
    }
  }

  void addCommentToPost(int postId, PostCommentResponse comment) {
    // Find the post by postId
    var post = _posts.firstWhere((post) => post.id == postId);
    // Add the new comment
    post.comments.add(comment);
    print("addCommentToPost called ----------------------------");
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
    scrollToTop();
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}



// import 'package:flutter/material.dart';
// import '../../../../models/response/posts/fetch_all_post_response.dart';
// import '../../../../services/helpers/post_helper.dart';
// import '../../../../models/result/post/fetch_all_post_result.dart';
// import '../models/response/posts/post_comment_response.dart';

// class PostProvider with ChangeNotifier {
//   List<FetchAllPostResponse> _posts = [];
//   final ScrollController scrollController = ScrollController();

//   List<FetchAllPostResponse> get posts => _posts;

//   Future<void> fetchPosts() async {
//     FetchAllPostResult result = await PostHelper.getAllPosts();
//     if (result.listResponse != null) {
//       _posts = result.listResponse!;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshPosts() async {
//     await fetchPosts();
//     // print("refreshPosts called................. ");
//     scrollToTop();
//   }

//   void scrollToTop() {
//     scrollController.animateTo(
//       0.0,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }


//   void addCommentToPost(int postId, PostCommentResponse comment) {
//     // Find the post by postId
//     var post = _posts.firstWhere((post) => post.id == postId);
//     // Add the new comment
//     post.comments.add(comment);
//     // Notify listeners to rebuild the UI
//     print("addCommentToPost called ----------------------------");
//     notifyListeners();
//   }


// }

