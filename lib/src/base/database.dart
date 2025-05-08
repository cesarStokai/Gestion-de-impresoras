import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../daos/impresoras_dao.dart';
import '../daos/toneres_dao.dart';
import '../daos/requisiciones_dao.dart';
import '../daos/mantenimientos_dao.dart';
import '../daos/documentos_dao.dart';

part 'database.g.dart';

class Impresoras extends Table {
  IntColumn get id     => integer().autoIncrement()();

  TextColumn get marca  => text().customConstraint('NOT NULL')();
  TextColumn get modelo => text().customConstraint('NOT NULL')();
  TextColumn get serie  => text().customConstraint('NOT NULL')();
  TextColumn get area   => text().customConstraint('NOT NULL')();

  // Aquí unimos NOT NULL, DEFAULT y CHECK en la misma customConstraint
  TextColumn get estado => text().customConstraint(
    "NOT NULL "
    "DEFAULT 'activa' "
    "CHECK(estado IN ('activa','pendiente_baja','baja','mantenimiento'))"
  )();
}


class Toneres extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get impresoraId => integer()
      .customConstraint('NOT NULL REFERENCES impresoras(id)')();

  TextColumn get color  => text().customConstraint('NOT NULL')();
  TextColumn get estado => text().customConstraint(
    "NOT NULL "
    "DEFAULT 'almacenado' "
    "CHECK(estado IN ('almacenado','instalado','en_pedido'))"
  )();

  DateTimeColumn get fechaInstalacion  => dateTime().nullable()();
  DateTimeColumn get fechaEstimEntrega => dateTime().nullable()();
  DateTimeColumn get fechaEntregaReal  => dateTime().nullable()();
}

class Requisiciones extends Table {
  IntColumn get id       => integer().autoIncrement()();
  IntColumn get tonereId => integer()
      .customConstraint('NOT NULL REFERENCES toneres(id)')();

  DateTimeColumn get fechaPedido       => dateTime().customConstraint('NOT NULL')();
  DateTimeColumn get fechaEstimEntrega => dateTime().customConstraint('NOT NULL')();

  TextColumn get estado => text().customConstraint(
    "NOT NULL "
    "DEFAULT 'pendiente' "
    "CHECK(estado IN ('pendiente','completada'))"
  )();

  TextColumn get proveedor => text().nullable()();
}

class Mantenimientos extends Table {
  IntColumn get id                => integer().autoIncrement()();

  @ReferenceName('origen')
  IntColumn get impresoraId       => integer()
      .customConstraint('NOT NULL REFERENCES impresoras(id)')();

  DateTimeColumn get fecha        => dateTime().customConstraint('NOT NULL')();
  TextColumn get detalle          => text().customConstraint('NOT NULL')();
  BoolColumn get reemplazoImpresora => boolean()
      .customConstraint('NOT NULL DEFAULT 0')();

  @ReferenceName('reemplazo')
  IntColumn get nuevaImpresoraId  => integer()
      .nullable()  // <-- aquí lo hacemos nullable
      .customConstraint('REFERENCES impresoras(id)')();
}

class Documentos extends Table {
  IntColumn      get id        => integer().autoIncrement()();
  TextColumn     get entidad   => text().customConstraint('NOT NULL')();
  IntColumn      get entidadId => integer().customConstraint('NOT NULL')();
  TextColumn     get nombre    => text().customConstraint('NOT NULL')();
  BlobColumn     get contenido => blob().customConstraint('NOT NULL')();
  DateTimeColumn get creadoEn  => dateTime().customConstraint(
    'NOT NULL DEFAULT CURRENT_TIMESTAMP'
  )();
}


@DriftDatabase(
  tables:  [Impresoras, Toneres, Requisiciones, Mantenimientos, Documentos],
  daos:    [ImpresorasDao, ToneresDao, RequisicionesDao, MantenimientosDao, DocumentosDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // aumentamos la versión

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir  = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'control_impresoras.sqlite'));
      return NativeDatabase(file, logStatements: true);
    });
  }
}
