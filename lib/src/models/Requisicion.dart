import 'status_enums.dart';

class Requisicion {
  final int? id;
  final int tonereId;
  final DateTime fechaPedido;
  final DateTime fechaEstimEntrega;
  final RequisitionStatus estado;
  final String? proveedor;

  Requisicion({
    this.id,
    required this.tonereId,
    required this.fechaPedido,
    required this.fechaEstimEntrega,
    required this.estado,
    this.proveedor,
  });
}
