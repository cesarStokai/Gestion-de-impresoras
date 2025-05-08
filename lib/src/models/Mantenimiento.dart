
class Mantenimiento {
  final int? id;
  final int impresoraId;
  final DateTime fecha;
  final String detalle;
  final bool reemplazoImpresora;
  final int? nuevaImpresoraId;

  Mantenimiento({
    this.id,
    required this.impresoraId,
    required this.fecha,
    required this.detalle,
    this.reemplazoImpresora = false,
    this.nuevaImpresoraId,
  });
}
