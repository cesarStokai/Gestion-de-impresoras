import 'package:flutter/material.dart';
import '../src/screens/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      showPerformanceOverlay: false,

      title: 'Control Impresoras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }

  
}

