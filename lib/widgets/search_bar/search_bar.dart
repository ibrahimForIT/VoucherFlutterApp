import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/views/extensions/dismiss_keyboaed.dart';
import '../../providers/filter_providers/search_bar_provider.dart';
import '../../providers/service_voucher_provider.dart';
import '../../utils/labels.dart';

final searchController = TextEditingController();

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextFormField(
            autofocus: true,
            controller: searchController,
            onTapOutside: (event) =>
                ref.read(showSearchBarProvider.notifier).state = false,
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(1),
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  dismissKeyboard();
                  ref.read(showSearchBarProvider.notifier).state = false;
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
              border: InputBorder.none,
              hintText: Labels.searchBarHint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
