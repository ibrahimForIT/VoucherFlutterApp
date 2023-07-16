import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/providers/auth_view_model_provider.dart';
import 'package:fyhaa/screens/cheque_screen.dart';

import 'package:fyhaa/screens/dashboard.dart';
import 'package:fyhaa/screens/main_voucher.dart';
import 'package:fyhaa/screens/sing_in.dart';

import '../utils/constants/constant.dart';
import 'firebase_options.dart';
import 'utils/labels.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authViewModelProvider);
    return MaterialApp(
      //add thame to change foat button color
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown[400],
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ksecondaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: Labels.appName,
      initialRoute: '/',
      routes: {
        '/': (context) => auth.user != null ? const Dashboard() : SingIn(),
        Dashboard.screenRoute: (context) => const Dashboard(),
        MainVoucher.screenRoute: (context) => const MainVoucher(),
        ChequeScreen.screenRoute: (context) => const ChequeScreen(),
      },
    );
  }
}
