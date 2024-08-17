class DeletePostRequest {
  final int id;

  DeletePostRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
