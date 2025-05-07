// lib/src/providers/excel_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/excel_service.dart';
import '../models/impresora.dart';
import '../models/tonere.dart';
import '../models/requisicion.dart';
import '../models/mantenimiento.dart';

/// Proveedor del servicio de Excel (override en main.dart)
final excelServiceProvider = Provider<ExcelService>((_) => throw UnimplementedError());

// -------------------- Impresoras --------------------
final impresorasListProvider = StateNotifierProvider<ImpresorasNotifier, List<Impresora>>(
  (ref) {
    final service = ref.watch(excelServiceProvider);
    return ImpresorasNotifier(service);
  },
);

class ImpresorasNotifier extends StateNotifier<List<Impresora>> {
  final ExcelService _service;
  ImpresorasNotifier(this._service) : super([]) {
    load();
  }

  void load() {
    state = _service.loadImpresoras();
  }

  void add(Impresora imp) {
    _service.addImpresora(imp);
    state = _service.loadImpresoras();
  }

  void update(Impresora imp) {
    _service.updateImpresora(imp);
    state = _service.loadImpresoras();
  }

  void remove(int id) {
    _service.removeImpresora(id);
    state = _service.loadImpresoras();
  }
}

// -------------------- Tóneres --------------------
final toneresListProvider = StateNotifierProvider<ToneresNotifier, List<Tonere>>(
  (ref) {
    final service = ref.watch(excelServiceProvider);
    return ToneresNotifier(service);
  },
);

class ToneresNotifier extends StateNotifier<List<Tonere>> {
  final ExcelService _service;
  ToneresNotifier(this._service) : super([]) {
    load();
  }

  void load() {
    state = _service.loadToneres();
  }

  void add(Tonere t) {
    _service.addTonere(t);
    state = _service.loadToneres();
  }

  void update(Tonere t) {
    _service.updateTonere(t);
    state = _service.loadToneres();
  }

  void remove(int id) {
    _service.removeTonere(id);
    state = _service.loadToneres();
  }
}

// -------------------- Requisiciones --------------------
final requisicionesListProvider = StateNotifierProvider<RequisicionesNotifier, List<Requisicion>>(
  (ref) {
    final service = ref.watch(excelServiceProvider);
    return RequisicionesNotifier(service);
  },
);

class RequisicionesNotifier extends StateNotifier<List<Requisicion>> {
  final ExcelService _service;
  RequisicionesNotifier(this._service) : super([]) {
    load();
  }

  void load() {
    state = _service.loadRequisiciones();
  }

  void add(Requisicion r) {
    _service.addRequisicion(r);
    state = _service.loadRequisiciones();
  }

  void update(Requisicion r) {
    _service.updateRequisicion(r);
    state = _service.loadRequisiciones();
  }

  void remove(int id) {
    _service.removeRequisicion(id);
    state = _service.loadRequisiciones();
  }
}

// -------------------- Mantenimientos --------------------
final mantenimientosListProvider = StateNotifierProvider<MantenimientosNotifier, List<Mantenimiento>>(
  (ref) {
    final service = ref.watch(excelServiceProvider);
    return MantenimientosNotifier(service);
  },
);

class MantenimientosNotifier extends StateNotifier<List<Mantenimiento>> {
  final ExcelService _service;
  MantenimientosNotifier(this._service) : super([]) {
    load();
  }

  void load() {
    state = _service.loadMantenimientos();
  }

  void add(Mantenimiento m) {
    _service.addMantenimiento(m);
    state = _service.loadMantenimientos();
  }

  void update(Mantenimiento m) {
    _service.updateMantenimiento(m);
    state = _service.loadMantenimientos();
  }

  void remove(int id) {
    _service.removeMantenimiento(id);
    state = _service.loadMantenimientos();
  }
}
