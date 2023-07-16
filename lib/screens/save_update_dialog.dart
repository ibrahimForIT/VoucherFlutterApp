import 'package:fyhaa/providers/radio_Provider.dart';
import 'package:fyhaa/widgets/radio_widget.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/vochers.dart';
import '../providers/auth_view_model_provider.dart';
import '../providers/date_provider.dart';
import '../providers/isBank_provider.dart';
import '../services/micro_services/show_dailog_for_user.dart';
import '../services/micro_services/totalAmount_format.dart';
import '../utils/labels.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;
DateTime? date;
DateTime? bankdate;
Key? key = UniqueKey();
Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return const Color.fromARGB(255, 0, 0, 0);
  }
  return Colors.brown;
}
//provider for isBank checkbox which will control the visibility of the bank fields

// List<String> data = [];
// Future searchData(String parma) async {
//   List<String> result =
//       await data.where((element) => element.contains(parma)).toList();
//   return result;
// }

final idVoucherController = TextEditingController();
final customerNameController = TextEditingController();
final voucherDateController = TextEditingController();
final totalAmountController = TextEditingController();
final chequeNumberController = TextEditingController();
final bankNameController = TextEditingController();
final chequeDateController = TextEditingController();
final notesController = TextEditingController();
final receiverSignatureController = TextEditingController();
final singnatureController = TextEditingController();

