// ignore_for_file: prefer_final_fields

import 'package:expense_tracker/util/add_item_popup.dart';
import 'package:expense_tracker/util/edit_item_popup.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class ExpenseItem {
  final String item;
  final String amount;
  final String date;
  final bool isDeposit;

  ExpenseItem({
    required this.item,
    required this.amount,
    required this.date,
    required this.isDeposit,
  });

  Map<String, dynamic> toMap() => {
    'Item': item,
    'amount': amount,
    'date': date,
    'isDeposit': isDeposit,
  };
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final itemData = Hive.box("TransactionData");

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List _transactionArray = [];

  bool isDeposit = true;

  void editItemPopup(int index) {
    final TextEditingController itemController = TextEditingController(
      text: _transactionArray[index]["Item"],
    );
    final TextEditingController amountController = TextEditingController(
      text: _transactionArray[index]["amount"],
    );

    showDialog(
      context: context,
      builder:
          (context) => EditItemPopup(
            context: context,
            itemController: itemController,
            amountController: amountController,
            transactionArray: _transactionArray,
            index: index,
            onEdit: editItem,
          ),
    );
  }

  void deleteItem(List arr, int index) => setState(() => arr.removeAt(index));

  void addExpense(Map<String, dynamic> item) {
    setState(() {
      _transactionArray.add(item);
    });
    _itemController.clear();
    _amountController.clear();
  }

  double calculateFinal(List items, String date) {
    double daysTotal = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['date'] != date) continue; // Changed condition
      if (items[i]['isDeposit']) {
        daysTotal += double.parse(items[i]['amount']);
      } else {
        daysTotal -= double.parse(items[i]['amount']);
      }
    }
    return daysTotal;
  }

  void editItem(int index, String item, String amount, bool isDeposit) {
    setState(() {
      _transactionArray[index]['Item'] = item;
      _transactionArray[index]['amount'] = amount;
      _transactionArray[index]['isDeposit'] = isDeposit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text("Finance Tracker", textAlign: TextAlign.center),
        ),
      ),
      body: ListView.builder(
        itemCount: _transactionArray.length,
        itemBuilder: (context, index) {
          final transaction = _transactionArray[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              tileColor:
                  transaction['isDeposit']
                      ? Colors.lightGreen
                      : Colors.pinkAccent,
              onLongPress: () => deleteItem(_transactionArray, index),
              title: Text(
                transaction['Item'],
                style: const TextStyle(fontSize: 25),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, size: 18),
                      Text(
                        '${transaction['amount']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => editItemPopup(index),
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AddItemPopup(
                  context: context,
                  isDeposit: isDeposit,
                  expenseArr: _transactionArray,
                  itemController: _itemController,
                  amountController: _amountController,
                  onAdd: addExpense,
                ),
          );
        },
      ),
    );
  }
}
