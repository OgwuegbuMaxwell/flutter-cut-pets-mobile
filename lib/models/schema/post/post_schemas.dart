class PostComment {
  final String text;
  final String username;
  final DateTime timestamp;

  PostComment({
    required this.text,
    required this.username,
    required this.timestamp,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      text: json['text'],
      username: json['username'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class PostUser {
  final String username;

  PostUser({required this.username});

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      username: json['username'],
    );
  }
}