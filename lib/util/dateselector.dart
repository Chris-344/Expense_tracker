import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dateselector extends StatefulWidget {
  final String inputtype;
  final TextEditingController controller;
  final VoidCallback? onDateChanged;

  const Dateselector({
    super.key,
    required this.inputtype,
    required this.controller,
    required this.onDateChanged,
  });

  @override
  State<Dateselector> createState() => _DateselectorState();
}

class _DateselectorState extends State<Dateselector> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.date_range),
        labelText: widget.inputtype,
        filled: true,
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    setState(() {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(picked!);
    });
    widget.onDateChanged?.call(); // tell the parent to rebuild
  }
}
