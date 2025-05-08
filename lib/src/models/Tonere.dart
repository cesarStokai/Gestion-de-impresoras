import 'status_enums.dart';

class Tonere {
  final int? id;
  final int impresoraId;
  final String color;
  final TonerStatus estado;
  final DateTime? fechaInstalacion;
  final DateTime? fechaEstimEntrega;
  final DateTime? fechaEntregaReal;

  Tonere({
    this.id,
    required this.impresoraId,
    required this.color,
    required this.estado,
    this.fechaInstalacion,
    this.fechaEstimEntrega,
    this.fechaEntregaReal,
  });
}
