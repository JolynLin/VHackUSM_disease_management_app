import 'package:flutter/material.dart';

class ProfilePhotoPlaceholder extends StatelessWidget {
  const ProfilePhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey[300],
      child: const Icon(Icons.person, size: 40, color: Colors.black),
    );
  }
}
