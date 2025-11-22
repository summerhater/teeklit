class Comments {
  final String commentId;
  final String userId;
  final String commentContents;
  final DateTime createAt;
  final String? parentId;
  final List<String>? commentLike;

  Comments({
    required this.commentId,
    required this.userId,
    required  this.commentContents,
    required this.createAt,
    this.parentId,
    this.commentLike,
  });
}
