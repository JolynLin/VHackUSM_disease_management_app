import 'package:flutter/foundation.dart';
import 'forum_models.dart';

class ForumProvider with ChangeNotifier {
  List<ForumPost> _posts = [];
  String _currentUserId = 'user1'; // In a real app, this would come from authentication
  String _currentUserName = 'John Doe'; // In a real app, this would come from authentication

  List<ForumPost> get posts => _posts;
  String get currentUserId => _currentUserId;
  String get currentUserName => _currentUserName;

  void addPost(String title, String content) {
    final newPost = ForumPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      authorId: _currentUserId,
      authorName: _currentUserName,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  void addComment(String postId, String content) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        authorId: _currentUserId,
        authorName: _currentUserName,
        createdAt: DateTime.now(),
      );
      _posts[postIndex] = ForumPost(
        id: post.id,
        title: post.title,
        content: post.content,
        authorId: post.authorId,
        authorName: post.authorName,
        createdAt: post.createdAt,
        likedBy: post.likedBy,
        comments: [...post.comments, newComment],
      );
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final isLiked = post.likedBy.contains(_currentUserId);
      final updatedLikedBy = isLiked
          ? post.likedBy.where((id) => id != _currentUserId).toList()
          : [...post.likedBy, _currentUserId];
      
      _posts[postIndex] = ForumPost(
        id: post.id,
        title: post.title,
        content: post.content,
        authorId: post.authorId,
        authorName: post.authorName,
        createdAt: post.createdAt,
        likedBy: updatedLikedBy,
        comments: post.comments,
      );
      notifyListeners();
    }
  }
} 