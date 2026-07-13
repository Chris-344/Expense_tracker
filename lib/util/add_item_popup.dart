import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddItemPopup extends StatefulWidget {
  final BuildContext context;
  bool isDeposit;
  List expenseArr;
  final TextEditingController itemController;
  final TextEditingController amountController;
  final Function(Map<String, dynamic>) onAdd;

  AddItemPopup({
    required this.context,
    required this.expenseArr,
    required this.itemController,
    required this.amountController,
    required this.onAdd,
    required this.isDeposit,
    super.key,
  });

  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  bool _isDeposit = true;

  @override
  Widget build(BuildContext context) {
    String capitalize(String x) => x[0].toUpperCase() + x.substring(1);

    List _expenseArr = widget.expenseArr;
    final _transactionData = Hive.box('TransactionData');

    return AlertDialog(
      title: Center(child: Text("Add Transaction")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.itemController,
            decoration: InputDecoration(labelText: "Item"),
          ),
          TextField(
            controller: widget.amountController,
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: Text("Deposit"),
                selected: _isDeposit,
                selectedColor: Colors.green,
                showCheckmark: false,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _isDeposit = selected;
                    });
                  }
                },
              ),
              ChoiceChip(
                label: Text("Withdraw"),
                selected: !_isDeposit,
                selectedColor: Colors.red,
                showCheckmark: false,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _isDeposit = !selected;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final newItem = {
              'Item': capitalize(widget.itemController.text),
              'amount': widget.amountController.text,
              'date': DateFormat("dd/MM/yyyy").format(DateTime.now()),
              'isDeposit': _isDeposit,
            };
            widget.onAdd(newItem);
            _expenseArr.add(newItem);
            _transactionData.put("Transactions", newItem);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
