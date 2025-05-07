
import 'package:flutter/material.dart';
import 'impresoras_page.dart';
import 'toneres_page.dart';
import 'requisiciones_page.dart';
import 'mantenimientos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = [
    ImpresorasPage(),
    ToneresPage(),
    RequisicionesPage(),
    MantenimientosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Impresoras')),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() { _selectedIndex = index; });
            },
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.print), label: Text('Impresoras')),
              NavigationRailDestination(icon: Icon(Icons.inbox), label: Text('Tóneres')),
              NavigationRailDestination(icon: Icon(Icons.request_page), label: Text('Requisiciones')),
              NavigationRailDestination(icon: Icon(Icons.build), label: Text('Mantenimientos')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}