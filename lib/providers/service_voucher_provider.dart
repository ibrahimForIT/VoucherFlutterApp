import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/providers/filter_providers/no_filter_provider.dart';
import 'package:fyhaa/services/app_service.dart';
import 'package:intl/intl.dart';
import '../models/vochers.dart';
import '../utils/labels.dart';
import 'filter_providers/bank_filter_provider.dart';
import 'filter_providers/date_filter_provider.dart';
import 'filter_providers/selected_date_filter_provider.dart';

final collectionNameProvider = StateProvider<String>((ref) {
  return 'Pvoucher'; // default collection
});
final searchQueryProvider = StateProvider<String>((ref) => '');

final currentUserProvider = StreamProvider<String>((ref) async* {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Yield the current user id immediately
  yield auth.currentUser?.uid ?? '';

  // Then listen for changes
  yield* auth.authStateChanges().map((user) => user?.uid ?? '');
});

final serviceProvider = StateProvider<AppService>((ref) {
  return AppService(FirebaseFirestore.instance);
});

//creates a family of stream providers that automatically disposes of the stream when it is no longer being listened to.
// This is useful for freeing up resources in your app when they're no longer needed.
// The .family constructor is a way of creating a parameterized provider,
// meaning the provider's behavior could be changed depending on the parameter received.
// In this case, the type parameter is a String.
// The type parameter is used to determine which collection to listen to in Firestore.
//define enum for tow data types

final fetchStreamProvider = StreamProvider.autoDispose
    .family<List<Voucher>, String>((ref, type) async* {
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
      .collection(type);

  if (type == Labels.pVoucher || type == Labels.rVoucher) {
    final searchQuery = ref.watch(searchQueryProvider);
    final noFilter = ref.watch(noFilterProvider);
    final dateFilter = ref.watch(dateFilterProvider);
    final bankFilter = ref.watch(bankFilterProvider);
    final selectedDateFilter = ref.watch(selectedDateFilterProvider);
    // if (searchQuery.isNotEmpty) {
    //   // Add search functionality
    //   collection = collection
    //       .orderBy(Labels.coustomerName)
    //       .startAt([searchQuery]).endAt(['$searchQuery\uf8ff']);
    // }

    searchQuery.isNotEmpty
        ? collection = collection
            .orderBy(Labels.customerName)
            .startAt([searchQuery]).endAt(['$searchQuery\uf8ff'])
        : collection = collection;

    // if (noFilter == 'desc') {
    //   collection = collection.orderBy(Labels.voucherId, descending: false);
    // } else if (noFilter == 'asc') {
    //   collection = collection.orderBy(Labels.voucherId, descending: true);
    // }
    noFilter == 'desc'
        ? collection = collection.orderBy(Labels.voucherId, descending: false)
        : noFilter == 'asc'
            ? collection =
                collection.orderBy(Labels.voucherId, descending: true)
            : collection = collection;

    dateFilter == 'desc'
        ? collection = collection.orderBy(Labels.voucherDate, descending: false)
        : dateFilter == 'asc'
            ? collection =
                collection.orderBy(Labels.voucherDate, descending: true)
            : collection = collection;

    bankFilter == 'bank'
        ? collection = collection.where('isBank', isEqualTo: true)
        : bankFilter == 'cash'
            ? collection = collection.where('isBank', isEqualTo: false)
            : collection = collection;

    if (selectedDateFilter != 'none') {
      DateFormat format = DateFormat("dd/MM/yyyy");
      DateTime parsedDate = format.parse(selectedDateFilter);

      collection = collection.where('voucherDate', isEqualTo: parsedDate);
    }

    if (selectedDateFilter == 'none' &&
        dateFilter == 'none' &&
        noFilter == 'none' &&
        bankFilter == 'none' &&
        searchQuery.isEmpty) {
      collection = collection.orderBy('voucherDate', descending: true);
    }
  } else {
    collection = collection.orderBy('chequeDate', descending: true);
  }

  final getData = collection
      // .orderBy('voucherDate', descending: true)
      .snapshots()
      .map((event) => event.docs
          .map((snapshot) => Voucher.fromSnapshot(snapshot))
          .toList());
// the generator function will yield each value from the getData stream.
// Because getData is a stream, it will continue to produce new values every time there's a change in the Firestore collection,
// and these new values will be yielded by the generator function.
  yield* getData;
});

final lastIdProvider =
    FutureProvider.autoDispose.family<int, String>((ref, type) async {
  final userIdAsyncValue = ref.watch(currentUserProvider);
  final userId = userIdAsyncValue.maybeWhen(
    data: (value) => value, // If the data is available, get the value
    orElse: () => null, // In case of loading or error, return null
  );

  // If there is no user, return default value
  if (userId == null || userId.isEmpty) {
    return 0;
  }
  try {
    // Get the last voucher id from firestore
    final collection = FirebaseFirestore.instance
        .collection(Labels.users)
        .doc(userId)
        .collection(type);
    final lastDoc = await collection
        .orderBy(type == Labels.cheque ? Labels.chequeId : Labels.voucherId,
            descending: true)
        .limit(1)
        .get();
    final lastVoucherId = lastDoc.docs.first
        .get(type == Labels.cheque ? Labels.chequeId : Labels.voucherId);
    return lastVoucherId ?? 0;
  } catch (e) {
    print(e);
  }
  return 0;
});

Future<List<String>> searchData(
    WidgetRef ref, String pattern, type, context) async {
  final userIdAsyncValue = ref.watch(currentUserProvider);
  final userId = userIdAsyncValue.maybeWhen(
    data: (value) => value, // If the data is available, get the value
    orElse: () => null, // In case of loading or error, return null
  );

  final querySnapshot = await FirebaseFirestore.instance
      .collection(Labels.users)
      .doc(userId)
      .collection(type)
      .get();

  // Convert to Set to ensure uniqueness

  Set<String> customerNames = querySnapshot.docs
      .map((doc) => doc.data()['customerName'] as String)
      .toSet();

  List<String> results =
      customerNames.where((name) => name.contains(pattern)).toList();

  return results;
}
