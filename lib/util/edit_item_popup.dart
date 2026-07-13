import 'package:flutter/material.dart';

class EditItemPopup extends StatefulWidget {
  final TextEditingController itemController;
  final TextEditingController amountController;
  final List transactionArray;
  final int index;
  final BuildContext context;
  final Function(int index, String item, String amount, bool isDeposit)
  onEdit; // Add this

  const EditItemPopup({
    super.key,
    required this.context,
    required this.itemController,
    required this.amountController,
    required this.transactionArray,
    required this.index,
    required this.onEdit, // Add this
  });

  @override
  State<EditItemPopup> createState() => _EditItemPopupState();
}

class _EditItemPopupState extends State<EditItemPopup> {
  void saveChange() {
    String capitalize(String x) => x[0].toUpperCase() + x.substring(1);

    final editedItem = capitalize(widget.itemController.text);
    final editedAmount = widget.amountController.text;

    widget.onEdit(widget.index, editedItem, editedAmount, isDeposit);
    Navigator.pop(context);
  }

  bool isDeposit = true;
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
