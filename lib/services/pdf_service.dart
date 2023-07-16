import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/vochers.dart';
import 'micro_services/is_string_arabic.dart';
import 'micro_services/notes_string_spilt.dart';

class PdfServices {
  final String type;
  final Voucher voucher; // Remember to import your Voucher model.

  // Constructor
  PdfServices({required this.type, required this.voucher});

  Future<pw.Document> createPdf() async {
    // Your existing PDF creation code here

    var arabicFont = Font.ttf(await rootBundle.load("fonts/HacenTunisia.ttf"));

    var imageRvoucher = pw.MemoryImage(
      (await rootBundle.load('images/Rvoucher.jpg')).buffer.asUint8List(),
    );
    var imagePvoucher = pw.MemoryImage(
      (await rootBundle.load('images/Pvoucher.jpg')).buffer.asUint8List(),
    );
    final pdf = pw.Document();
    // we need to add data to pdf file
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5.copyWith(
          width: PdfPageFormat.a5.height,
          height: PdfPageFormat.a5.width,
          marginLeft: 0,
          marginRight: 0,
          marginTop: 0,
          marginBottom: 0,
        ),
        build: (pw.Context context) => pw.Container(
          padding: const pw.EdgeInsets.all(5.0),
          alignment: pw.Alignment.center,
          child: pw.Stack(
            children: [
              pw.Expanded(
                  child: pw.Image(
                type == 'Rvoucher' ? imageRvoucher : imagePvoucher,
                fit: pw.BoxFit.cover,
              )),
              pw.Positioned(
                left: 52,
                top: 128,
                child: pw.Text(
                  voucher.voucherId.toString(),
                  style: const pw.TextStyle(fontSize: 25, color: PdfColors.red),
                ),
              ),
              pw.Positioned(
                right: 53,
                top: 150,
                child: pw.Text(
                    DateFormat('dd/MM/yyyy').format(voucher.voucherDate),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              isArabic(voucher.customerName)
                  ? pw.Positioned(
                      right: 200,
                      top: 188,
                      child: pw.Text(
                          voucher.isMr == true
                              ? 'السيد ${voucher.customerName}'
                              : 'السيدة ${voucher.customerName}',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18,
                          )),
                    )
                  : pw.Positioned(
                      left: 160,
                      top: 188,
                      child: pw.Text(
                          voucher.isMr == true
                              ? 'Mr. ${voucher.customerName}'
                              : 'Ms. ${voucher.customerName}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
              isArabic(voucher.customerName)
                  ? pw.Positioned(
                      left: 220,
                      top: 222,
                      child: pw.Text(
                          NumberFormat('#,###').format(voucher.totalAmount),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18,
                          )),
                    )
                  : pw.Positioned(
                      left: 160,
                      top: 222,
                      child: pw.Text(
                          NumberFormat('#,###').format(voucher.totalAmount),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
              pw.Positioned(
                left: 90,
                top: 264,
                child: pw.Text(
                    voucher.chequeNumber == null
                        ? ''
                        : voucher.chequeNumber.toString(),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
              pw.Positioned(
                left: 340,
                top: 264,
                child: pw.Text(voucher.bankName ?? '',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
              pw.Positioned(
                right: 53,
                top: 270,
                child: pw.Text(
                    voucher.chequeDate == null
                        ? ''
                        : DateFormat('dd/MM/yyyy').format(voucher.chequeDate!),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              isArabic(voucher.notes)
                  ? pw.Positioned(
                      right: 120,
                      top: 302,
                      child: Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(insertLineBreaks(voucher.notes, 60),
                            style: pw.TextStyle(
                              font: arabicFont,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                    )
                  : pw.Positioned(
                      left: 60,
                      top: 305,
                      child: pw.Text(insertLineBreaks(voucher.notes, 50),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
              isArabic(voucher.receiverSignature)
                  ? pw.Positioned(
                      right: 354,
                      bottom: 24,
                      child: pw.Text(
                          voucher.receiverSignature.length > 19
                              ? '${voucher.receiverSignature.substring(0, 18)}..'
                              : voucher.receiverSignature,
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          )),
                    )
                  : pw.Positioned(
                      left: 110,
                      bottom: 26,
                      child: pw.Text(
                          voucher.receiverSignature.length > 14
                              ? '${voucher.receiverSignature.substring(0, 13)}..'
                              : voucher.receiverSignature,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
              isArabic(voucher.singnature)
                  ? pw.Positioned(
                      right: 60,
                      bottom: 24,
                      child: pw.Text(
                          voucher.singnature.length > 16
                              ? '${voucher.singnature.substring(0, 15)}...'
                              : voucher.singnature,
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          )),
                    )
                  : pw.Positioned(
                      left: 406,
                      bottom: 28,
                      child: pw.Text(
                          voucher.singnature.length > 14
                              ? '${voucher.singnature.substring(0, 13)}..'
                              : voucher.singnature,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
    // Return the pdf document
    return pdf;
  }

  Future<void> printPdf(pw.Document pdf) async {
    // Your existing PDF printing code here
    try {
      await Printing.layoutPdf(
          name: 'voucher${voucher.voucherId}.pdf',
          format: PdfPageFormat.a5.copyWith(
              width: PdfPageFormat.a5.height, height: PdfPageFormat.a5.width),
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      // print(e);
    }
  }
}
