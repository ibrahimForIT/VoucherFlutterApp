import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../services/app_service.dart';

class Cheque extends AppModel {
  final String uuid;
  String? documentId;
  final int chequeId;
  final String customerName;
  final double totalAmount;
  final String totalAmountInWords;
  final DateTime chequeDate;

  Cheque({
    this.documentId,
    required this.chequeId,
    required this.customerName,
    required this.totalAmount,
    required this.totalAmountInWords,
    required this.chequeDate,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Cheque update(
      [int? chequeId,
      String? customerName,
      double? totalAmount,
      String? totalAmountInWords,
      DateTime? chequeDate]) {
    return Cheque(
      uuid: uuid,
      documentId: documentId,
      chequeId: chequeId ?? this.chequeId,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      totalAmountInWords: totalAmountInWords ?? this.totalAmountInWords,
      chequeDate: chequeDate ?? this.chequeDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'documentId': documentId,
      'chequeId': chequeId,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'totalAmountInWords': totalAmountInWords,
      'chequeDate': chequeDate.millisecondsSinceEpoch,
    };
  }

  factory Cheque.fromMap(Map<String, dynamic> map) {
    return Cheque(
      uuid: map['uuid'] as String,
      documentId:
          map['documentId'] != null ? map['documentId'] as String : null,
      chequeId: map['chequeId'] as int,
      customerName: map['customerName'] as String,
      totalAmount: map['totalAmount'] as double,
      totalAmountInWords: map['totalAmountInWords'] as String,
      chequeDate: DateTime.fromMillisecondsSinceEpoch(map['chequeDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cheque.fromJson(String source) =>
      Cheque.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Cheque other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  factory Cheque.fromSnapshot(DocumentSnapshot<Object?> doc) {
    return Cheque(
      documentId: doc.id,
      chequeId: (doc['chequeId'] as num).toInt(),
      customerName: doc['customerName'],
      totalAmount: (doc['totalAmount'] as num).toDouble(),
      totalAmountInWords: doc['totalAmountInWords'],
      chequeDate: (doc['chequeDate'] as Timestamp).toDate(),
    );
  }
}
