import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cheques.dart';
import '../../services/app_service.dart';
import '../../utils/labels.dart';

final currentUserProvider = StreamProvider<String>((ref) async* {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Yield the current user id immediately
  yield auth.currentUser?.uid ?? '';

  // Then listen for changes
  yield* auth.authStateChanges().map((user) => user?.uid ?? '');
});

final serviceChequeProvider = StateProvider<AppService>((ref) {
  return AppService(FirebaseFirestore.instance);
});

final fetchStreamProvider =
    StreamProvider.autoDispose.family<List<Cheque>, String>((ref, type) async* {
  final userIdAsyncValue = ref.watch(currentUserProvider);
  final userId = userIdAsyncValue.maybeWhen(
    data: (value) => value, // If the data is available, get the value
    orElse: () => null, // In case of loading or error, return null
  );

  // If there is no user, yield an empty list
  if (userId == null || userId.isEmpty) {
    yield [];
    return;
  }

  Query collection = FirebaseFirestore.instance
      .collection(Labels.users)
      .doc(userId)
      .collection(Labels.cheque);

  // We listen to the collection and return the corresponding data
  yield* collection
      .orderBy('chequeDate', descending: true)
      .snapshots()
      .map((event) => event.docs
          .map(
            (snapshot) => Cheque.fromSnapshot(snapshot),
          )
          .toList());
});
