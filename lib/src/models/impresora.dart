class Impresora {
  int? id;
  String marca, modelo, serie, area, estado;

  Impresora({
    this.id,
    required this.marca,
    required this.modelo,
    required this.serie,
    required this.area,
    this.estado = 'activa'
  });
}


