import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../services/app_service.dart';

class Voucher extends AppModel {
  final String uuid;
  String? documentId;
  final int voucherId;
  final String customerName;
  final bool isMr;
  final DateTime voucherDate;
  final double totalAmount;
  final bool isBank;
  int? chequeNumber;
  String? bankName;
  DateTime? chequeDate;
  final String notes;
  final String receiverSignature;
  final String singnature;

  Voucher({
    this.documentId,
    required this.voucherId,
    required this.customerName,
    required this.isMr,
    required this.voucherDate,
    required this.totalAmount,
    required this.isBank,
    this.chequeNumber,
    this.bankName,
    this.chequeDate,
    required this.notes,
    required this.receiverSignature,
    required this.singnature,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Voucher update(
      [int? voucherId,
      String? customerName,
      bool? isMr,
      DateTime? voucherDate,
      double? totalAmount,
      bool? isBank,
      int? chequeNumber,
      String? bankName,
      DateTime? chequeDate,
      String? notes,
      String? receiverSignature,
      String? singnature]) {
    return Voucher(
      uuid: uuid,
      documentId: documentId,
      voucherId: voucherId ?? this.voucherId,
      customerName: customerName ?? this.customerName,
      isMr: isMr ?? this.isMr,
      voucherDate: voucherDate ?? this.voucherDate,
      totalAmount: totalAmount ?? this.totalAmount,
      isBank: isBank ?? this.isBank,
      chequeNumber: chequeNumber,
      bankName: bankName,
      chequeDate: chequeDate,
      notes: notes ?? this.notes,
      receiverSignature: receiverSignature ?? this.receiverSignature,
      singnature: singnature ?? this.singnature,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentId': documentId,
      'voucherId': voucherId,
      'customerName': customerName,
      'isMr': isMr,
      'voucherDate': Timestamp.fromDate(voucherDate),
      'totalAmount': totalAmount,
      'isBank': isBank,
      'chequeNumber': chequeNumber,
      'bankName': bankName,
      'chequeDate': chequeDate != null ? Timestamp.fromDate(chequeDate!) : null,
      'notes': notes,
      'receiverSignature': receiverSignature,
      'singnature': singnature,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      documentId:
          map['documentId'] != null ? map['documentId'] as String : null,
      voucherId: map['voucherId'] as int,
      customerName: map['customerName'] as String,
      isMr: map['isMr'] as bool,
      voucherDate:
          DateTime.fromMillisecondsSinceEpoch(map['voucherDate'] as int),
      totalAmount: map['totalAmount'] as double,
      isBank: map['isBank'] as bool,
      chequeNumber: map['chequeNumber'] as int,
      bankName: map['bankName'] as String,
      chequeDate: DateTime.fromMillisecondsSinceEpoch(map['chequeDate'] as int),
      notes: map['notes'] as String,
      receiverSignature: map['receiverSignature'] as String,
      singnature: map['singnature'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) =>
      Voucher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Voucher(documentId: $documentId, voucherId: $voucherId, customerName: $customerName, isMr: $isMr , voucherDate: $voucherDate, totalAmount: $totalAmount, isbank: $isBank, bankName: $bankName  , notes: $notes, receiverSignature: $receiverSignature, singnature: $singnature)';
  }

  @override
  bool operator ==(covariant Voucher other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  factory Voucher.fromSnapshot(DocumentSnapshot<Object?> doc) {
    return Voucher(
      documentId: doc.id,
      voucherId: (doc['voucherId'] as num).toInt(),
      voucherDate: (doc['voucherDate'] as Timestamp).toDate(),
      customerName: doc['customerName'],
      isMr: doc['isMr'],
      totalAmount: (doc['totalAmount'] as num).toDouble(),
      isBank: doc['isBank'],
      chequeNumber: doc['chequeNumber'],
      bankName: doc['bankName'],
      chequeDate: doc['chequeDate'] != null
          ? (doc['chequeDate'] as Timestamp).toDate()
          : null,
      notes: doc['notes'],
      receiverSignature: doc['receiverSignature'],
      singnature: doc['singnature'],
    );
  }

  String get displayVoucher =>
      '$voucherId       $customerName         ${NumberFormat('#,###').format(totalAmount)}         ${DateFormat('dd/MM/yyyy').format(voucherDate)}  ${isBank ? bankName : ''}';
}
