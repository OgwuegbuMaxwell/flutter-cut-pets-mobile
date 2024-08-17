class PostCommentRequest {
  final String username;
  final String text;
  final int postId;

  PostCommentRequest({
    required this.username,
    required this.text,
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'post_id': postId,
    };
  }
}
