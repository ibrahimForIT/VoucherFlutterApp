import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/providers/auth_view_model_provider.dart';
import 'package:fyhaa/utils/constants/routes.dart';
import 'package:fyhaa/views/screens/cheque_view.dart';
import 'package:fyhaa/views/screens/dashboard_view.dart';
import 'package:fyhaa/views/screens/info_view.dart';
import 'package:fyhaa/views/screens/voucher_view.dart';
import 'package:fyhaa/views/screens/sing_in_view.dart';
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
        dashboardViewRoute: (context) => const Dashboard(),
        rvoucherViewRoute: (context) => const Voucher(),
        pvoucherViewRoute: (context) => const Voucher(),
        chequeViewRoute: (context) => const ChequeView(),
        infoViewRoute: (context) => const InfoView(),
      },
    );
  }
}
