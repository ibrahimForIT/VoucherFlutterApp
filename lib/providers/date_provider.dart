import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}

final dateProvider =
    ChangeNotifierProvider<DateProvider>((ref) => DateProvider());
