import 'package:expense_tracker/util/add_item_popup.dart';
import 'package:expense_tracker/util/edit_item_popup.dart';
import 'package:expense_tracker/util/mydrawer.dart';
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
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final itemData = Hive.box("TransactionData");
  late final List _transactionArray = itemData.get("Transactions");

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
            dateController: _dateController,
            index: index,
            onEdit: editItem,
          ),
    );
  }

  void deleteItem(List arr, int index) {
    setState(() => arr.removeAt(index));
    itemData.put("Transactions", _transactionArray);
  }

  void addExpense(Map<String, dynamic> item) {
    setState(() {
      _transactionArray.add(item);
    });
    _itemController.clear();
    _amountController.clear();

    itemData.put("Transactions", _transactionArray);
  }

  void editItem(
    int index,
    String item,
    String amount,
    bool isDeposit,
    String date,
  ) {
    setState(() {
      _transactionArray[index]['Item'] = item;
      _transactionArray[index]['amount'] = amount;
      _transactionArray[index]['isDeposit'] = isDeposit;
      _transactionArray[index]['date'] = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    int withdrawlTotal = 0;
    int depositTotal = 0;
    int total = 0;

    for (Map item in _transactionArray) {
      if (item['isDeposit']) {
        total += int.parse(item['amount']);
      } else {
        total -= int.parse(item['amount']);
      }
    }

    for (Map item in _transactionArray) {
      if (item['isDeposit']) {
        depositTotal += int.parse(item['amount']);
      } else {
        withdrawlTotal += int.parse(item['amount']);
      }
    }

    return Scaffold(
      drawer: Mydrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text("Finance Tracker", textAlign: TextAlign.center),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  "Deposit\n $depositTotal",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "Withdrawl\n$withdrawlTotal",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "Total\n $total",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactionArray.length,
              itemBuilder: (context, index) {
                final transaction = _transactionArray[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    tileColor:
                        transaction['isDeposit']
                            ? const Color.fromARGB(255, 157, 220, 85)
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
          ),
        ],
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
                  dateController: _dateController,
                  onAdd: addExpense,
                ),
          );
        },
      ),
    );
  }
}
