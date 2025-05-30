import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class ExportarDatosPage extends ConsumerWidget {
  const ExportarDatosPage({super.key});

  Future<void> _exportarExcel(BuildContext context, WidgetRef ref) async {
    final impresoras = await ref.read(impresorasDaoProvider).getAllImpresoras();
    final toners = await ref.read(toneresDaoProvider).getAll();
    final requisiciones = await ref.read(requisicionesDaoProvider).getAll();
    final mantenimientos = await ref.read(mantenimientosDaoProvider).getAll();

    final excel = Excel.createExcel();
    // Impresoras
    final sheetImp = excel['Impresoras'];
    sheetImp.appendRow([
      'ID', 'Marca', 'Modelo', 'Serie', 'Área', 'Estado', 'A Color'
    ]);
    for (final i in impresoras) {
      sheetImp.appendRow([
        i.id, i.marca, i.modelo, i.serie, i.area, i.estado, i.esAColor ? 'Sí' : 'No'
      ]);
    }
    // Toners
    final sheetTon = excel['Toners'];
    sheetTon.appendRow([
      'ID', 'ImpresoraID', 'Color', 'Estado'
    ]);
    for (final t in toners) {
      sheetTon.appendRow([
        t.id, t.impresoraId, t.color, t.estado
      ]);
    }
    // Requisiciones
    final sheetReq = excel['Requisiciones'];
    sheetReq.appendRow([
      'ID', 'TonerID', 'Fecha Pedido', 'Fecha Estimada Entrega', 'Estado'
    ]);
    for (final r in requisiciones) {
      sheetReq.appendRow([
        r.id, r.tonereId, r.fechaPedido.toIso8601String(), r.fechaEstimEntrega?.toIso8601String() ?? '', r.estado
      ]);
    }
    // Mantenimientos
    final sheetMant = excel['Mantenimientos'];
    sheetMant.appendRow([
      'ID', 'ImpresoraID', 'Fecha', 'Detalle', 'Reemplazo', 'NuevaImpresoraID'
    ]);
    for (final m in mantenimientos) {
      sheetMant.appendRow([
        m.id, m.impresoraId, m.fecha.toIso8601String(), m.detalle, m.reemplazoImpresora ? 'Sí' : 'No', m.nuevaImpresoraId ?? ''
      ]);
    }
    // Guardar archivo
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/control_impresoras_export.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Archivo exportado en: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar datos a Excel'),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Exporta todos los datos de la aplicación a un archivo Excel (.xlsx) para respaldo o análisis.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Exportar a Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _exportarExcel(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
