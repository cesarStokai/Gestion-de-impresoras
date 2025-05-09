import 'dart:typed_data';

class Documento {
  final int?      id;
  final String    entidad;    
  final int       entidadId;  
  final String    nombre;     
  final Uint8List contenido;  
  final DateTime  creadoEn;   

  Documento({
    this.id,
    required this.entidad,
    required this.entidadId,
    required this.nombre,
    required this.contenido,
    required this.creadoEn,
  });


  
}
