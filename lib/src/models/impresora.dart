import 'status_enums.dart';

class Impresora {
  final int? id;
  final String marca;
  final String modelo;
  final String serie;
  final String area;
  final PrinterStatus estado;

  Impresora({
    this.id,
    required this.marca,
    required this.modelo,
    required this.serie,
    required this.area,
    required this.estado,
  });
}
