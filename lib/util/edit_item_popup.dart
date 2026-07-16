import 'package:expense_tracker/util/dateselector.dart';
import 'package:flutter/material.dart';

class EditItemPopup extends StatefulWidget {
  final TextEditingController itemController;
  final TextEditingController amountController;
  final TextEditingController dateController;
  final List transactionArray;
  final int index;
  final BuildContext context;
  final Function(
    int index,
    String item,
    String amount,
    bool isDeposit,
    String date,
  )
  onEdit;

  const EditItemPopup({
    super.key,
    required this.context,
    required this.itemController,
    required this.amountController,
    required this.dateController,
    required this.transactionArray,
    required this.index,
    required this.onEdit,
  });

  @override
  State<EditItemPopup> createState() => _EditItemPopupState();
}

class _EditItemPopupState extends State<EditItemPopup> {
  late bool isDeposit;
  String? errorText;

  @override
  void initState() {
    super.initState();
    isDeposit = widget.transactionArray[widget.index]['isDeposit'];
    widget.dateController.text = widget.transactionArray[widget.index]['date'];
  }

  String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  void saveChange() {
    final rawItem = widget.itemController.text.trim();
    final rawAmount = widget.amountController.text.trim();

    if (rawItem.isEmpty) {
      setState(() => errorText = 'Item name cannot be empty');
      return;
    }

    final parsedAmount = double.tryParse(rawAmount);
    if (parsedAmount == null) {
      setState(() => errorText = 'Enter a valid amount');
      return;
    }

    final editedItem = capitalize(rawItem);
    final editedAmount = widget.amountController.text;
    final editedDate = widget.dateController.text;

    widget.onEdit(
      widget.index,
      editedItem,
      editedAmount,
      isDeposit,
      editedDate,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: widget.itemController),
          TextField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          Dateselector(
            inputtype: "Transaction date",
            controller: widget.dateController,
            onDateChanged: () => setState(() {}),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: Text("Deposit"),
                selected: isDeposit,
                selectedColor: Colors.green,
                showCheckmark: false,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      isDeposit = selected;
                    });
                  }
                },
              ),
              ChoiceChip(
                label: Text("Withdraw"),
                selected: !isDeposit,
                selectedColor: Colors.red,
                showCheckmark: false,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      isDeposit = !selected;
                    });
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(onPressed: saveChange, child: Text('Edit')),
            ],
          ),
        ],
      ),
    );
  }
}
