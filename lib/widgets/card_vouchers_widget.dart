import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/vochers.dart';
import '../providers/print_loading_provider.dart';

class CardVoucherWidget extends ConsumerWidget {
  const CardVoucherWidget({
    super.key,
    required this.type,
    required this.voucher,
  });

  final String type;
  final Voucher voucher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 136,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: type == 'Pvoucher'
                  ? Colors.blue.shade800
                  : Colors.red.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text(
                      voucher.voucherId.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      (voucher.customerName),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      NumberFormat('#,###').format(voucher.totalAmount),
                      style: TextStyle(
                        fontSize: 16,
                        color: type == 'Pvoucher'
                            ? Colors.blue.shade800
                            : Colors.red.shade800,
                      ),
                    ),
                    trailing: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: type == 'Pvoucher'
                              ? Colors.blue.shade800
                              : Colors.red.shade800,
                          shape: const CircleBorder(),
                          value: voucher.isBank,
                          onChanged: (value) {},
                        )),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Container(
                      child: Column(children: [
                        Divider(
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text((DateFormat('dd/MM/yyyy')
                                .format(voucher.voucherDate))),

                            const Gap(12),

                            const Gap(12), // Add some gap between texts
                            Text(voucher.bankName ?? ''),
                            const Gap(12),
                            if (voucher.isBank)
                              Text((DateFormat('dd/MM/yyyy').format(
                                  voucher.chequeDate ?? DateTime.now()))),

                            Container(
                              child: IconButton(
                                iconSize: 32,
                                icon: const Icon(Icons
                                    .download_for_offline), // This will add the upload icon
                                onPressed: () async {
                                  // Add your onPressed logic here
                                  ref
                                      .read(loadingProvider.notifier)
                                      .printAndLoad(type, voucher);
                                },
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
