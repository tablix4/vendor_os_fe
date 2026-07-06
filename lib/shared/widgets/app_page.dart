import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget child;

  const AppPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }
}