Future<Voucher?> createOrUpdateVoucher(
  BuildContext context,
  WidgetRef ref, [
  Voucher? existingVoucher,
  int? lastVoucherId,
]) async {
  final type = ref.watch(collectionNameProvider);
  final currentUser =
      ref.watch(authViewModelProvider.select((value) => value.user));

  int? voucherId = existingVoucher?.voucherId;
  String? customerName = existingVoucher?.customerName;
  bool? isMr = existingVoucher?.isMr;
  DateTime? voucherDate = existingVoucher?.voucherDate;
  double? totalAmount = existingVoucher?.totalAmount;
  bool? isBank = existingVoucher?.isBank;
  int? chequeNumber = existingVoucher?.chequeNumber;
  String? bankName = existingVoucher?.bankName;
  DateTime? chequeDate = existingVoucher?.chequeDate;
  String? notes = existingVoucher?.notes;
  String? receiverSignature = existingVoucher?.receiverSignature;
  String? singnature = existingVoucher?.singnature;

  if (existingVoucher == null) {
    // It's a new voucher
    idVoucherController.text = ((lastVoucherId ?? 0) + 1).toString();
    voucherId = ((lastVoucherId ?? 0) + 1);
  } else {
    // It's an existing voucher

    idVoucherController.text = voucherId?.toString() ?? '';
  }
  customerNameController.text = customerName ?? '';

  existingVoucher == null
      ? ref.read(radioProvider.notifier).update((state) => 0)
      : isMr == true
          ? ref.read(radioProvider.notifier).update((state) => 1)
          : ref.read(radioProvider.notifier).update((state) => 2);

  existingVoucher == null
      ? isBank = false
      : ref.read(checkboxStateNotifierProvider.notifier);

  voucherDateController.text =
      voucherDate != null ? DateFormat('dd/MM/yyyy').format(voucherDate) : '';
  totalAmountController.text =
      totalAmount != null ? NumberFormat('#,###').format(totalAmount) : '';

  chequeNumberController.text = chequeNumber?.toString() ?? '';
  bankNameController.text = bankName ?? '';
  chequeDateController.text =
      chequeDate != null ? DateFormat('dd/MM/yyyy').format(chequeDate) : '';
  notesController.text = notes ?? '';
  receiverSignatureController.text = receiverSignature ?? '';
  singnatureController.text = singnature ?? '';

  return showDialog<Voucher?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // final searchQueriesNotifier =
            //     ref.watch(searchQueriesProvider.notifier);
            // searchQueriesNotifier.loadSearchQueries();
            return AlertDialog(
              title: Text(existingVoucher == null
                  ? Labels.createVoucher
                  : Labels.editVoucher),
              content: SingleChildScrollView(
                child: Container(
                  width: 600,
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: idVoucherController,
                        decoration: const InputDecoration(
                          labelText: Labels.voucherNo,
                        ),
                        onChanged: (value) => voucherId = int.tryParse(value),
                      ),
                      TextField(
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (newDate == null) return;
                            //then we need to add the dateProvider to the form widget

                            ref.read(dateProvider).selectDate(newDate);
                            //show the date in the text field
                            voucherDateController.text =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            voucherDate = newDate;
                          },
                          textAlign: TextAlign.center,
                          controller: voucherDateController,
                          decoration: const InputDecoration(
                            labelText: Labels.date,
                          ),
                          onChanged: (value) {}),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: RadioWidget(
                                titleRadio: Labels.mr,
                                valueInput: 1,
                                onChangeValue: () {
                                  ref
                                      .read(radioProvider.notifier)
                                      .update((state) => 1);
                                  isMr = true;
                                }),
                          ),
                          Expanded(
                            child: RadioWidget(
                                titleRadio: Labels.ms,
                                valueInput: 2,
                                onChangeValue: () {
                                  ref
                                      .read(radioProvider.notifier)
                                      .update((state) => 2);
                                  isMr = false;
                                }),
                          ),
                          Expanded(
                              flex: 3,
                              child: TypeAheadField<String>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: false,
                                  textAlign: TextAlign.center,
                                  controller: customerNameController,
                                  decoration: const InputDecoration(
                                    labelText: Labels.customerName,
                                  ),
                                  onChanged: (String value) {
                                    customerName =
                                        value; // Assuming `customerName` is a variable you want to save the value to.
                                  },
                                ),
                                itemBuilder:
                                    (BuildContext context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (Object? suggestion) {
                                  customerNameController.text =
                                      suggestion.toString();
                                  customerName = suggestion.toString();
                                },
                                suggestionsCallback: (String pattern) async {
                                  return await searchData(ref, pattern, type);
                                },
                              )),
                        ],

                        //  TextField(
                        //     textAlign: TextAlign.center,
                        //     autofocus: true,
                        //     controller: customerNameController,
                        //     decoration: const InputDecoration(
                        //       labelText: Labels.coustomerName,
                        //     ),
                        //     onChanged: (value) {
                        //       customerName = value;
                        //     },
                        //   ),
                      ),
                      TextField(
                        inputFormatters: [_formatter],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: totalAmountController,
                        decoration: const InputDecoration(
                          labelText: Labels.totalAmount,
                        ),
                        onChanged: (value) {
                          formatAndSetTotalAmount(value, totalAmountController);
                          totalAmount = double.tryParse(value);
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            //cheack box child for padding widget
                            child: Checkbox(
                              key: key,
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isBank,
                              onChanged: (bool? value) {
                                ref
                                    .read(
                                        checkboxStateNotifierProvider.notifier)
                                    .update(value ?? false);
                                setState(() {
                                  isBank = value;
                                  if (value == false) {
                                    bankName = null;
                                    chequeDate = null;
                                    chequeNumber = null;
                                  }
                                });
                              },
                            ),
                          ),
                          if (isBank!)
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: chequeNumberController,
                                decoration: const InputDecoration(
                                  labelText: Labels.chequeNo,
                                ),
                                onChanged: (value) =>
                                    chequeNumber = int.tryParse(value),
                              ),
                            ),
                          const Gap(15),
                          if (isBank!)
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: bankNameController,
                                decoration: const InputDecoration(
                                  labelText: Labels.bankName,
                                ),
                                onChanged: (value) => bankName = value,
                              ),
                            ),
                          const Gap(15),
                          if (isBank!)
                            Expanded(
                              child: TextField(
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: bankdate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (newDate == null) return;
                                    ref.read(dateProvider).selectDate(newDate);
                                    //show the date in the text field
                                    chequeDateController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate);
                                    chequeDate = newDate;
                                  },
                                  textAlign: TextAlign.center,
                                  controller: chequeDateController,
                                  decoration: const InputDecoration(
                                    labelText: Labels.chequeDate,
                                  ),
                                  onChanged: (value) {}),
                            ),
                        ],
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: Labels.notes,
                        ),
                        onChanged: (value) => notes = value,
                      ),
                      TextField(
                          textAlign: TextAlign.center,
                          controller: receiverSignatureController,
                          decoration: const InputDecoration(
                            labelText: Labels.receiverSignatur,
                          ),
                          onChanged: (value) {
                            receiverSignature = value;
                            // print(chequeDate);
                          }),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: singnatureController,
                        decoration: const InputDecoration(
                          labelText: Labels.signatur,
                        ),
                        onChanged: (value) => singnature = value,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      // print(voucherId);
                      // print(customerName);
                      // print(isMr);
                      // print(voucherDate);
                      // print(totalAmount);
                      // print(notes);
                      // print(receiverSignature);
                      // print(singnature);

                      if (voucherId != null &&
                          customerName != null &&
                          isMr != null &&
                          voucherDate != null &&
                          totalAmount != null &&
                          notes != null &&
                          receiverSignature != null &&
                          singnature != null) {
                        if (existingVoucher != null) {
                          Navigator.of(context).pop(existingVoucher.update(
                              voucherId,
                              customerName,
                              isMr,
                              voucherDate,
                              totalAmount,
                              isBank,
                              chequeNumber,
                              bankName,
                              chequeDate,
                              notes,
                              receiverSignature,
                              singnature));
                          showStateDialog(context, Labels.success,
                              Labels.voucherUpdatedSuccessfully, Colors.green);
                        } else {
                          Navigator.of(context).pop(
                            Voucher(
                                voucherId: voucherId!,
                                customerName: customerName!,
                                isMr: isMr!,
                                voucherDate: voucherDate!,
                                totalAmount: totalAmount!,
                                isBank: isBank!,
                                chequeNumber: chequeNumber,
                                bankName: bankName,
                                chequeDate: chequeDate,
                                notes: notes!,
                                receiverSignature: receiverSignature!,
                                singnature: singnature!),
                          );

                          try {
                            Voucher voucher = Voucher(
                                voucherId: voucherId!,
                                customerName: customerName!,
                                isMr: isMr!,
                                voucherDate: voucherDate!,
                                totalAmount: totalAmount!,
                                isBank: isBank!,
                                chequeNumber: chequeNumber,
                                bankName: bankName,
                                chequeDate: chequeDate,
                                notes: notes!,
                                receiverSignature: receiverSignature!,
                                singnature: singnature!);
                            ref
                                .read(serviceProvider)
                                .addDocument(currentUser!.uid, type, voucher);
                            showStateDialog(
                                context,
                                Labels.success,
                                Labels.voucherCreatedSuccessfully,
                                Colors.green);
                          } catch (e) {
                            // print(e);
                            showStateDialog(context, Labels.failed,
                                Labels.voucherFailedToAdd, Colors.red);
                          }
                        }
                      } else {
                        showStateDialog(context, Labels.opps,
                            Labels.emptyFields, Colors.red);
                      }
                    } catch (e) {
                      //no name or age or both
                      // print('There are empty fields');

                      Navigator.of(context).pop();
                      // print(e);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(Labels.save),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(Labels.cancel),
                ),
              ],
            );
          },
        );
      });
}
