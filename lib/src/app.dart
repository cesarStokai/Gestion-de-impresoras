import 'package:flutter/material.dart';
import '../src/screens/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _showSplash = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Gestor de Impresoras Tokai',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _showSplash
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_tokai.png',
                        width: 340,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Gestor de Impresoras Tokai',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tokai de México',
                        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 9, 91, 185)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const HomePage(),
    );
  }
}

