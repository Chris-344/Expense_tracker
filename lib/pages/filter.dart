import 'package:expense_tracker/util/dateselector.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

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

class _FilterState extends State<Filter> {
  final TextEditingController _currentDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemData = Hive.box("TransactionData");
    final List _transactionArray = itemData.get("Transactions") ?? [];

    List _filteredArray = [];
    for (Map item in _transactionArray) {
      if (_currentDate.text.isEmpty || item['date'] == _currentDate.text) {
        _filteredArray.add(item);
      }
    }

    int total = 0;
    int withdrawlTotal = 0;
    int depositTotal = 0;

    for (Map item in _filteredArray) {
      if (item['isDeposit']) {
        total += int.parse(item['amount']);
      } else {
        total -= int.parse(item['amount']);
      }
    }
    for (Map item in _filteredArray) {
      if (item['isDeposit']) {
        depositTotal += int.parse(item['amount']);
      } else {
        withdrawlTotal += int.parse(item['amount']);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Filter')),
      body: Column(
        children: [
          Dateselector(
            inputtype: "Transaction date",
            controller: _currentDate,
            onDateChanged: () => setState(() {}),
          ),

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
              itemCount: _filteredArray.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(_filteredArray[index]['Item'] + '    '),
                          Text(_filteredArray[index]['date']),
                        ],
                      ),
                      tileColor: Colors.amber,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
