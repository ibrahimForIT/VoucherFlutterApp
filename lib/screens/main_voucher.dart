import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyhaa/providers/filter_providers/bank_filter_provider.dart';
import 'package:fyhaa/views/components/animations/data_not_found_animation_view.dart';
import 'package:fyhaa/views/components/animations/error_animation_view.dart';
import 'package:fyhaa/views/components/animations/loading_animation_view.dart';
import 'package:intl/intl.dart';
import '../providers/filter_providers/date_filter_provider.dart';
import '../providers/filter_providers/selected_date_filter_provider.dart';
import '../services/micro_services/date_picker.dart';
import '../utils/constants/constant.dart';
import 'package:gap/gap.dart';
import '../providers/auth_view_model_provider.dart';
import '../providers/filter_providers/no_filter_provider.dart';
import '../providers/filter_providers/search_bar_provider.dart';
import '../utils/labels.dart';
import '../widgets/search_bar/search_bar.dart';
import '../widgets/background_theme_widget.dart';
import '../widgets/filter_bar_widget.dart';
import '../widgets/show_drawer.dart';
import 'save_update_dialog.dart';
import '../providers/print_loading_provider.dart';
import '../providers/service_voucher_provider.dart';
import '../widgets/card_vouchers_widget.dart';

class MainVoucher extends ConsumerWidget {
  static const String screenRoute = Labels.mainVoucherScreenRoute;

  const MainVoucher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(collectionNameProvider);
    final currentUser =
        ref.watch(authViewModelProvider.select((value) => value.user));

