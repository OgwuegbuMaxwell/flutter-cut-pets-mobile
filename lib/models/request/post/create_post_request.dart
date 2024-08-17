class CreatePostRequest {
  final String imageUrl;
  final String imageUrlType;
  final String caption;
  final String creatorId;

  CreatePostRequest({
    required this.imageUrl,
    required this.imageUrlType,
    required this.caption,
    required this.creatorId,
  });

  // Convert the PostRequest instance to a Map to send as JSON in the API request
  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'image_url_type': imageUrlType,
      'caption': caption,
      'creator_id': creatorId,
    };
  }
}
