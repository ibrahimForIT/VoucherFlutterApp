import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/screens/cheque_screen.dart';
import '../providers/auth_view_model_provider.dart';
import '../screens/main_voucher.dart';
import '../widgets/background_theme_widget.dart';
import '../utils/constants/constant.dart';
import '../providers/service_voucher_provider.dart';
import '../utils/labels.dart';
import '../widgets/show_drawer.dart';

class Dashboard extends ConsumerWidget {
  static const String screenRoute = Labels.dashboardScreenRoute;
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // backgroundColor: kPrimaryColor,
      drawer: Show_Drawer(context),
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
                                  ref.read(collectionNameProvider.state).state =
                                      Labels.rVoucher;
                                  Navigator.pushNamed(
                                    context,
                                    MainVoucher.screenRoute,
                                  );
                                }),
                            InkWell(
                                child: Image.asset('images/p.jpg'),
                                onTap: () {
                                  ref.read(collectionNameProvider.state).state =
                                      Labels.pVoucher;

                                  Navigator.pushNamed(
                                    context,
                                    MainVoucher.screenRoute,
                                  );
                                }),
                            InkWell(
                              child: Image.asset('images/c.jpg'),
                              onTap: () {
                                ref.read(collectionNameProvider.state).state =
                                    Labels.cheque;
                                Navigator.pushNamed(
                                  context,
                                  ChequeScreen.screenRoute,
                                );
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
