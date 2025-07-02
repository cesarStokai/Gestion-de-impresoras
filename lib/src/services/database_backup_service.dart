import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import '../utils/error_handler.dart';

class DatabaseBackupService {
  final String dbFileName;
  final String dbPath;

  DatabaseBackupService({required this.dbFileName, required this.dbPath});

  /// Exporta la base de datos SQLite a una carpeta elegida por el usuario
  Future<void> exportDatabase() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result == null) {
        ErrorHandler.showErrorGlobal('No se seleccionó ninguna carpeta.');
        return;
      }
      final sourceFile = File(p.join(dbPath, dbFileName));
      final destFile = File(p.join(result, dbFileName));
      await destFile.writeAsBytes(await sourceFile.readAsBytes());
      ErrorHandler.showSuccessGlobal('Respaldo exportado en: ${destFile.path}');
    } catch (e) {
      ErrorHandler.showErrorGlobal('Error al exportar respaldo: $e');
    }
  }

  /// Importa (restaura) una base de datos SQLite seleccionada por el usuario
  Future<void> importDatabase() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['sqlite']);
      if (result == null || result.files.isEmpty) {
        ErrorHandler.showErrorGlobal('No se seleccionó ningún archivo.');
        return;
      }
      final selectedFile = File(result.files.single.path!);
      final destFile = File(p.join(dbPath, dbFileName));
      await destFile.writeAsBytes(await selectedFile.readAsBytes(), flush: true);
      ErrorHandler.showSuccessGlobal('Base de datos restaurada. Reinicia la app para ver los cambios.');
    } catch (e) {
      ErrorHandler.showErrorGlobal('Error al importar respaldo: $e');
    }
  }
}
