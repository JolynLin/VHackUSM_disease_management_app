import 'package:intl/intl.dart';

class ForumPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<Comment> comments;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.likedBy = const [],
    this.comments = const [],
  });

  String get formattedDate => DateFormat('MMM d, y • h:mm a').format(createdAt);
  int get likeCount => likedBy.length;
  int get commentCount => comments.length;
}

class Comment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  String get formattedDate => DateFormat('MMM d, y • h:mm a').format(createdAt);
} 