class Post {
  final int? userId;
  final int? id;
  final String title;
  final String body;

  const Post({
    this.userId,
    this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        title: json['title'],
        body: json['body'],
        userId: json['userId'],
        id: json['id']);
  }
}
