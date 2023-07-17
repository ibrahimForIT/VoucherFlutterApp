import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/labels.dart';

final authViewModelProvider =
    ChangeNotifierProvider<AuthViewModel>((ref) => AuthViewModel());

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String _displayName = '';
  String get displayName => _displayName;
  set displayName(String value) {
    _displayName = value;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool value) {
    _obscureConfirmPassword = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? emailValidate(String value) {
    const String format =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    return !RegExp(format).hasMatch(value) ? Labels.enterValidEmail : null;
  }

  Future<void> login(WidgetRef ref) async {
    isLoading = true;
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      // print('login success');
      isLoading = false;
      // final firestore = FirebaseFirestore.instance;
      // ref.read(serviceProvider.notifier).state = VoucherService(firestore);
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      isLoading = false;
      if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        return Future.error(Labels.wrongPasswordPlease);
      } else if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        return Future.error(Labels.userNotFound);
      } else {
        // print('error: $e');
        return Future.error(e.message ?? '$e');
      }
    } catch (e) {
      // print('error: $e');
      isLoading = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // print('signOut success');
  }
}
