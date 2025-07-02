import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/database_backup_service.dart';

class RespaldoDatosPage extends StatefulWidget {
  const RespaldoDatosPage({super.key});

  @override
  State<RespaldoDatosPage> createState() => _RespaldoDatosPageState();
}

class _RespaldoDatosPageState extends State<RespaldoDatosPage> {
  late DatabaseBackupService backupService;

  @override
  void initState() {
    super.initState();
    _initBackupService();
  }

  Future<void> _initBackupService() async {
    final dir = await getApplicationDocumentsDirectory();
    setState(() {
      backupService = DatabaseBackupService(
        dbFileName: 'control_impresoras.sqlite',
        dbPath: dir.path,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respaldo y restauración de datos'),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Puedes exportar un respaldo completo de la base de datos o restaurar uno existente.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Exportar respaldo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => backupService.exportDatabase(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Restaurar respaldo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => backupService.importDatabase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
