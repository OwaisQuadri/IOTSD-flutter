import 'package:flutter/material.dart';
import 'users.dart';

import 'locks.dart';

class Nav extends StatefulWidget {
  Nav({Key? key}) : super(key: key);

  @override
  _nameState createState() => _nameState();
}

int _selectedIndex = 0;

class _nameState extends State<Nav> {
  final List<Widget> _widgetOptions = <Widget>[
    UsersPage(),
    LocksPage(),
    Text("Logs"),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_outline),
            label: "Locks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_rounded),
            label: "Logs",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
