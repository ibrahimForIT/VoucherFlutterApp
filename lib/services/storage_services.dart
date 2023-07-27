import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import '../models/vochers.dart';

class StorageServices {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final String type;
  final Voucher voucher; // Remember to import your Voucher model.

  // Constructor
  StorageServices({required this.type, required this.voucher});

  Future<String> uploadPdf(Uint8List pdfData) async {
    String downloadUrl = '';
    // Your existing upload to Firebase Storage code here
    try {
      Reference ref = FirebaseStorage.instance
          .ref('$userId/${type}s/$type${voucher.voucherId}.pdf');
      // UploadTask uploadTask = ref.putData(pdfData);

      // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      //   print(
      //       'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      // });

      // uploadTask.then((TaskSnapshot snapshot) {
      //   print('Upload complete');
      // });

      downloadUrl = await ref.getDownloadURL();
      // print("Download URL: $downloadUrl");
    } catch (e) {
      // print(e);
      rethrow;
    }
    return downloadUrl;
  }

  // Future<void> launchURL(String downloadUrl) async {
  //   if (await canLaunch(downloadUrl)) {
  //     await launch(downloadUrl);
  //   } else {
  //     throw 'Could not launch $downloadUrl';
  //   }
  // }
}
