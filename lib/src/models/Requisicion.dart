class Requisicion {
  int? id;
  int tonereId;
  DateTime fechaPedido;
  DateTime fechaEstimEntrega;
  String estado;
  String? proveedor;

  Requisicion({
    this.id,
    required this.tonereId,
    required this.fechaPedido,
    required this.fechaEstimEntrega,
    this.estado = 'pendiente',
    this.proveedor,
  });
}