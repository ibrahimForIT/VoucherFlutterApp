import 'package:flutter/material.dart';
import '../../utils/constants/routes.dart';

void test(List<String>? names) {
  names?.add('John');
}

class ChequeView extends StatelessWidget {
  static const String screenRoute = chequeViewRoute;
  const ChequeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheque Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Cheque Screen'),
          ],
        ),
      ),
    );
  }
}
