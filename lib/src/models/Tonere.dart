class Tonere {
  int? id;
  int impresoraId;
  String color;
  String estado;
  DateTime? fechaInstalacion;
  DateTime? fechaEstimEntrega;
  DateTime? fechaEntregaReal;

  Tonere({
    this.id,
    required this.impresoraId,
    required this.color,
    this.estado = 'almacenado',
    this.fechaInstalacion,
    this.fechaEstimEntrega,
    this.fechaEntregaReal,
  });
}