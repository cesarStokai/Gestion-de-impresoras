import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import '../base/database.dart';
import '../utils/error_handler.dart';

class ExcelService {
  final AppDatabase database;

  ExcelService(this.database);

  Future<void> importFromExcel(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('El archivo no existe');
      }
      if (file.uri.pathSegments.last != 'control_impresoras_export.xlsx') {
        throw Exception('Solo se permite importar desde el archivo control_impresoras_export.xlsx');
      }
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;
        for (var row in sheet.rows.skip(1)) {
          try {
            if (table == 'Impresoras') {
              if (row.length < 4) throw Exception('Fila incompleta en Impresoras');
              await database.impresorasDao.insertOne(
                ImpresorasCompanion(
                  marca: Value(row[0]?.value.toString() ?? ''),
                  modelo: Value(row[1]?.value.toString() ?? ''),
                  area: Value(row[2]?.value.toString() ?? ''),
                  serie: Value(row[3]?.value.toString() ?? ''),
                ),
              );
            } else if (table == 'Requisiciones') {
              if (row.length < 5) throw Exception('Fila incompleta en Requisiciones');
              final estado = row[3]?.value.toString() ?? '';
              if (estado != 'pendiente' && estado != 'completada') {
                throw Exception("Valor inválido en la columna 'estado': $estado. Solo se permiten 'pendiente' o 'completada'.");
              }
              final tonereId = int.tryParse(row[0]?.value.toString() ?? '0');
              final fechaPedido = DateTime.tryParse(row[1]?.value.toString() ?? '');
              final fechaEstimEntrega = DateTime.tryParse(row[2]?.value.toString() ?? '');
              if (tonereId == null || fechaPedido == null || fechaEstimEntrega == null) {
                throw Exception('Datos inválidos en Requisiciones: Verifica los tipos de datos.');
              }
              await database.requisicionesDao.insertOne(
                RequisicionesCompanion(
                  tonereId: Value(tonereId),
                  fechaPedido: Value(fechaPedido),
                  fechaEstimEntrega: Value(fechaEstimEntrega),
                  estado: Value(estado),
                  proveedor: Value(row[4]?.value.toString() ?? ''),
                ),
              );
            }
          } catch (e) {
            ErrorHandler.logError('Error en la fila: $row. Detalle: $e');
          }
        }
      }
    } catch (e) {
      ErrorHandler.showErrorGlobal('Error al importar Excel: $e');
      rethrow;
    }
  }

  Future<void> exportToExcel(String filePath) async {
    try {
      final excel = Excel.createExcel();
      // Accede o crea las hojas necesarias
      final impresorasSheet = excel['Impresoras'];
      final requisicionesSheet = excel['Requisiciones'];

      // Limpia las hojas agregando solo los encabezados y datos una vez
      impresorasSheet.appendRow([
        TextCellValue('Marca'),
        TextCellValue('Modelo'),
        TextCellValue('Área'),
        TextCellValue('Serie'),
      ]);
      final impresoras = await database.impresorasDao.getAllImpresoras();
      for (var impresora in impresoras) {
        impresorasSheet.appendRow([
          TextCellValue(impresora.marca),
          TextCellValue(impresora.modelo),
          TextCellValue(impresora.area),
          TextCellValue(impresora.serie),
        ]);
      }
      requisicionesSheet.appendRow([
        TextCellValue('Tóner ID'),
        TextCellValue('Fecha Pedido'),
        TextCellValue('Fecha Estimada Entrega'),
        TextCellValue('Estado'),
        TextCellValue('Proveedor'),
      ]);
      final requisiciones = await database.requisicionesDao.getAll();
      for (var requisicion in requisiciones) {
        requisicionesSheet.appendRow([
          TextCellValue(requisicion.tonereId.toString()),
          DateCellValue(year: requisicion.fechaPedido.year, month: requisicion.fechaPedido.month, day: requisicion.fechaPedido.day),
          DateCellValue(year: requisicion.fechaEstimEntrega.year, month: requisicion.fechaEstimEntrega.month, day: requisicion.fechaEstimEntrega.day),
          TextCellValue(requisicion.estado),
          TextCellValue(requisicion.proveedor ?? ''),
        ]);
      }
      // Elimina cualquier hoja extra que no sea las dos principales
      for (final sheetName in excel.sheets.keys.toList()) {
        if (sheetName != 'Impresoras' && sheetName != 'Requisiciones') {
          excel.delete(sheetName);
        }
      }
      final file = File(filePath);
      file.writeAsBytesSync(excel.encode()!);
    } catch (e) {
      ErrorHandler.showErrorGlobal('Error al exportar Excel: $e');
      rethrow;
    }
  }
}
