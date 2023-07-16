import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/pdf_service.dart';
import '../services/storage_services.dart';

final loadingProvider =
    StateNotifierProvider<LoadingNotifier, bool>((ref) => LoadingNotifier());

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void show() => state = true;
  void hide() => state = false;

  Future<void> printAndLoad(String type, voucher) async {
    state = true; // Start loading
    var pdfServices = PdfServices(type: type, voucher: voucher);
    StorageServices storageServices =
        StorageServices(type: type, voucher: voucher);
    final pdf = await pdfServices.createPdf();
    await pdfServices.printPdf(pdf);

    String downloadUrl = await storageServices.uploadPdf(await pdf.save());

    if (await canLaunch(downloadUrl)) {
      await storageServices.launchURL(downloadUrl);
    } else {
      print('Could not launch $downloadUrl');
    } // Wait for the printMethod to finish

    state = false; // Stop loading
  }
}
