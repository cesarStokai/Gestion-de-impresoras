import 'package:flutter/material.dart';
import 'impresoras_page.dart';
import 'toneres_page.dart';
import 'requisiciones_page.dart';
import 'mantenimientos_page.dart';
import 'historial_page.dart'; // Asegúrate de crear este archivo

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    HistorialPage(), // Nueva página de historial
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.print, size: 32),  
            const SizedBox(width: 8),
            const Text('Control Impresoras', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
        elevation: 2,
      ),
      body: Row(
        children: [
          Container(
            color: Colors.blueGrey[50],
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() { _selectedIndex = index; });
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.asset(
                  'assets/images/logo_tokai.png',
                  height: 48,
                ),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.print), label: Text('Impresoras')),
                NavigationRailDestination(icon: Icon(Icons.inbox), label: Text('Tóneres')),
                NavigationRailDestination(icon: Icon(Icons.request_page), label: Text('Requisiciones')),
                NavigationRailDestination(icon: Icon(Icons.build), label: Text('Mantenimientos')),
                NavigationRailDestination(icon: Icon(Icons.history), label: Text('Historial')),
              ],
              labelType: NavigationRailLabelType.all,
              minWidth: 75,
              selectedIconTheme: IconThemeData(color: Colors.blue[800], size: 32),
              selectedLabelTextStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
              unselectedIconTheme: IconThemeData(color: Colors.blueGrey[300]),
              unselectedLabelTextStyle: TextStyle(color: Colors.blueGrey[400]),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}