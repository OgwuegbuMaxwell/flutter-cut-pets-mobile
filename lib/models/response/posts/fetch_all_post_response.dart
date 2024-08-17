import '../../schema/post/post_schemas.dart';
import '../../response/posts/post_comment_response.dart';

class FetchAllPostResponse {
  final int id;
  final String imageUrl;
  final String imageUrlType;
  final String caption;
  final DateTime timestamp;
  final PostUser user;
  final List<PostCommentResponse> comments;

  FetchAllPostResponse({
    required this.id,
    required this.imageUrl,
    required this.imageUrlType,
    required this.caption,
    required this.timestamp,
    required this.user,
    required this.comments,
  });

  factory FetchAllPostResponse.fromJson(Map<String, dynamic> json) {
    return FetchAllPostResponse(
      id: json['id'],
      imageUrl: json['image_url'],
      imageUrlType: json['image_url_type'],
      caption: json['caption'],
      timestamp: DateTime.parse(json['timestamp']),
      user: PostUser.fromJson(json['user']),
      comments: (json['comments'] as List)
          .map((commentJson) => PostCommentResponse.fromJson(commentJson))
          .toList(),
    );
  }
}



// import '../../schema/post/post_schemas.dart';

// class FetchAllPostResponse {
//   final int id;
//   final String imageUrl;
//   final String imageUrlType;
//   final String caption;
//   final DateTime timestamp;
//   final PostUser user;
//   final List<PostComment> comments;

//   FetchAllPostResponse({
//     required this.id,
//     required this.imageUrl,
//     required this.imageUrlType,
//     required this.caption,
//     required this.timestamp,
//     required this.user,
//     required this.comments,
//   });

//   factory FetchAllPostResponse.fromJson(Map<String, dynamic> json) {
//     return FetchAllPostResponse(
//       id: json['id'],
//       imageUrl: json['image_url'],
//       imageUrlType: json['image_url_type'],
//       caption: json['caption'],
//       timestamp: DateTime.parse(json['timestamp']),
//       user: PostUser.fromJson(json['user']),
//       comments: (json['comments'] as List)
//           .map((commentJson) => PostComment.fromJson(commentJson))
//           .toList(),
//     );
//   }
// }
