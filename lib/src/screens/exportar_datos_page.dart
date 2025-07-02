import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/database_provider.dart';

class ExportarDatosPage extends ConsumerWidget {
  const ExportarDatosPage({super.key});

  Future<void> _exportarExcel(BuildContext context, WidgetRef ref) async {
    try {
      // Seleccionar carpeta
      final result = await FilePicker.platform.getDirectoryPath();

      if (result == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se seleccionó ninguna carpeta.')),
          );
        }
        return;
      }

      final folderPath = result;

      final impresoras = await ref.read(impresorasDaoProvider).getAllImpresoras();
      final toners = await ref.read(toneresDaoProvider).getAll();
      final requisiciones = await ref.read(requisicionesDaoProvider).getAll();
      final mantenimientos = await ref.read(mantenimientosDaoProvider).getAll();

      final excel = Excel.createExcel();
      // Impresoras
      final sheetImp = excel['Impresoras'];
      sheetImp.appendRow([
        TextCellValue('ID'),
        TextCellValue('Marca'),
        TextCellValue('Modelo'),
        TextCellValue('Serie'),
        TextCellValue('Área'),
        TextCellValue('Estado'),
        TextCellValue('A Color'),
      ]);
      for (final i in impresoras) {
        sheetImp.appendRow([
          IntCellValue(i.id),
          TextCellValue(i.marca),
          TextCellValue(i.modelo),
          TextCellValue(i.serie),
          TextCellValue(i.area),
          TextCellValue(i.estado),
          TextCellValue(i.esAColor ? 'Sí' : 'No'),
        ]);
      }
      // Toners
      final sheetTon = excel['Toners'];
      sheetTon.appendRow([
        TextCellValue('ID'),
        TextCellValue('ImpresoraID'),
        TextCellValue('Color'),
        TextCellValue('Estado'),
      ]);
      for (final t in toners) {
        sheetTon.appendRow([
          IntCellValue(t.id),
          IntCellValue(t.impresoraId),
          TextCellValue(t.color),
          TextCellValue(t.estado),
        ]);
      }
      // Requisiciones
      final sheetReq = excel['Requisiciones'];
      sheetReq.appendRow([
        TextCellValue('ID'),
        TextCellValue('TonerID'),
        TextCellValue('Fecha Pedido'),
        TextCellValue('Fecha Estimada Entrega'),
        TextCellValue('Estado'),
      ]);
      for (final r in requisiciones) {
        sheetReq.appendRow([
          IntCellValue(r.id),
          IntCellValue(r.tonereId),
          DateCellValue(year: r.fechaPedido.year, month: r.fechaPedido.month, day: r.fechaPedido.day),
          DateCellValue(year: r.fechaEstimEntrega.year, month: r.fechaEstimEntrega.month, day: r.fechaEstimEntrega.day),
          TextCellValue(r.estado),
        ]);
      }
      // Mantenimientos
      final sheetMant = excel['Mantenimientos'];
      sheetMant.appendRow([
        TextCellValue('ID'),
        TextCellValue('ImpresoraID'),
        TextCellValue('Fecha'),
        TextCellValue('Detalle'),
        TextCellValue('Reemplazo'),
        TextCellValue('NuevaImpresoraID'),
      ]);
      for (final m in mantenimientos) {
        sheetMant.appendRow([
          IntCellValue(m.id),
          IntCellValue(m.impresoraId),
          DateCellValue(year: m.fecha.year, month: m.fecha.month, day: m.fecha.day),
          TextCellValue(m.detalle),
          TextCellValue(m.reemplazoImpresora ? 'Sí' : 'No'),
          IntCellValue(m.nuevaImpresoraId ?? 0),
        ]);
      }
      // Eliminar la hoja por defecto 'Sheet1' si existe
      if (excel.sheets.keys.contains('Sheet1')) {
        excel.delete('Sheet1');
      }
      // Guardar archivo
      final file = File('$folderPath/control_impresoras_export.xlsx');
      await file.writeAsBytes(excel.encode()!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo exportado en: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar datos: $e')),
        );
      }
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
