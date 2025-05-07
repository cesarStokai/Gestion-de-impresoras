
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/services/excel_service.dart';
import 'src/providers/excel_provider.dart';

Future<void> main() async {
  // 1) Necesario para cualquier inicialización async antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2) Crea e inicializa el servicio de Excel
  final excelService = ExcelService();
  await excelService.init();

  // 3) Arranca la app, inyectando el servicio ya inicializado
  runApp(
    ProviderScope(
      overrides: [
        excelServiceProvider.overrideWithValue(excelService),
      ],
      child: const MyApp(),
    ),
  );
}
