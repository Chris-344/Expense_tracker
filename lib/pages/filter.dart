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

    return Scaffold(
      appBar: AppBar(title: const Text('Filter')),
      body: Column(
        children: [
          Dateselector(
            inputtype: "Transaction date",
            controller: _currentDate,
            onDateChanged: () => setState(() {}),
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
