import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterWidget extends ConsumerWidget {
  final VoidCallback callbackAction;
  final String title;
  final IconData icon;
  final Color color;

  const FilterWidget({
    super.key,
    required this.callbackAction,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        minimumSize: title.length > 10
            ? Size(100, 36)
            : title.length > 5
                ? Size(80, 36)
                : Size(60, 36),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: callbackAction,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
