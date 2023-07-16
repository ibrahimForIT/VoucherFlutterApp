import 'package:flutter/material.dart';

import '../utils/labels.dart';

class ChequeScreen extends StatelessWidget {
  static const String screenRoute = Labels.chequeScreenRoute;
  const ChequeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cheque Page'),
      ),
    );
  }
}
