import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckboxStateNotifier extends StateNotifier<bool> {
  CheckboxStateNotifier() : super(false);

  void update(bool newValue) {
    state = newValue;
  }

  //reset checkbox
  void reset() {
    state = false;
  }
}

final checkboxStateNotifierProvider =
    StateNotifierProvider<CheckboxStateNotifier, bool>(
        (ref) => CheckboxStateNotifier());
