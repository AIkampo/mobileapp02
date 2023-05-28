import 'package:flutter/material.dart';

class UserGuideScreen extends StatefulWidget {
  const UserGuideScreen({super.key});

  @override
  State<UserGuideScreen> createState() => _UserGuideScreenState();
}

class _UserGuideScreenState extends State<UserGuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("使用教學"),
        centerTitle: true,
      ),
    );
  }
}