    return Scaffold(
      appBar: homeAppBar(context, ref),
      drawer: showDrawer(context, ref),
      body: BackgroundTheme(
        child: Consumer(
          builder: (context, ref, child) {
            final isLoading = ref.watch(loadingProvider);

            final voucherStream = ref.watch(fetchStreamProvider(type));

            return isLoading
                ? const Center(child: LoadingAnimationView())
                // ? const Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Center(child: CircularProgressIndicator()),
                //       SizedBox(height: 20),
                //       Center(
                //           child: Text(
                //         'Uploading...',
                //         style: TextStyle(fontSize: 20, color: Colors.brown),
                //       )),
                //     ],
                //   )
                : voucherStream.when(
                    data: (vouchers) {
                      if (vouchers.isEmpty) {
                        return const Center(child: DataNotFoundAnimationView());
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final voucher = vouchers[index];
                            return ListTile(
                              title: GestureDetector(
                                onTap: () async {
                                  final updateVoucher =
                                      await createOrUpdateVoucher(
                                          context, ref, voucher);
                                  if (updateVoucher != null) {
                                    //no more need "update function" in data_model file
                                    // because we use the update function in the voucher_service file from database directly.
                                    ref.read(serviceProvider).updateDocument(
                                        currentUser!.uid,
                                        ref.watch(collectionNameProvider),
                                        updateVoucher.documentId ?? '',
                                        updateVoucher);
                                  }
                                },
                                onLongPress: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(Labels.deleteVoucher,
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                    content: const Text(
                                        Labels.detleteVoucherConfirmation),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text(
                                          Labels.no,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          Labels.yes,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    ref.read(serviceProvider).deleteDocument(
                                        currentUser!.uid,
                                        type,
                                        voucher.documentId ?? '');
                                  }
                                }),
                                child: CardVoucherWidget(
                                    type: type, voucher: voucher),
                              ),
                            );
                          },
                          itemCount: vouchers.length,
                        );
                      }
                    },
                    loading: () => const Center(child: LoadingAnimationView()),
                    error: (err, stack) {
                      print(err);
                      print(stack);
                      return Center(child: ErrorAnimationView());
                      // return Center(
                      //     child: Center(
                      //   child: Container(
                      //       width: 400,
                      //       color: Colors.red,
                      //       child: Text(
                      //         'Error: There are an error in the database, please contact the developer.',
                      //         style:
                      //             TextStyle(color: Colors.white, fontSize: 16),
                      //       )),
                      // ));
                    },
                  );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final lastVoucherIdAsyncValue =
              await ref.read(lastIdProvider(type).future);
          // ignore: use_build_context_synchronously
          await createOrUpdateVoucher(
              context, ref, null, lastVoucherIdAsyncValue);
        },
        child: const Icon(Icons.add),
      ),
      //),
    );
  }

  AppBar homeAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      shadowColor: shadowColor,
      //put this #a5955f

      backgroundColor: ksecondaryColor,
      title: const Text(
        Labels.appBarTitle,
      ),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
        color: Colors.white,
      ),
      bottom: PreferredSize(
        preferredSize: const Size(0, 60),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              //I need to add other widget here in same row

              child: ref.watch(showSearchBarProvider)
                  ? SearchBarWidget()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterWidget(
                            callbackAction: () => ref
                                .read(showSearchBarProvider.notifier)
                                .state = true,
                            title: Labels.search,
                            icon: Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          const Gap(10),
                          FilterWidget(
                              callbackAction: () async {
                                DateTime? newDate = await selectDate(context);
                                if (newDate != null) {
                                  // Do something with the date
                                  ref
                                      .read(selectedDateFilterProvider.notifier)
                                      .state = DateFormat(
                                          'dd/MM/yyyy')
                                      .format(newDate)
                                      .toString()
                                      .substring(0, 10);
                                } else {
                                  ref
                                      .read(selectedDateFilterProvider.notifier)
                                      .state = 'none';
                                }
                              },
                              title: ref.watch(selectedDateFilterProvider) !=
                                      'none'
                                  ? '${Labels.dateCreated}: ${ref.watch(selectedDateFilterProvider)}'
                                  : Labels.dateCreated,
                              icon: Icons.access_time,
                              color: ref.watch(selectedDateFilterProvider) !=
                                      'none'
                                  ? Colors.blue
                                  : Colors.grey),
                          const Gap(10),
                          FilterWidget(
                            callbackAction: () {
                              ref.read(noFilterProvider.notifier).state =
                                  'none';
                              ref.read(dateFilterProvider.notifier).state =
                                  'none';
                              ref.read(bankFilterProvider.notifier).state =
                                  ref.watch(bankFilterProvider) == 'none'
                                      ? 'cash'
                                      : ref.watch(bankFilterProvider) == 'cash'
                                          ? 'bank'
                                          : 'none';
                            },
                            title: Labels.types,
                            icon: ref.watch(bankFilterProvider) == 'none'
                                ? Icons.money
                                : ref.watch(bankFilterProvider) == 'bank'
                                    ? Icons.account_balance_outlined
                                    : Icons.attach_money_outlined,
                            color: ref.watch(bankFilterProvider) == 'none'
                                ? Colors.grey
                                : Colors.blue,
                          ),
                          const Gap(10),
                          FilterWidget(
                              callbackAction: () {
                                ref.read(noFilterProvider.notifier).state =
                                    'none';
                                ref.read(bankFilterProvider.notifier).state =
                                    'none';
                                ref.read(dateFilterProvider.notifier).state =
                                    ref.watch(dateFilterProvider) == 'none'
                                        ? 'asc'
                                        : ref.watch(dateFilterProvider) == 'asc'
                                            ? 'desc'
                                            : 'none';
                              },
                              title: Labels.date,
                              icon: ref.watch(dateFilterProvider) == 'none'
                                  ? Icons.numbers_outlined
                                  : ref.watch(dateFilterProvider) == 'asc'
                                      ? Icons.arrow_upward_outlined
                                      : Icons.arrow_downward_outlined,
                              color: ref.watch(dateFilterProvider) == 'none'
                                  ? Colors.grey
                                  : Colors.blue),
                          const Gap(10),
                          FilterWidget(
                              callbackAction: () {
                                ref.read(dateFilterProvider.notifier).state =
                                    'none';
                                ref.read(bankFilterProvider.notifier).state =
                                    'none';
                                ref.read(noFilterProvider.notifier).state =
                                    ref.watch(noFilterProvider) == 'none'
                                        ? 'asc'
                                        : ref.watch(noFilterProvider) == 'asc'
                                            ? 'desc'
                                            : 'none';
                              },
                              title: Labels.voucherNo,
                              icon: ref.watch(noFilterProvider) == 'none'
                                  ? Icons.numbers_outlined
                                  : ref.watch(noFilterProvider) == 'asc'
                                      ? Icons.arrow_upward_outlined
                                      : Icons.arrow_downward_outlined,
                              color: ref.watch(noFilterProvider) == 'none'
                                  ? Colors.grey
                                  : Colors.blue),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0, top: 10),
          child: CircleAvatar(
            //baclground color of the circle with opacity
            backgroundColor: ksecondaryColor,

            radius: 30,
            child: Image(
              image: AssetImage('images/logoI.png'), // replace with your image
            ),
          ),
        ),
      ],
    );
  }
}
