// lib/src/services/excel_service.dart

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;
import '../models/impresora.dart';
import '../models/tonere.dart';
import '../models/requisicion.dart';
import '../models/mantenimiento.dart';

/// Servicio para CRUD incremental sobre un archivo Excel.
class ExcelService {
  late Excel _excel;
  late File _file;

  /// Inicializa el servicio apuntando al Excel en la carpeta actual.
  Future<void> init() async {
    final projectDir = Directory.current.path;
    _file = File(p.join(projectDir, 'control_impresoras.xlsx'));

    if (!_file.existsSync()) {
      // Crear plantilla con hojas en blanco
      _excel = Excel.createExcel();
      _excel.rename('Sheet1', 'Impresoras');
      _excel.rename('Sheet2', 'Toneres');
      _excel.rename('Sheet3', 'Requisiciones');
      _excel.rename('Sheet4', 'Mantenimientos');
      save();
    } else {
      final bytes = _file.readAsBytesSync();
      _excel = Excel.decodeBytes(bytes);
    }
  }

  //////////////// Impresoras //////////////////
  List<Impresora> loadImpresoras() {
    final sheet = _excel['Impresoras'];
    final rows = sheet.rows;
    final list = <Impresora>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.every((cell) => cell == null)) continue;
      list.add(Impresora(
        id: row[0]!.value as int?,
        marca: row[1]!.value.toString(),
        modelo: row[2]!.value.toString(),
        serie: row[3]!.value.toString(),
        area: row[4]!.value.toString(),
        estado: row[5]!.value.toString(),
      ));
    }
    return list;
  }

  void addImpresora(Impresora imp) {
    final sheet = _excel['Impresoras'];
    // ID incremental
    final current = loadImpresoras().map((e) => e.id ?? 0).fold(0, (p, n) => n > p ? n : p);
    imp.id = current + 1;
    // Si es primera vez, escribe encabezados
    if (sheet.rows.length < 2) {
      sheet.appendRow(['id', 'marca', 'modelo', 'serie', 'area', 'estado']);
    }
    sheet.appendRow([
      imp.id,
      imp.marca,
      imp.modelo,
      imp.serie,
      imp.area,
      imp.estado,
    ]);
    save();
  }

  void updateImpresora(Impresora imp) {
    final sheet = _excel['Impresoras'];
    for (var i = 1; i < sheet.rows.length; i++) {
      final cell = sheet.rows[i][0];
      if (cell != null && cell.value == imp.id) {
        sheet.rows[i][1]!.value = imp.marca;
        sheet.rows[i][2]!.value = imp.modelo;
        sheet.rows[i][3]!.value = imp.serie;
        sheet.rows[i][4]!.value = imp.area;
        sheet.rows[i][5]!.value = imp.estado;
        break;
      }
    }
    save();
  }

  void removeImpresora(int id) {
    final sheet = _excel['Impresoras'];
    final rows = sheet.rows;
    for (var i = 1; i < rows.length; i++) {
      if (rows[i][0]?.value == id) {
        sheet.rows.removeAt(i);
        break;
      }
    }
    save();
  }

  //////////////// Tóneres //////////////////
  List<Tonere> loadToneres() {
    final sheet = _excel['Toneres'];
    final rows = sheet.rows;
    final list = <Tonere>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.every((c) => c == null)) continue;
      list.add(Tonere(
        id: row[0]!.value as int?,
        impresoraId: row[1]!.value as int,
        color: row[2]!.value.toString(),
        estado: row[3]!.value.toString(),
        fechaInstalacion: row[4]?.value,
        fechaEstimEntrega: row[5]?.value,
        fechaEntregaReal: row[6]?.value,
      ));
    }
    return list;
  }

  void addTonere(Tonere t) {
    final sheet = _excel['Toneres'];
    final current = loadToneres().map((e) => e.id ?? 0).fold(0, (p, n) => n > p ? n : p);
    t.id = current + 1;
    if (sheet.rows.length < 2) {
      sheet.appendRow(['id','impresoraId','color','estado','fechaInstalacion','fechaEstimEntrega','fechaEntregaReal']);
    }
    sheet.appendRow([
      t.id,
      t.impresoraId,
      t.color,
      t.estado,
      t.fechaInstalacion,
      t.fechaEstimEntrega,
      t.fechaEntregaReal,
    ]);
    save();
  }

  void updateTonere(Tonere t) {
    final sheet = _excel['Toneres'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == t.id) {
        sheet.rows[i][1]!.value = t.impresoraId;
        sheet.rows[i][2]!.value = t.color;
        sheet.rows[i][3]!.value = t.estado;
        sheet.rows[i][4]!.value = t.fechaInstalacion;
        sheet.rows[i][5]!.value = t.fechaEstimEntrega;
        sheet.rows[i][6]!.value = t.fechaEntregaReal;
        break;
      }
    }
    save();
  }

  void removeTonere(int id) {
    final sheet = _excel['Toneres'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == id) {
        sheet.rows.removeAt(i);
        break;
      }
    }
    save();
  }

  //////////////// Requisiciones //////////////////
  List<Requisicion> loadRequisiciones() {
    final sheet = _excel['Requisiciones'];
    final rows = sheet.rows;
    final list = <Requisicion>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.every((c) => c == null)) continue;
      list.add(Requisicion(
        id: row[0]!.value as int?,
        tonereId: row[1]!.value as int,
        fechaPedido: row[2]!.value,
        fechaEstimEntrega: row[3]!.value,
        estado: row[4]!.value.toString(),
        proveedor: row[5]?.value,
      ));
    }
    return list;
  }

  void addRequisicion(Requisicion r) {
    final sheet = _excel['Requisiciones'];
    final current = loadRequisiciones().map((e) => e.id ?? 0).fold(0, (p, n) => n > p ? n : p);
    r.id = current + 1;
    if (sheet.rows.length < 2) {
      sheet.appendRow(['id','tonereId','fechaPedido','fechaEstimEntrega','estado','proveedor']);
    }
    sheet.appendRow([
      r.id,
      r.tonereId,
      r.fechaPedido,
      r.fechaEstimEntrega,
      r.estado,
      r.proveedor,
    ]);
    save();
  }

  void updateRequisicion(Requisicion r) {
    final sheet = _excel['Requisiciones'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == r.id) {
        sheet.rows[i][1]!.value = r.tonereId;
        sheet.rows[i][2]!.value = r.fechaPedido;
        sheet.rows[i][3]!.value = r.fechaEstimEntrega;
        sheet.rows[i][4]!.value = r.estado;
        sheet.rows[i][5]!.value = r.proveedor;
        break;
      }
    }
    save();
  }

  void removeRequisicion(int id) {
    final sheet = _excel['Requisiciones'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == id) {
        sheet.rows.removeAt(i);
        break;
      }
    }
    save();
  }

  //////////////// Mantenimientos //////////////////
  List<Mantenimiento> loadMantenimientos() {
    final sheet = _excel['Mantenimientos'];
    final rows = sheet.rows;
    final list = <Mantenimiento>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.every((c) => c == null)) continue;
      list.add(Mantenimiento(
        id: row[0]!.value as int?,
        impresoraId: row[1]!.value as int,
        fecha: row[2]!.value,
        detalle: row[3]!.value.toString(),
        reemplazoImpresora: row[4]!.value as bool,
        nuevaImpresoraId: row[5]?.value as int?,
      ));
    }
    return list;
  }

  void addMantenimiento(Mantenimiento m) {
    final sheet = _excel['Mantenimientos'];
    final current = loadMantenimientos().map((e) => e.id ?? 0).fold(0, (p, n) => n > p ? n : p);
    m.id = current + 1;
    if (sheet.rows.length < 2) {
      sheet.appendRow(['id','impresoraId','fecha','detalle','reemplazoImpresora','nuevaImpresoraId']);
    }
    sheet.appendRow([
      m.id,
      m.impresoraId,
      m.fecha,
      m.detalle,
      m.reemplazoImpresora,
      m.nuevaImpresoraId,
    ]);
    save();
  }

  void updateMantenimiento(Mantenimiento m) {
    final sheet = _excel['Mantenimientos'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == m.id) {
        sheet.rows[i][1]!.value = m.impresoraId;
        sheet.rows[i][2]!.value = m.fecha;
        sheet.rows[i][3]!.value = m.detalle;
        sheet.rows[i][4]!.value = m.reemplazoImpresora;
        sheet.rows[i][5]!.value = m.nuevaImpresoraId;
        break;
      }
    }
    save();
  }

  void removeMantenimiento(int id) {
    final sheet = _excel['Mantenimientos'];
    for (var i = 1; i < sheet.rows.length; i++) {
      if (sheet.rows[i][0]?.value == id) {
        sheet.rows.removeAt(i);
        break;
      }
    }
    save();
  }

  /// Guarda el libro en disco.
  void save() {
    final bytes = _excel.save();
    if (bytes != null) _file.writeAsBytesSync(bytes, flush: true);
  }
}