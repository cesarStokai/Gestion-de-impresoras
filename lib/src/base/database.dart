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
  IntColumn get id => integer().autoIncrement()();
  TextColumn get marca => text().customConstraint('NOT NULL')();
  TextColumn get modelo => text().customConstraint('NOT NULL')();
  TextColumn get serie => text().customConstraint('NOT NULL')();
  TextColumn get area => text().customConstraint('NOT NULL')();
  BoolColumn get esAColor => boolean().withDefault(const Constant(false))();
  TextColumn get estado => text().customConstraint("NOT NULL "
      "DEFAULT 'activa' "
      "CHECK(estado IN ('activa','pendiente_baja','baja','mantenimiento'))")();
}

// Tabla de modelos de tóner
class ModelosTonner extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().customConstraint('NOT NULL')();
}

// Tabla de compatibilidad modelo impresora <-> modelo tóner
class ModeloTonnerCompatible extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get modeloImpresora => text().customConstraint('NOT NULL')();
  IntColumn get modeloTonnerId => integer().customConstraint('NOT NULL REFERENCES modelos_tonner(id)')();
}

class Toneres extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get impresoraId =>
      integer().customConstraint('NOT NULL REFERENCES impresoras(id)')();
  IntColumn get modeloTonnerId => integer().nullable().customConstraint('REFERENCES modelos_tonner(id)')();
  TextColumn get color => text().customConstraint('NOT NULL')();
  TextColumn get estado => text().customConstraint("NOT NULL "
      "DEFAULT 'almacenado' "
      "CHECK(estado IN ('almacenado','instalado','en_pedido'))")();
  DateTimeColumn get fechaInstalacion => dateTime().nullable()();
  DateTimeColumn get fechaEstimEntrega => dateTime().nullable()();
  DateTimeColumn get fechaEntregaReal => dateTime().nullable()();
}


class Requisiciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tonereId =>
      integer().customConstraint('NOT NULL REFERENCES toneres(id)')();
  DateTimeColumn get fechaPedido => dateTime().customConstraint('NOT NULL')();
  DateTimeColumn get fechaEstimEntrega =>
      dateTime().customConstraint('NOT NULL')();
  TextColumn get estado => text().customConstraint("NOT NULL "
      "DEFAULT 'pendiente' "
      "CHECK(estado IN ('pendiente','completada'))")();
  TextColumn get proveedor => text().nullable()();
}

class Mantenimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('origen')
  IntColumn get impresoraId =>
      integer().customConstraint('NOT NULL REFERENCES impresoras(id)')();
  DateTimeColumn get fecha => dateTime().customConstraint('NOT NULL')();
  TextColumn get detalle => text().customConstraint('NOT NULL')();
  BoolColumn get reemplazoImpresora =>
      boolean().customConstraint('NOT NULL DEFAULT 0')();
  @ReferenceName('reemplazo')
  IntColumn get nuevaImpresoraId =>
      integer().nullable().customConstraint('REFERENCES impresoras(id)')();
}

class Documentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entidad => text().customConstraint('NOT NULL')();
  IntColumn get entidadId => integer().customConstraint('NOT NULL')();
  TextColumn get nombre => text().customConstraint('NOT NULL')();
  BlobColumn get contenido => blob().customConstraint('NOT NULL')();
  DateTimeColumn get creadoEn =>
      dateTime().customConstraint('NOT NULL DEFAULT CURRENT_TIMESTAMP')();
}

class Contadores extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get impresoraId => integer().customConstraint('NOT NULL REFERENCES impresoras(id)')();
  TextColumn get mes => text().customConstraint('NOT NULL')(); // Formato: YYYY-MM
  IntColumn get contador => integer().customConstraint('NOT NULL')();
  DateTimeColumn get fechaRegistro => dateTime().withDefault(currentDateAndTime)();
  TextColumn get observaciones => text().nullable()();
}


// --- NO-BRAKES (UPS) ---
class NoBrakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get marca => text().customConstraint('NOT NULL')();
  TextColumn get modelo => text().customConstraint('NOT NULL')();
  TextColumn get serie => text().customConstraint('NOT NULL')();
  TextColumn get ubicacion => text().customConstraint('NOT NULL')();
  TextColumn get usuarioAsignado => text().customConstraint('NOT NULL')();
  TextColumn get estado => text().withDefault(const Constant('activo')).customConstraint("NOT NULL CHECK(estado IN ('activo','en_reparacion','baja'))")();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get fechaRegistro => dateTime().withDefault(currentDateAndTime)();
}

class NoBrakeEventos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noBrakeId => integer().customConstraint('NOT NULL REFERENCES no_brakes(id)')();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get tipoEvento => text().customConstraint("NOT NULL CHECK(tipo_evento IN ('reporte','diagnostico','reparacion','baja','reasignacion'))")();
  TextColumn get descripcion => text().customConstraint('NOT NULL')();
  TextColumn get usuario => text().nullable()();
  BlobColumn get adjunto => blob().nullable()();
  TextColumn get nombreAdjunto => text().nullable()();
}

@DriftDatabase(
  tables: [Impresoras, Toneres, ModelosTonner, ModeloTonnerCompatible, Requisiciones, Mantenimientos, Documentos, Contadores, NoBrakes, NoBrakeEventos],
  daos: [
    ImpresorasDao,
    ToneresDao,
    RequisicionesDao,
    MantenimientosDao,
    DocumentosDao,
    // Puedes agregar un ContadoresDao si lo necesitas
    // DAOs para NoBrakes y NoBrakeEventos
    // (Recuerda generar el archivo .g.dart después de agregar los DAOs)
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());


  @override
 int get schemaVersion => 3; 


@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
  },
  onUpgrade: (m, from, to) async {
    if (from == 1) {
      await m.createTable(documentos);
      from = 2;
    }
    if (from == 2) {
      await m.addColumn(impresoras, impresoras.esAColor);
    }
  },
);


  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'control_impresoras.sqlite'));
      return NativeDatabase(file, logStatements: true);
    });
  }
}