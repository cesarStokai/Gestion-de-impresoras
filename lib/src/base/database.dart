import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../daos/mantenimientos_dao.dart';
import '../daos/requisiciones_dao.dart';
import '../daos/toneres_dao.dart';
import '../daos/impresoras_dao.dart';

part 'database.g.dart';  

class Impresoras extends Table {
  IntColumn get id     => integer().autoIncrement()();
  TextColumn get marca => text()();
  TextColumn get modelo=> text()();
  TextColumn get serie => text()();
  TextColumn get area  => text()();
  TextColumn get estado=> text().withDefault(const Constant('activa'))();
}

class Toneres extends Table {
  IntColumn     get id                => integer().autoIncrement()();
  IntColumn     get impresoraId       => integer().customConstraint('REFERENCES impresoras(id)')();
  TextColumn    get color             => text()();
  TextColumn    get estado            => text().withDefault(const Constant('almacenado'))();
  DateTimeColumn get fechaInstalacion  => dateTime().nullable()();
  DateTimeColumn get fechaEstimEntrega => dateTime().nullable()();
  DateTimeColumn get fechaEntregaReal  => dateTime().nullable()();
}

class Requisiciones extends Table {
  IntColumn     get id                => integer().autoIncrement()();
  IntColumn     get tonereId          => integer().customConstraint('REFERENCES toneres(id)')();
  DateTimeColumn get fechaPedido       => dateTime()();
  DateTimeColumn get fechaEstimEntrega => dateTime()();
  TextColumn    get estado            => text().withDefault(const Constant('pendiente'))();
  TextColumn    get proveedor         => text().nullable()();
}

class Mantenimientos extends Table {
  IntColumn     get id                => integer().autoIncrement()();
  IntColumn     get impresoraId       => integer().customConstraint('REFERENCES impresoras(id)')();
  DateTimeColumn get fecha             => dateTime()();
  TextColumn    get detalle           => text()();
  BoolColumn    get reemplazoImpresora=> boolean().withDefault(const Constant(false))();
  IntColumn     get nuevaImpresoraId  => integer().nullable().customConstraint('REFERENCES impresoras(id)')();
}



@DriftDatabase(
  tables:      [Impresoras, Toneres, Requisiciones, Mantenimientos],
  daos:        [ImpresorasDao, ToneresDao, RequisicionesDao, MantenimientosDao],
)
class AppDatabase extends _$AppDatabase {
AppDatabase() : super(openConnection());

@override
int get schemaVersion => 1;

static LazyDatabase openConnection() {
return LazyDatabase(() async {
final dir = await getApplicationDocumentsDirectory();
final file = p.join(dir.path, 'control_impresoras.sqlite');
return NativeDatabase(File(file), logStatements: true);
});
}
}
