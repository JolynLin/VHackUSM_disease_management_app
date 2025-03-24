import 'package:flutter/material.dart';

class DiscussionForumScreen extends StatelessWidget {
  const DiscussionForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Forum")),
      body: const Center(child: Text("Discussion posts will appear here.")),
    );
  }
}
