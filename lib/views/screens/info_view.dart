import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utils/constants/constant.dart';
import '../../utils/constants/routes.dart';
import '../../utils/labels.dart';

class InfoView extends StatelessWidget {
  static const String screenRoute = infoViewRoute;
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        //add icon to get out of this screen
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(Labels.aboutUs),
        backgroundColor: ksecondaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(Labels.sysName),
            const Gap(10),
            const Text(Labels.version),
            const Gap(10),
            //add image here
            Image.asset(
              'images/logoI.png',
              width: 100,
              height: 100,
            ),
            const Gap(10),
            const Text(Labels.developerInfo),
            const Gap(10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copyright_outlined,
                  size: 16,
                ),
                Text(Labels.allRightsReserved),
              ],
            )
          ],
        ),
      ),
    );
  }
}
