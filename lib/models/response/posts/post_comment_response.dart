class PostCommentResponse {
  final int id;
  final String timestamp;
  final String text;
  final String username;
  final int postId;

  PostCommentResponse({
    required this.id,
    required this.timestamp,
    required this.text,
    required this.username,
    required this.postId,
  });

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) {
    return PostCommentResponse(
      id: json['id'],
      timestamp: json['timestamp'],
      text: json['text'],
      username: json['username'],
      postId: json['post_id'],
    );
  }
}
