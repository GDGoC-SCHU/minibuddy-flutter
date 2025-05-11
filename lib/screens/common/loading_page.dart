import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NetworkErrorScreen'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
