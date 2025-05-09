
import 'dart:io';
import 'dart:typed_data'; // Para Uint8List
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../base/database.dart';
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
        subtitle: FutureBuilder<String>(
          future: _getEntidadNombre(doc.entidad, doc.entidadId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${doc.entidad}: ${snapshot.data}');
            }
            return Text('${doc.entidad} #${doc.entidadId} - ${doc.creadoEn}');
          },
        ),
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

  Future<String> _getEntidadNombre(String entidad, int entidadId) async {
    switch (entidad) {
      case 'Impresora':
        final impresora = await ref.read(impresorasDaoProvider).getById(entidadId);
        return impresora != null 
            ? '${impresora.marca} ${impresora.modelo}'
            : 'ID $entidadId';
      case 'Tóner':
        final toner = await ref.read(toneresDaoProvider).getById(entidadId);
        return toner != null
            ? '${toner.color ?? 'Sin modelo'} (${toner.color ?? 'Sin color'})'
            : 'ID $entidadId';
      case 'Requisición':
        final req = await ref.read(requisicionesDaoProvider).getById(entidadId);
        return req != null
            ? 'Req. #${req.id}'
            : 'ID $entidadId';
      case 'Mantenimiento':
        final mant = await ref.read(mantenimientosDaoProvider).getById(entidadId);
        return mant != null
            ? 'Mant. #${mant.id}'
            : 'ID $entidadId';
      default:
        return 'ID $entidadId';
    }
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

      Uint8List? fileBytes = file.bytes;
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

      final entidadData = await _showEntityDialog();
      if (entidadData == null || !mounted) return;

      final dao = ref.read(documentosDaoProvider);
      debugPrint('Preparando para insertar documento...');

      final documentoCompanion = DocumentosCompanion(
        entidad: drift.Value(entidadData['entidad']),
        entidadId: drift.Value(entidadData['entidadId']),
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

  Future<Map<String, dynamic>?> _showEntityDialog() async {
    if (!mounted) return null;
    
    String? selectedEntidad;
    int? selectedId;
    List<Map<String, dynamic>> entidades = [];

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Asociar documento a'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedEntidad,
                    decoration: const InputDecoration(labelText: 'Tipo de entidad *'),
                    items: const [
                      DropdownMenuItem(value: 'Impresora', child: Text('Impresora')),
                      DropdownMenuItem(value: 'Tóner', child: Text('Tóner')),
                      DropdownMenuItem(value: 'Requisición', child: Text('Requisición')),
                      DropdownMenuItem(value: 'Mantenimiento', child: Text('Mantenimiento')),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        final items = await _getEntidades(value);
                        setState(() {
                          selectedEntidad = value;
                          entidades = items;
                          selectedId = null;
                        });
                      }
                    },
                    validator: (value) => value == null ? 'Seleccione un tipo' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedId,
                    decoration: const InputDecoration(labelText: 'Seleccione la entidad *'),
                    items: entidades.map((e) => DropdownMenuItem<int>(
                      value: e['id'] as int,
                      child: Text(e['nombre']),
                    )).toList(),
                    onChanged: (value) {
                      setState(() => selectedId = value);
                    },
                    validator: (value) => value == null ? 'Seleccione una entidad' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: selectedEntidad != null && selectedId != null
                    ? () => Navigator.pop(context, {
                        'entidad': selectedEntidad!,
                        'entidadId': selectedId!,
                      })
                    : null,
                child: const Text('Seleccionar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getEntidades(String tipoEntidad) async {
    switch (tipoEntidad) {
      case 'Impresora':
        final impresoras = await ref.read(impresorasDaoProvider).getAll();
        return impresoras.map((i) => {
          'id': i.id,
          'nombre': '${i.marca} ${i.modelo} (${i.serie})'
        }).toList();
      case 'Tóner':
        final toners = await ref.read(toneresDaoProvider).getAll();
        return toners.map((t) => {
          'id': t.id,
          'nombre': '${t.color ?? 'Sin modelo'} (${t.color ?? 'Sin color'})'
        }).toList();
      case 'Requisición':
        final requisiciones = await ref.read(requisicionesDaoProvider).getAll();
        return requisiciones.map((r) => {
          'id': r.id,
          'nombre': 'Req. #${r.id} - ${r.fechaPedido.toLocal().toString().split(' ')[0]}'
        }).toList();
      case 'Mantenimiento':
        final mantenimientos = await ref.read(mantenimientosDaoProvider).getAll();
        return mantenimientos.map((m) => {
          'id': m.id,
          'nombre': 'Mant. #${m.id} - ${m.fecha.toLocal().toString().split(' ')[0]}'
        }).toList();
      default:
        return [];
    }
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