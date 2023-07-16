// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void formatAndSetTotalAmount(String value, TextEditingController controller) {
  final numericValue = int.tryParse(value);
  if (numericValue != null) {
    final formattedValue = NumberFormat('#,###').format(numericValue);
    controller.value = controller.value.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
