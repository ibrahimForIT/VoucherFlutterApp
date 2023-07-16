import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundTheme extends ConsumerWidget {
  final Widget child;
  const BackgroundTheme({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.4, 0.4, 0.9, 0.8],
          colors: [
            Color.fromARGB(255, 239, 232, 224),
            Color.fromARGB(255, 187, 175, 165),
            Color.fromARGB(255, 239, 232, 224),
            Color.fromARGB(255, 187, 175, 165),
          ],
        ),
      ),
      child: child,
    );
  }
}
