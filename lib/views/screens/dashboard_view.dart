import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_view_model_provider.dart';
import '../../widgets/background_theme_widget.dart';
import '../../utils/constants/constant.dart';
import '../../providers/service_voucher_provider.dart';
import '../../utils/labels.dart';
import '../../widgets/show_drawer.dart';
import '../../utils/constants/routes.dart';
import 'dart:developer' as devtools show log;

class Dashboard extends ConsumerWidget {
  static const String screenRoute = dashboardViewRoute;
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    devtools.log(FirebaseAuth.instance.currentUser!.toString());
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      drawer: showDrawer(context, ref),
      appBar: AppBar(
          shadowColor: shadowColor,
          backgroundColor: ksecondaryColor,
          title: const Text(
            Labels.appBarTitle,
          ),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () async {
                await ref.read(authViewModelProvider).signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/');
              },
            )
          ]),

      body: BackgroundTheme(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 175,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage('images/logoI.png'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 150,
                  child: Card(
                    color: const Color(0xFFECEEF3),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius value as needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                splashColor: Theme.of(context).primaryColor,
                                child: Image.asset('images/r.jpg'),
                                onTap: () {
                                  // getNo('Rvoucher');
                                  ref
                                      .read(collectionNameProvider.notifier)
                                      .state = Labels.rVoucher;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      rvoucherViewRoute, (_) => true);
                                }),
                            InkWell(
                                child: Image.asset('images/p.jpg'),
                                onTap: () {
                                  ref
                                      .read(collectionNameProvider.notifier)
                                      .state = Labels.pVoucher;

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      pvoucherViewRoute, (_) => true);
                                }),
                            InkWell(
                              child: Image.asset('images/c.jpg'),
                              onTap: () {
                                ref
                                    .read(collectionNameProvider.notifier)
                                    .state = Labels.cheque;

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    chequeViewRoute, (_) => true);
                              },
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
