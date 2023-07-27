import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/utils/constants/routes.dart';
import 'package:fyhaa/utils/labels.dart';
import 'package:gap/gap.dart';
import '../utils/constants/constant.dart';

Drawer showDrawer(BuildContext context, WidgetRef ref) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          curve: Curves.easeOutQuad,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage('images/logoI.png'),
              fit: BoxFit.fitHeight,
            ),
            color: ksecondaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon for user
              const CircleAvatar(
                //baclground color of the circle with opacity
                backgroundColor: ksecondaryColor,
                radius: 25,
                child: Image(
                  image:
                      AssetImage('images/logoI.png'), // replace with your image
                ),
              ),
              const Gap(10),
              //Text for user
              Text(
                FirebaseAuth.instance.currentUser!.displayName ?? 'error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Gap(10),
              //some info for user
              // Text(
              //   'User Info',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 12,
              //   ),
              // ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text(
            Labels.aboutUs,
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.pop(context); // close the drawer
            Navigator.of(context).pushNamed(
              infoViewRoute,
            );
          },
        ),
      ],
    ),
  );
}
