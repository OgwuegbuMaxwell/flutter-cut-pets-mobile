import '../../schema/post/post_schemas.dart';

class FetchOnePostResponse {
  final int id;
  final String imageUrl;
  final String imageUrlType;
  final String caption;
  final DateTime timestamp;
  final PostUser user;
  final List<PostComment> comments;

  FetchOnePostResponse({
    required this.id,
    required this.imageUrl,
    required this.imageUrlType,
    required this.caption,
    required this.timestamp,
    required this.user,
    required this.comments,
  });

  factory FetchOnePostResponse.fromJson(Map<String, dynamic> json) {
    return FetchOnePostResponse(
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
