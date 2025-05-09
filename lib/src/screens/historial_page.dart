import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../base/database.dart'; // Solo esta importación de database.dart
import '../providers/database_provider.dart';

class HistorialPage extends ConsumerStatefulWidget {
  const HistorialPage({super.key});

  @override
  HistorialPageState createState() => HistorialPageState();
}

class HistorialPageState extends ConsumerState<HistorialPage> {
  @override
  Widget build(BuildContext context) {
    final documentosAsync = ref.watch(documentosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Archivos')),
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
              child: documentosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (List<Documento> documentos) {
                  if (documentos.isEmpty) {
                    return const Center(child: Text('No hay documentos guardados'));
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(documentosProvider.future),
                    child: ListView.builder(
                      itemCount: documentos.length,
                      itemBuilder: (context, index) {
                        final doc = documentos[index];
                        return _buildDocumentoItem(doc);
                      },
                    ),
                  );
                },
              ),
            ),
            _buildUploadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: const Text('Subir PDF'),
      onPressed: () => _uploadPdf(),
    );
  }

  Widget _buildDocumentoItem(Documento doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(doc.nombre),
        subtitle: Text('${doc.entidad} #${doc.entidadId} - ${doc.creadoEn}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => _openPdf(doc),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteDocumento(doc.id),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteDocumento(int id) async {
    try {
      final dao = ref.read(documentosDaoProvider);
      await dao.deleteById(id);
      ref.invalidate(documentosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documento eliminado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  Future<void> _uploadPdf() async {
    try {
      debugPrint('Iniciando selección de archivo...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('Usuario canceló la selección o no seleccionó archivos');
        return;
      }

      final file = result.files.first;
      debugPrint('Archivo seleccionado: ${file.name} (${file.size} bytes)');

      // Manejo alternativo para escritorio si file.bytes es null
      drift.Uint8List? fileBytes = file.bytes;
      if (fileBytes == null || fileBytes.isEmpty) {
        debugPrint('Obteniendo contenido alternativo para escritorio...');
        final filePath = file.path;
        if (filePath != null) {
          final fileData = File(filePath);
          fileBytes = await fileData.readAsBytes();
        }
      }

      if (fileBytes == null || fileBytes.isEmpty) {
        debugPrint('Archivo vacío o sin contenido');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El archivo está vacío o no se pudo leer')),
          );
        }
        return;
      }

      final entidad = await _showEntityDialog();
      if (entidad == null || !mounted) return;

      final entidadId = await _showIdDialog(entidad);
      if (entidadId == null || !mounted) return;

      final dao = ref.read(documentosDaoProvider);
      debugPrint('Preparando para insertar documento...');

      final documentoCompanion = DocumentosCompanion(
        entidad: drift.Value(entidad),
        entidadId: drift.Value(entidadId),
        nombre: drift.Value(file.name),
        contenido: drift.Value(fileBytes),
        creadoEn: drift.Value(DateTime.now()),
      );

      final id = await dao.insertOne(documentoCompanion);
      debugPrint('Documento insertado con ID: $id');

      ref.invalidate(documentosProvider);
      debugPrint('Provider invalidado, lista debería actualizarse');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${file.name} guardado correctamente (ID: $id)')),
        );
      }
    } catch (e, stack) {
      debugPrint('Error al subir PDF: $e');
      debugPrint('Stack trace: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir PDF: ${e.toString()}')),
        );
      }
    }
  }

  Future<String?> _showEntityDialog() async {
    if (!mounted) return null;
    
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asociar a'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Impresora'),
              onTap: () => Navigator.pop(context, 'Impresora'),
            ),
            ListTile(
              title: const Text('Tóner'),
              onTap: () => Navigator.pop(context, 'Tóner'),
            ),
            ListTile(
              title: const Text('Requisición'),
              onTap: () => Navigator.pop(context, 'Requisición'),
            ),
            ListTile(
              title: const Text('Mantenimiento'),
              onTap: () => Navigator.pop(context, 'Mantenimiento'),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _showIdDialog(String entidad) async {
    if (!mounted) return null;
    
    final controller = TextEditingController();
    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ID de $entidad'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final id = int.tryParse(controller.text);
              if (id != null) Navigator.pop(context, id);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPdf(Documento doc) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${doc.nombre}');
      await tempFile.writeAsBytes(doc.contenido);
      await OpenFile.open(tempFile.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al abrir PDF: $e')),
        );
      }
    }
  }
}