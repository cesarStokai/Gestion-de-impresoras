import 'package:drift/drift.dart';
import '../base/database.dart';

part 'documentos_dao.g.dart';

@DriftAccessor(tables: [Documentos])
class DocumentosDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentosDaoMixin {
  DocumentosDao(AppDatabase db) : super(db);

  /// Observa todos los documentos almacenados.
  Stream<List<Documento>> watchAll() {
    return select(documentos).watch();
  }

  /// Observa solo los documentos de una entidad concreta.
  Stream<List<Documento>> watchFor(String entidad, int entidadId) {
    return (select(documentos)
          ..where((tbl) =>
            tbl.entidad.equals(entidad) &
            tbl.entidadId.equals(entidadId)))
        .watch();
  }

  /// Inserta un nuevo PDF.
  Future<int> insertOne(DocumentosCompanion entry) {
    return into(documentos).insert(entry);
  }

  /// Borra un PDF por su id.
  Future<int> deleteById(int id) {
    return (delete(documentos)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Borra todos los PDFs de una entidad concreta.
  Future<int> deleteFor(String entidad, int entidadId) {
    return (delete(documentos)
          ..where((tbl) =>
            tbl.entidad.equals(entidad) &
            tbl.entidadId.equals(entidadId)))
        .go();
  }
}
