import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/radio_Provider.dart';

class RadioWidget extends ConsumerWidget {
  final String titleRadio;
  final int valueInput;
  final VoidCallback? onChangeValue;

  const RadioWidget({
    super.key,
    required this.titleRadio,
    required this.valueInput,
    required this.onChangeValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radio = ref.watch(radioProvider);
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      title: Transform.translate(
        offset: const Offset(-22, 0),
        child: Text(titleRadio),
      ),
      value: valueInput,
      groupValue: radio,
      onChanged: (value) => onChangeValue!(),
    );
  }
}
