import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text("fetching latest info... 🚀",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    decoration: TextDecoration.none,
                  )),
              SizedBox(height: 5),
              Text("Please wait a moment",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
