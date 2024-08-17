

import '../../schema/post/post_schemas.dart';

class CreatePostResponse {
  final int id;
  final String imageUrl;
  final String imageUrlType;
  final String caption;
  final DateTime timestamp;
  final PostUser user;
  final List<PostComment> comments;

  CreatePostResponse({
    required this.id,
    required this.imageUrl,
    required this.imageUrlType,
    required this.caption,
    required this.timestamp,
    required this.user,
    required this.comments,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      id: json['id'],
      imageUrl: json['image_url'],
      imageUrlType: json['image_url_type'],
      caption: json['caption'],
      timestamp: DateTime.parse(json['timestamp']),
      user: PostUser.fromJson(json['user']),
      comments: (json['comments'] as List)
          .map((commentJson) => PostComment.fromJson(commentJson))
          .toList(),
    );
  }
}






// import 'dart:convert';

// class AllPost {
//   final int id;
//   final String imageUrl;
//   final String imageUrlType;
//   final String caption;
//   final DateTime timestamp;
//   final User user;
//   final List<Comment> comments;

//   AllPost({
//     required this.id,
//     required this.imageUrl,
//     required this.imageUrlType,
//     required this.caption,
//     required this.timestamp,
//     required this.user,
//     required this.comments,
//   });

//   factory AllPost.fromJson(Map<String, dynamic> json) {
//     return AllPost(
//       id: json['id'],
//       imageUrl: json['image_url'],
//       imageUrlType: json['image_url_type'],
//       caption: json['caption'],
//       timestamp: DateTime.parse(json['timestamp']),
//       user: User.fromJson(json['user']),
//       comments: (json['comments'] as List<dynamic>)
//           .map((comment) => Comment.fromJson(comment))
//           .toList(),
//     );
//   }
// }

// class User {
//   final String username;

//   User({required this.username});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       username: json['username'],
//     );
//   }
// }

// class Comment {
//   final String text;
//   final String username;
//   final DateTime timestamp;

//   Comment({
//     required this.text,
//     required this.username,
//     required this.timestamp,
//   });

//   factory Comment.fromJson(Map<String, dynamic> json) {
//     return Comment(
//       text: json['text'],
//       username: json['username'],
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }
// }

// List<AllPost> allPostFromJson(String str) =>
//     List<AllPost>.from(json.decode(str).map((x) => AllPost.fromJson(x)));
