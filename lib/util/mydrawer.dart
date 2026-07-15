import 'package:flutter/material.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.filter_alt),
            title: const Text('Filter'),
            onTap: () {
              Navigator.pushNamed(context, '/filter');
            },
          ),
        ],
      ),
    );
  }
}
