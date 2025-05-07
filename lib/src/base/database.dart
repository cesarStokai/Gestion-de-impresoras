// lib/src/base/database.dart

import 'dart\:io';
import 'package\:drift/drift.dart';
import 'package\:drift/native.dart';
import 'package\:path/path.dart' as p;
import 'package\:path\_provider/path\_provider.dart';

part 'database.g.dart';

// Definición de tablas
class Impresoras extends Table {
IntColumn get id     => integer().autoIncrement()();
TextColumn get marca => text()();
TextColumn get modelo=> text()();
TextColumn get serie => text()();
TextColumn get area  => text()();
TextColumn get estado=> text().withDefault(const Constant('activa'))();
}

class Toneres extends Table {
IntColumn get id                => integer().autoIncrement()();
IntColumn get impresoraId       => integer().customConstraint('REFERENCES impresoras(id)')();
TextColumn get color             => text()();
TextColumn get estado            => text().withDefault(const Constant('almacenado'))();
DateTimeColumn get fechaInstalacion  => dateTime().nullable()();
DateTimeColumn get fechaEstimEntrega => dateTime().nullable()();
DateTimeColumn get fechaEntregaReal  => dateTime().nullable()();
}

class Requisiciones extends Table {
IntColumn get id                => integer().autoIncrement()();
IntColumn get tonereId          => integer().customConstraint('REFERENCES toneres(id)')();
DateTimeColumn get fechaPedido       => dateTime()();
DateTimeColumn get fechaEstimEntrega => dateTime()();
TextColumn get estado            => text().withDefault(const Constant('pendiente'))();
TextColumn get proveedor         => text().nullable()();
}

class Mantenimientos extends Table {
IntColumn get id               => integer().autoIncrement()();
IntColumn get impresoraId      => integer().customConstraint('REFERENCES impresoras(id)')();
DateTimeColumn get fecha         => dateTime()();
TextColumn get detalle          => text()();
BoolColumn get reemplazoImpresora => boolean().withDefault(const Constant(false))();
IntColumn get nuevaImpresoraId   => integer().nullable().customConstraint('REFERENCES impresoras(id)')();
}

@DriftDatabase(
tables: \[Impresoras, Toneres, Requisiciones, Mantenimientos],
)
class AppDatabase extends \_\$AppDatabase {
AppDatabase() : super(\_openConnection());

@override
int get schemaVersion => 1;

static LazyDatabase \_openConnection() {
return LazyDatabase(() async {
final dir = await getApplicationDocumentsDirectory();
final file = File(p.join(dir.path, 'control\_impresoras.sqlite'));
return NativeDatabase.file(file, logStatements: true);
});
}
}
