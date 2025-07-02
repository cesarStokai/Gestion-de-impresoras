import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../services/excel_service.dart';
import '../providers/database_provider.dart';
import '../utils/error_handler.dart';
import 'dart:io';

class ImportarDatosPage extends ConsumerWidget {
  const ImportarDatosPage({super.key});

  Future<void> _importarExcel(BuildContext context, WidgetRef ref) async {
    try {
      // Validación de archivo seleccionado
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null || result.files.single.path == null) {
        if (context.mounted) {
          ErrorHandler.showError(context, 'No se seleccionó ningún archivo.');
        }
        return;
      }

      final filePath = result.files.single.path!;

      // Validación de nombre de archivo
      if (!filePath.endsWith('control_impresoras_export.xlsx')) {
        if (context.mounted) {
          ErrorHandler.showError(context, 'El archivo debe ser control_impresoras_export.xlsx');
        }
        return;
      }

      final excelService = ExcelService(ref.read(databaseProvider));

      // Validación de estructura del archivo
      final file = File(filePath);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      if (!excel.tables.keys.contains('Impresoras') || !excel.tables.keys.contains('Requisiciones')) {
        if (context.mounted) {
          ErrorHandler.showError(context, 'El archivo no contiene las hojas esperadas.');
        }
        return;
      }

      // Validación de encabezados
      final impresorasSheet = excel.tables['Impresoras'];
      final requisicionesSheet = excel.tables['Requisiciones'];

      if (impresorasSheet == null || requisicionesSheet == null ||
          impresorasSheet.rows.isEmpty || requisicionesSheet.rows.isEmpty ||
          impresorasSheet.rows.first.length < 4 || requisicionesSheet.rows.first.length < 5) {
        if (context.mounted) {
          ErrorHandler.showError(context, 'Las hojas no tienen los encabezados correctos.');
        }
        return;
      }

      // Validación de datos
      for (var row in impresorasSheet.rows.skip(1)) {
        if (row[0]?.value == null || row[1]?.value == null || row[2]?.value == null || row[3]?.value == null) {
          if (context.mounted) {
            ErrorHandler.showError(context, 'Los datos de la hoja Impresoras contienen valores inválidos.');
          }
          return;
        }
      }

      for (var row in requisicionesSheet.rows.skip(1)) {
        if (row[0]?.value == null || row[1]?.value == null || row[2]?.value == null || row[3]?.value == null || row[4]?.value == null) {
          if (context.mounted) {
            ErrorHandler.showError(context, 'Los datos de la hoja Requisiciones contienen valores inválidos.');
          }
          return;
        }
      }

      // Importar datos
      await excelService.importFromExcel(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos importados exitosamente.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handleException(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar datos desde Excel'),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Importa los datos desde el archivo control_impresoras.xlsx para actualizar la base de datos.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Importar desde Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _importarExcel(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
