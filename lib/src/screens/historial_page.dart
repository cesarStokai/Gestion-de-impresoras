import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistorialPage extends ConsumerWidget {
  const HistorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Archivos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildHistorialItem('Backup completo', '2023-11-15 14:30'),
                  _buildHistorialItem('Exportación de datos', '2023-11-10 09:15'),
                  _buildHistorialItem('Importación de impresoras', '2023-11-05 16:45'),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialItem(String title, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () {
            // Acción para descargar/restaurar este archivo
          },
        ),
      ),
    );
  }
}