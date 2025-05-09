import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import '../base/database.dart';

part 'documentos_dao.g.dart';

@DriftAccessor(tables: [Documentos])
class DocumentosDao extends DatabaseAccessor<AppDatabase> with _$DocumentosDaoMixin {
  DocumentosDao(super.db);

  // Observa todos los documentos
  Stream<List<Documento>> watchAll() {
    debugPrint('Observando cambios en documentos');
    return select(documentos).watch();
  }

  // Inserta un documento con fecha automática
  Future<int> insertOne(DocumentosCompanion entry) async {
    try {
      final documentoCompleto = entry.copyWith(
        creadoEn: Value(DateTime.now()),
      );
      
      debugPrint('Insertando documento: ${entry.nombre.value}');
      final id = await into(documentos).insert(documentoCompleto);
      debugPrint('Documento insertado con ID: $id');
      return id;
    } catch (e, stack) {
      debugPrint('Error insertando documento: $e');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  // Obtiene todos los documentos
  Future<List<Documento>> getAll() async {
    debugPrint('Obteniendo todos los documentos');
    return await select(documentos).get();
  }

  // Borra un documento por ID
  Future<int> deleteById(int id) async {
    debugPrint('Eliminando documento con ID: $id');
    return await (delete(documentos)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Borra documentos por entidad
  Future<int> deleteFor(String entidad, int entidadId) async {
    debugPrint('Eliminando documentos de $entidad ID: $entidadId');
    return await (delete(documentos)
      ..where((tbl) => 
        tbl.entidad.equals(entidad) & 
        tbl.entidadId.equals(entidadId))
    ).go();
  }

   
}