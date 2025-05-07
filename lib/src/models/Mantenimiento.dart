class Mantenimiento {
  int? id;
  int impresoraId;
  DateTime fecha;
  String detalle;
  bool reemplazoImpresora;
  int? nuevaImpresoraId;

  Mantenimiento({
    this.id,
    required this.impresoraId,
    required this.fecha,
    required this.detalle,
    this.reemplazoImpresora = false,
    this.nuevaImpresoraId,
  });
}