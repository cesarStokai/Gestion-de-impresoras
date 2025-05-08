// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ImpresorasTable extends Impresoras
    with TableInfo<$ImpresorasTable, Impresora> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImpresorasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
      'marca', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
      'modelo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _serieMeta = const VerificationMeta('serie');
  @override
  late final GeneratedColumn<String> serie = GeneratedColumn<String>(
      'serie', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
      'area', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'activa\' CHECK(estado IN (\'activa\',\'pendiente_baja\',\'baja\',\'mantenimiento\'))',
      defaultValue: const CustomExpression('\'activa\''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, marca, modelo, serie, area, estado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'impresoras';
  @override
  VerificationContext validateIntegrity(Insertable<Impresora> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('marca')) {
      context.handle(
          _marcaMeta, marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta));
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('serie')) {
      context.handle(
          _serieMeta, serie.isAcceptableOrUnknown(data['serie']!, _serieMeta));
    } else if (isInserting) {
      context.missing(_serieMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
          _areaMeta, area.isAcceptableOrUnknown(data['area']!, _areaMeta));
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Impresora map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Impresora(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      marca: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marca'])!,
      modelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modelo'])!,
      serie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serie'])!,
      area: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}area'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
    );
  }

  @override
  $ImpresorasTable createAlias(String alias) {
    return $ImpresorasTable(attachedDatabase, alias);
  }
}

class Impresora extends DataClass implements Insertable<Impresora> {
  final int id;
  final String marca;
  final String modelo;
  final String serie;
  final String area;
  final String estado;
  const Impresora(
      {required this.id,
      required this.marca,
      required this.modelo,
      required this.serie,
      required this.area,
      required this.estado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['serie'] = Variable<String>(serie);
    map['area'] = Variable<String>(area);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  ImpresorasCompanion toCompanion(bool nullToAbsent) {
    return ImpresorasCompanion(
      id: Value(id),
      marca: Value(marca),
      modelo: Value(modelo),
      serie: Value(serie),
      area: Value(area),
      estado: Value(estado),
    );
  }

  factory Impresora.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Impresora(
      id: serializer.fromJson<int>(json['id']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      serie: serializer.fromJson<String>(json['serie']),
      area: serializer.fromJson<String>(json['area']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'serie': serializer.toJson<String>(serie),
      'area': serializer.toJson<String>(area),
      'estado': serializer.toJson<String>(estado),
    };
  }

  Impresora copyWith(
          {int? id,
          String? marca,
          String? modelo,
          String? serie,
          String? area,
          String? estado}) =>
      Impresora(
        id: id ?? this.id,
        marca: marca ?? this.marca,
        modelo: modelo ?? this.modelo,
        serie: serie ?? this.serie,
        area: area ?? this.area,
        estado: estado ?? this.estado,
      );
  Impresora copyWithCompanion(ImpresorasCompanion data) {
    return Impresora(
      id: data.id.present ? data.id.value : this.id,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      serie: data.serie.present ? data.serie.value : this.serie,
      area: data.area.present ? data.area.value : this.area,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Impresora(')
          ..write('id: $id, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('serie: $serie, ')
          ..write('area: $area, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, marca, modelo, serie, area, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Impresora &&
          other.id == this.id &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.serie == this.serie &&
          other.area == this.area &&
          other.estado == this.estado);
}

class ImpresorasCompanion extends UpdateCompanion<Impresora> {
  final Value<int> id;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<String> serie;
  final Value<String> area;
  final Value<String> estado;
  const ImpresorasCompanion({
    this.id = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.serie = const Value.absent(),
    this.area = const Value.absent(),
    this.estado = const Value.absent(),
  });
  ImpresorasCompanion.insert({
    this.id = const Value.absent(),
    required String marca,
    required String modelo,
    required String serie,
    required String area,
    this.estado = const Value.absent(),
  })  : marca = Value(marca),
        modelo = Value(modelo),
        serie = Value(serie),
        area = Value(area);
  static Insertable<Impresora> custom({
    Expression<int>? id,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<String>? serie,
    Expression<String>? area,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (serie != null) 'serie': serie,
      if (area != null) 'area': area,
      if (estado != null) 'estado': estado,
    });
  }

  ImpresorasCompanion copyWith(
      {Value<int>? id,
      Value<String>? marca,
      Value<String>? modelo,
      Value<String>? serie,
      Value<String>? area,
      Value<String>? estado}) {
    return ImpresorasCompanion(
      id: id ?? this.id,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      serie: serie ?? this.serie,
      area: area ?? this.area,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (serie.present) {
      map['serie'] = Variable<String>(serie.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImpresorasCompanion(')
          ..write('id: $id, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('serie: $serie, ')
          ..write('area: $area, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $ToneresTable extends Toneres with TableInfo<$ToneresTable, Tonere> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToneresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _impresoraIdMeta =
      const VerificationMeta('impresoraId');
  @override
  late final GeneratedColumn<int> impresoraId = GeneratedColumn<int>(
      'impresora_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES impresoras(id)');
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'almacenado\' CHECK(estado IN (\'almacenado\',\'instalado\',\'en_pedido\'))',
      defaultValue: const CustomExpression('\'almacenado\''));
  static const VerificationMeta _fechaInstalacionMeta =
      const VerificationMeta('fechaInstalacion');
  @override
  late final GeneratedColumn<DateTime> fechaInstalacion =
      GeneratedColumn<DateTime>('fecha_instalacion', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fechaEstimEntregaMeta =
      const VerificationMeta('fechaEstimEntrega');
  @override
  late final GeneratedColumn<DateTime> fechaEstimEntrega =
      GeneratedColumn<DateTime>('fecha_estim_entrega', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fechaEntregaRealMeta =
      const VerificationMeta('fechaEntregaReal');
  @override
  late final GeneratedColumn<DateTime> fechaEntregaReal =
      GeneratedColumn<DateTime>('fecha_entrega_real', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        impresoraId,
        color,
        estado,
        fechaInstalacion,
        fechaEstimEntrega,
        fechaEntregaReal
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'toneres';
  @override
  VerificationContext validateIntegrity(Insertable<Tonere> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('impresora_id')) {
      context.handle(
          _impresoraIdMeta,
          impresoraId.isAcceptableOrUnknown(
              data['impresora_id']!, _impresoraIdMeta));
    } else if (isInserting) {
      context.missing(_impresoraIdMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('fecha_instalacion')) {
      context.handle(
          _fechaInstalacionMeta,
          fechaInstalacion.isAcceptableOrUnknown(
              data['fecha_instalacion']!, _fechaInstalacionMeta));
    }
    if (data.containsKey('fecha_estim_entrega')) {
      context.handle(
          _fechaEstimEntregaMeta,
          fechaEstimEntrega.isAcceptableOrUnknown(
              data['fecha_estim_entrega']!, _fechaEstimEntregaMeta));
    }
    if (data.containsKey('fecha_entrega_real')) {
      context.handle(
          _fechaEntregaRealMeta,
          fechaEntregaReal.isAcceptableOrUnknown(
              data['fecha_entrega_real']!, _fechaEntregaRealMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tonere map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tonere(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      impresoraId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}impresora_id'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      fechaInstalacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_instalacion']),
      fechaEstimEntrega: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_estim_entrega']),
      fechaEntregaReal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_entrega_real']),
    );
  }

  @override
  $ToneresTable createAlias(String alias) {
    return $ToneresTable(attachedDatabase, alias);
  }
}

class Tonere extends DataClass implements Insertable<Tonere> {
  final int id;
  final int impresoraId;
  final String color;
  final String estado;
  final DateTime? fechaInstalacion;
  final DateTime? fechaEstimEntrega;
  final DateTime? fechaEntregaReal;
  const Tonere(
      {required this.id,
      required this.impresoraId,
      required this.color,
      required this.estado,
      this.fechaInstalacion,
      this.fechaEstimEntrega,
      this.fechaEntregaReal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['impresora_id'] = Variable<int>(impresoraId);
    map['color'] = Variable<String>(color);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || fechaInstalacion != null) {
      map['fecha_instalacion'] = Variable<DateTime>(fechaInstalacion);
    }
    if (!nullToAbsent || fechaEstimEntrega != null) {
      map['fecha_estim_entrega'] = Variable<DateTime>(fechaEstimEntrega);
    }
    if (!nullToAbsent || fechaEntregaReal != null) {
      map['fecha_entrega_real'] = Variable<DateTime>(fechaEntregaReal);
    }
    return map;
  }

  ToneresCompanion toCompanion(bool nullToAbsent) {
    return ToneresCompanion(
      id: Value(id),
      impresoraId: Value(impresoraId),
      color: Value(color),
      estado: Value(estado),
      fechaInstalacion: fechaInstalacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaInstalacion),
      fechaEstimEntrega: fechaEstimEntrega == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaEstimEntrega),
      fechaEntregaReal: fechaEntregaReal == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaEntregaReal),
    );
  }

  factory Tonere.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tonere(
      id: serializer.fromJson<int>(json['id']),
      impresoraId: serializer.fromJson<int>(json['impresoraId']),
      color: serializer.fromJson<String>(json['color']),
      estado: serializer.fromJson<String>(json['estado']),
      fechaInstalacion:
          serializer.fromJson<DateTime?>(json['fechaInstalacion']),
      fechaEstimEntrega:
          serializer.fromJson<DateTime?>(json['fechaEstimEntrega']),
      fechaEntregaReal:
          serializer.fromJson<DateTime?>(json['fechaEntregaReal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'impresoraId': serializer.toJson<int>(impresoraId),
      'color': serializer.toJson<String>(color),
      'estado': serializer.toJson<String>(estado),
      'fechaInstalacion': serializer.toJson<DateTime?>(fechaInstalacion),
      'fechaEstimEntrega': serializer.toJson<DateTime?>(fechaEstimEntrega),
      'fechaEntregaReal': serializer.toJson<DateTime?>(fechaEntregaReal),
    };
  }

  Tonere copyWith(
          {int? id,
          int? impresoraId,
          String? color,
          String? estado,
          Value<DateTime?> fechaInstalacion = const Value.absent(),
          Value<DateTime?> fechaEstimEntrega = const Value.absent(),
          Value<DateTime?> fechaEntregaReal = const Value.absent()}) =>
      Tonere(
        id: id ?? this.id,
        impresoraId: impresoraId ?? this.impresoraId,
        color: color ?? this.color,
        estado: estado ?? this.estado,
        fechaInstalacion: fechaInstalacion.present
            ? fechaInstalacion.value
            : this.fechaInstalacion,
        fechaEstimEntrega: fechaEstimEntrega.present
            ? fechaEstimEntrega.value
            : this.fechaEstimEntrega,
        fechaEntregaReal: fechaEntregaReal.present
            ? fechaEntregaReal.value
            : this.fechaEntregaReal,
      );
  Tonere copyWithCompanion(ToneresCompanion data) {
    return Tonere(
      id: data.id.present ? data.id.value : this.id,
      impresoraId:
          data.impresoraId.present ? data.impresoraId.value : this.impresoraId,
      color: data.color.present ? data.color.value : this.color,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaInstalacion: data.fechaInstalacion.present
          ? data.fechaInstalacion.value
          : this.fechaInstalacion,
      fechaEstimEntrega: data.fechaEstimEntrega.present
          ? data.fechaEstimEntrega.value
          : this.fechaEstimEntrega,
      fechaEntregaReal: data.fechaEntregaReal.present
          ? data.fechaEntregaReal.value
          : this.fechaEntregaReal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tonere(')
          ..write('id: $id, ')
          ..write('impresoraId: $impresoraId, ')
          ..write('color: $color, ')
          ..write('estado: $estado, ')
          ..write('fechaInstalacion: $fechaInstalacion, ')
          ..write('fechaEstimEntrega: $fechaEstimEntrega, ')
          ..write('fechaEntregaReal: $fechaEntregaReal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, impresoraId, color, estado,
      fechaInstalacion, fechaEstimEntrega, fechaEntregaReal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tonere &&
          other.id == this.id &&
          other.impresoraId == this.impresoraId &&
          other.color == this.color &&
          other.estado == this.estado &&
          other.fechaInstalacion == this.fechaInstalacion &&
          other.fechaEstimEntrega == this.fechaEstimEntrega &&
          other.fechaEntregaReal == this.fechaEntregaReal);
}

class ToneresCompanion extends UpdateCompanion<Tonere> {
  final Value<int> id;
  final Value<int> impresoraId;
  final Value<String> color;
  final Value<String> estado;
  final Value<DateTime?> fechaInstalacion;
  final Value<DateTime?> fechaEstimEntrega;
  final Value<DateTime?> fechaEntregaReal;
  const ToneresCompanion({
    this.id = const Value.absent(),
    this.impresoraId = const Value.absent(),
    this.color = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaInstalacion = const Value.absent(),
    this.fechaEstimEntrega = const Value.absent(),
    this.fechaEntregaReal = const Value.absent(),
  });
  ToneresCompanion.insert({
    this.id = const Value.absent(),
    required int impresoraId,
    required String color,
    this.estado = const Value.absent(),
    this.fechaInstalacion = const Value.absent(),
    this.fechaEstimEntrega = const Value.absent(),
    this.fechaEntregaReal = const Value.absent(),
  })  : impresoraId = Value(impresoraId),
        color = Value(color);
  static Insertable<Tonere> custom({
    Expression<int>? id,
    Expression<int>? impresoraId,
    Expression<String>? color,
    Expression<String>? estado,
    Expression<DateTime>? fechaInstalacion,
    Expression<DateTime>? fechaEstimEntrega,
    Expression<DateTime>? fechaEntregaReal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (impresoraId != null) 'impresora_id': impresoraId,
      if (color != null) 'color': color,
      if (estado != null) 'estado': estado,
      if (fechaInstalacion != null) 'fecha_instalacion': fechaInstalacion,
      if (fechaEstimEntrega != null) 'fecha_estim_entrega': fechaEstimEntrega,
      if (fechaEntregaReal != null) 'fecha_entrega_real': fechaEntregaReal,
    });
  }

  ToneresCompanion copyWith(
      {Value<int>? id,
      Value<int>? impresoraId,
      Value<String>? color,
      Value<String>? estado,
      Value<DateTime?>? fechaInstalacion,
      Value<DateTime?>? fechaEstimEntrega,
      Value<DateTime?>? fechaEntregaReal}) {
    return ToneresCompanion(
      id: id ?? this.id,
      impresoraId: impresoraId ?? this.impresoraId,
      color: color ?? this.color,
      estado: estado ?? this.estado,
      fechaInstalacion: fechaInstalacion ?? this.fechaInstalacion,
      fechaEstimEntrega: fechaEstimEntrega ?? this.fechaEstimEntrega,
      fechaEntregaReal: fechaEntregaReal ?? this.fechaEntregaReal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (impresoraId.present) {
      map['impresora_id'] = Variable<int>(impresoraId.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaInstalacion.present) {
      map['fecha_instalacion'] = Variable<DateTime>(fechaInstalacion.value);
    }
    if (fechaEstimEntrega.present) {
      map['fecha_estim_entrega'] = Variable<DateTime>(fechaEstimEntrega.value);
    }
    if (fechaEntregaReal.present) {
      map['fecha_entrega_real'] = Variable<DateTime>(fechaEntregaReal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToneresCompanion(')
          ..write('id: $id, ')
          ..write('impresoraId: $impresoraId, ')
          ..write('color: $color, ')
          ..write('estado: $estado, ')
          ..write('fechaInstalacion: $fechaInstalacion, ')
          ..write('fechaEstimEntrega: $fechaEstimEntrega, ')
          ..write('fechaEntregaReal: $fechaEntregaReal')
          ..write(')'))
        .toString();
  }
}

class $RequisicionesTable extends Requisiciones
    with TableInfo<$RequisicionesTable, Requisicione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequisicionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tonereIdMeta =
      const VerificationMeta('tonereId');
  @override
  late final GeneratedColumn<int> tonereId = GeneratedColumn<int>(
      'tonere_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES toneres(id)');
  static const VerificationMeta _fechaPedidoMeta =
      const VerificationMeta('fechaPedido');
  @override
  late final GeneratedColumn<DateTime> fechaPedido = GeneratedColumn<DateTime>(
      'fecha_pedido', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _fechaEstimEntregaMeta =
      const VerificationMeta('fechaEstimEntrega');
  @override
  late final GeneratedColumn<DateTime> fechaEstimEntrega =
      GeneratedColumn<DateTime>('fecha_estim_entrega', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: true,
          $customConstraints: 'NOT NULL');
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints:
          'NOT NULL DEFAULT \'pendiente\' CHECK(estado IN (\'pendiente\',\'completada\'))',
      defaultValue: const CustomExpression('\'pendiente\''));
  static const VerificationMeta _proveedorMeta =
      const VerificationMeta('proveedor');
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
      'proveedor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tonereId, fechaPedido, fechaEstimEntrega, estado, proveedor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requisiciones';
  @override
  VerificationContext validateIntegrity(Insertable<Requisicione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tonere_id')) {
      context.handle(_tonereIdMeta,
          tonereId.isAcceptableOrUnknown(data['tonere_id']!, _tonereIdMeta));
    } else if (isInserting) {
      context.missing(_tonereIdMeta);
    }
    if (data.containsKey('fecha_pedido')) {
      context.handle(
          _fechaPedidoMeta,
          fechaPedido.isAcceptableOrUnknown(
              data['fecha_pedido']!, _fechaPedidoMeta));
    } else if (isInserting) {
      context.missing(_fechaPedidoMeta);
    }
    if (data.containsKey('fecha_estim_entrega')) {
      context.handle(
          _fechaEstimEntregaMeta,
          fechaEstimEntrega.isAcceptableOrUnknown(
              data['fecha_estim_entrega']!, _fechaEstimEntregaMeta));
    } else if (isInserting) {
      context.missing(_fechaEstimEntregaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('proveedor')) {
      context.handle(_proveedorMeta,
          proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Requisicione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Requisicione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tonereId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tonere_id'])!,
      fechaPedido: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_pedido'])!,
      fechaEstimEntrega: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}fecha_estim_entrega'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      proveedor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proveedor']),
    );
  }

  @override
  $RequisicionesTable createAlias(String alias) {
    return $RequisicionesTable(attachedDatabase, alias);
  }
}

class Requisicione extends DataClass implements Insertable<Requisicione> {
  final int id;
  final int tonereId;
  final DateTime fechaPedido;
  final DateTime fechaEstimEntrega;
  final String estado;
  final String? proveedor;
  const Requisicione(
      {required this.id,
      required this.tonereId,
      required this.fechaPedido,
      required this.fechaEstimEntrega,
      required this.estado,
      this.proveedor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tonere_id'] = Variable<int>(tonereId);
    map['fecha_pedido'] = Variable<DateTime>(fechaPedido);
    map['fecha_estim_entrega'] = Variable<DateTime>(fechaEstimEntrega);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || proveedor != null) {
      map['proveedor'] = Variable<String>(proveedor);
    }
    return map;
  }

  RequisicionesCompanion toCompanion(bool nullToAbsent) {
    return RequisicionesCompanion(
      id: Value(id),
      tonereId: Value(tonereId),
      fechaPedido: Value(fechaPedido),
      fechaEstimEntrega: Value(fechaEstimEntrega),
      estado: Value(estado),
      proveedor: proveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedor),
    );
  }

  factory Requisicione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Requisicione(
      id: serializer.fromJson<int>(json['id']),
      tonereId: serializer.fromJson<int>(json['tonereId']),
      fechaPedido: serializer.fromJson<DateTime>(json['fechaPedido']),
      fechaEstimEntrega:
          serializer.fromJson<DateTime>(json['fechaEstimEntrega']),
      estado: serializer.fromJson<String>(json['estado']),
      proveedor: serializer.fromJson<String?>(json['proveedor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tonereId': serializer.toJson<int>(tonereId),
      'fechaPedido': serializer.toJson<DateTime>(fechaPedido),
      'fechaEstimEntrega': serializer.toJson<DateTime>(fechaEstimEntrega),
      'estado': serializer.toJson<String>(estado),
      'proveedor': serializer.toJson<String?>(proveedor),
    };
  }

  Requisicione copyWith(
          {int? id,
          int? tonereId,
          DateTime? fechaPedido,
          DateTime? fechaEstimEntrega,
          String? estado,
          Value<String?> proveedor = const Value.absent()}) =>
      Requisicione(
        id: id ?? this.id,
        tonereId: tonereId ?? this.tonereId,
        fechaPedido: fechaPedido ?? this.fechaPedido,
        fechaEstimEntrega: fechaEstimEntrega ?? this.fechaEstimEntrega,
        estado: estado ?? this.estado,
        proveedor: proveedor.present ? proveedor.value : this.proveedor,
      );
  Requisicione copyWithCompanion(RequisicionesCompanion data) {
    return Requisicione(
      id: data.id.present ? data.id.value : this.id,
      tonereId: data.tonereId.present ? data.tonereId.value : this.tonereId,
      fechaPedido:
          data.fechaPedido.present ? data.fechaPedido.value : this.fechaPedido,
      fechaEstimEntrega: data.fechaEstimEntrega.present
          ? data.fechaEstimEntrega.value
          : this.fechaEstimEntrega,
      estado: data.estado.present ? data.estado.value : this.estado,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Requisicione(')
          ..write('id: $id, ')
          ..write('tonereId: $tonereId, ')
          ..write('fechaPedido: $fechaPedido, ')
          ..write('fechaEstimEntrega: $fechaEstimEntrega, ')
          ..write('estado: $estado, ')
          ..write('proveedor: $proveedor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tonereId, fechaPedido, fechaEstimEntrega, estado, proveedor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Requisicione &&
          other.id == this.id &&
          other.tonereId == this.tonereId &&
          other.fechaPedido == this.fechaPedido &&
          other.fechaEstimEntrega == this.fechaEstimEntrega &&
          other.estado == this.estado &&
          other.proveedor == this.proveedor);
}

class RequisicionesCompanion extends UpdateCompanion<Requisicione> {
  final Value<int> id;
  final Value<int> tonereId;
  final Value<DateTime> fechaPedido;
  final Value<DateTime> fechaEstimEntrega;
  final Value<String> estado;
  final Value<String?> proveedor;
  const RequisicionesCompanion({
    this.id = const Value.absent(),
    this.tonereId = const Value.absent(),
    this.fechaPedido = const Value.absent(),
    this.fechaEstimEntrega = const Value.absent(),
    this.estado = const Value.absent(),
    this.proveedor = const Value.absent(),
  });
  RequisicionesCompanion.insert({
    this.id = const Value.absent(),
    required int tonereId,
    required DateTime fechaPedido,
    required DateTime fechaEstimEntrega,
    this.estado = const Value.absent(),
    this.proveedor = const Value.absent(),
  })  : tonereId = Value(tonereId),
        fechaPedido = Value(fechaPedido),
        fechaEstimEntrega = Value(fechaEstimEntrega);
  static Insertable<Requisicione> custom({
    Expression<int>? id,
    Expression<int>? tonereId,
    Expression<DateTime>? fechaPedido,
    Expression<DateTime>? fechaEstimEntrega,
    Expression<String>? estado,
    Expression<String>? proveedor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tonereId != null) 'tonere_id': tonereId,
      if (fechaPedido != null) 'fecha_pedido': fechaPedido,
      if (fechaEstimEntrega != null) 'fecha_estim_entrega': fechaEstimEntrega,
      if (estado != null) 'estado': estado,
      if (proveedor != null) 'proveedor': proveedor,
    });
  }

  RequisicionesCompanion copyWith(
      {Value<int>? id,
      Value<int>? tonereId,
      Value<DateTime>? fechaPedido,
      Value<DateTime>? fechaEstimEntrega,
      Value<String>? estado,
      Value<String?>? proveedor}) {
    return RequisicionesCompanion(
      id: id ?? this.id,
      tonereId: tonereId ?? this.tonereId,
      fechaPedido: fechaPedido ?? this.fechaPedido,
      fechaEstimEntrega: fechaEstimEntrega ?? this.fechaEstimEntrega,
      estado: estado ?? this.estado,
      proveedor: proveedor ?? this.proveedor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tonereId.present) {
      map['tonere_id'] = Variable<int>(tonereId.value);
    }
    if (fechaPedido.present) {
      map['fecha_pedido'] = Variable<DateTime>(fechaPedido.value);
    }
    if (fechaEstimEntrega.present) {
      map['fecha_estim_entrega'] = Variable<DateTime>(fechaEstimEntrega.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequisicionesCompanion(')
          ..write('id: $id, ')
          ..write('tonereId: $tonereId, ')
          ..write('fechaPedido: $fechaPedido, ')
          ..write('fechaEstimEntrega: $fechaEstimEntrega, ')
          ..write('estado: $estado, ')
          ..write('proveedor: $proveedor')
          ..write(')'))
        .toString();
  }
}

class $MantenimientosTable extends Mantenimientos
    with TableInfo<$MantenimientosTable, Mantenimiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MantenimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _impresoraIdMeta =
      const VerificationMeta('impresoraId');
  @override
  late final GeneratedColumn<int> impresoraId = GeneratedColumn<int>(
      'impresora_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES impresoras(id)');
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _detalleMeta =
      const VerificationMeta('detalle');
  @override
  late final GeneratedColumn<String> detalle = GeneratedColumn<String>(
      'detalle', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _reemplazoImpresoraMeta =
      const VerificationMeta('reemplazoImpresora');
  @override
  late final GeneratedColumn<bool> reemplazoImpresora = GeneratedColumn<bool>(
      'reemplazo_impresora', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _nuevaImpresoraIdMeta =
      const VerificationMeta('nuevaImpresoraId');
  @override
  late final GeneratedColumn<int> nuevaImpresoraId = GeneratedColumn<int>(
      'nueva_impresora_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES impresoras(id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, impresoraId, fecha, detalle, reemplazoImpresora, nuevaImpresoraId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mantenimientos';
  @override
  VerificationContext validateIntegrity(Insertable<Mantenimiento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('impresora_id')) {
      context.handle(
          _impresoraIdMeta,
          impresoraId.isAcceptableOrUnknown(
              data['impresora_id']!, _impresoraIdMeta));
    } else if (isInserting) {
      context.missing(_impresoraIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('detalle')) {
      context.handle(_detalleMeta,
          detalle.isAcceptableOrUnknown(data['detalle']!, _detalleMeta));
    } else if (isInserting) {
      context.missing(_detalleMeta);
    }
    if (data.containsKey('reemplazo_impresora')) {
      context.handle(
          _reemplazoImpresoraMeta,
          reemplazoImpresora.isAcceptableOrUnknown(
              data['reemplazo_impresora']!, _reemplazoImpresoraMeta));
    }
    if (data.containsKey('nueva_impresora_id')) {
      context.handle(
          _nuevaImpresoraIdMeta,
          nuevaImpresoraId.isAcceptableOrUnknown(
              data['nueva_impresora_id']!, _nuevaImpresoraIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mantenimiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mantenimiento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      impresoraId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}impresora_id'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      detalle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detalle'])!,
      reemplazoImpresora: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}reemplazo_impresora'])!,
      nuevaImpresoraId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nueva_impresora_id']),
    );
  }

  @override
  $MantenimientosTable createAlias(String alias) {
    return $MantenimientosTable(attachedDatabase, alias);
  }
}

class Mantenimiento extends DataClass implements Insertable<Mantenimiento> {
  final int id;
  final int impresoraId;
  final DateTime fecha;
  final String detalle;
  final bool reemplazoImpresora;
  final int? nuevaImpresoraId;
  const Mantenimiento(
      {required this.id,
      required this.impresoraId,
      required this.fecha,
      required this.detalle,
      required this.reemplazoImpresora,
      this.nuevaImpresoraId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['impresora_id'] = Variable<int>(impresoraId);
    map['fecha'] = Variable<DateTime>(fecha);
    map['detalle'] = Variable<String>(detalle);
    map['reemplazo_impresora'] = Variable<bool>(reemplazoImpresora);
    if (!nullToAbsent || nuevaImpresoraId != null) {
      map['nueva_impresora_id'] = Variable<int>(nuevaImpresoraId);
    }
    return map;
  }

  MantenimientosCompanion toCompanion(bool nullToAbsent) {
    return MantenimientosCompanion(
      id: Value(id),
      impresoraId: Value(impresoraId),
      fecha: Value(fecha),
      detalle: Value(detalle),
      reemplazoImpresora: Value(reemplazoImpresora),
      nuevaImpresoraId: nuevaImpresoraId == null && nullToAbsent
          ? const Value.absent()
          : Value(nuevaImpresoraId),
    );
  }

  factory Mantenimiento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mantenimiento(
      id: serializer.fromJson<int>(json['id']),
      impresoraId: serializer.fromJson<int>(json['impresoraId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      detalle: serializer.fromJson<String>(json['detalle']),
      reemplazoImpresora: serializer.fromJson<bool>(json['reemplazoImpresora']),
      nuevaImpresoraId: serializer.fromJson<int?>(json['nuevaImpresoraId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'impresoraId': serializer.toJson<int>(impresoraId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'detalle': serializer.toJson<String>(detalle),
      'reemplazoImpresora': serializer.toJson<bool>(reemplazoImpresora),
      'nuevaImpresoraId': serializer.toJson<int?>(nuevaImpresoraId),
    };
  }

  Mantenimiento copyWith(
          {int? id,
          int? impresoraId,
          DateTime? fecha,
          String? detalle,
          bool? reemplazoImpresora,
          Value<int?> nuevaImpresoraId = const Value.absent()}) =>
      Mantenimiento(
        id: id ?? this.id,
        impresoraId: impresoraId ?? this.impresoraId,
        fecha: fecha ?? this.fecha,
        detalle: detalle ?? this.detalle,
        reemplazoImpresora: reemplazoImpresora ?? this.reemplazoImpresora,
        nuevaImpresoraId: nuevaImpresoraId.present
            ? nuevaImpresoraId.value
            : this.nuevaImpresoraId,
      );
  Mantenimiento copyWithCompanion(MantenimientosCompanion data) {
    return Mantenimiento(
      id: data.id.present ? data.id.value : this.id,
      impresoraId:
          data.impresoraId.present ? data.impresoraId.value : this.impresoraId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      detalle: data.detalle.present ? data.detalle.value : this.detalle,
      reemplazoImpresora: data.reemplazoImpresora.present
          ? data.reemplazoImpresora.value
          : this.reemplazoImpresora,
      nuevaImpresoraId: data.nuevaImpresoraId.present
          ? data.nuevaImpresoraId.value
          : this.nuevaImpresoraId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mantenimiento(')
          ..write('id: $id, ')
          ..write('impresoraId: $impresoraId, ')
          ..write('fecha: $fecha, ')
          ..write('detalle: $detalle, ')
          ..write('reemplazoImpresora: $reemplazoImpresora, ')
          ..write('nuevaImpresoraId: $nuevaImpresoraId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, impresoraId, fecha, detalle, reemplazoImpresora, nuevaImpresoraId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mantenimiento &&
          other.id == this.id &&
          other.impresoraId == this.impresoraId &&
          other.fecha == this.fecha &&
          other.detalle == this.detalle &&
          other.reemplazoImpresora == this.reemplazoImpresora &&
          other.nuevaImpresoraId == this.nuevaImpresoraId);
}

class MantenimientosCompanion extends UpdateCompanion<Mantenimiento> {
  final Value<int> id;
  final Value<int> impresoraId;
  final Value<DateTime> fecha;
  final Value<String> detalle;
  final Value<bool> reemplazoImpresora;
  final Value<int?> nuevaImpresoraId;
  const MantenimientosCompanion({
    this.id = const Value.absent(),
    this.impresoraId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.detalle = const Value.absent(),
    this.reemplazoImpresora = const Value.absent(),
    this.nuevaImpresoraId = const Value.absent(),
  });
  MantenimientosCompanion.insert({
    this.id = const Value.absent(),
    required int impresoraId,
    required DateTime fecha,
    required String detalle,
    this.reemplazoImpresora = const Value.absent(),
    this.nuevaImpresoraId = const Value.absent(),
  })  : impresoraId = Value(impresoraId),
        fecha = Value(fecha),
        detalle = Value(detalle);
  static Insertable<Mantenimiento> custom({
    Expression<int>? id,
    Expression<int>? impresoraId,
    Expression<DateTime>? fecha,
    Expression<String>? detalle,
    Expression<bool>? reemplazoImpresora,
    Expression<int>? nuevaImpresoraId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (impresoraId != null) 'impresora_id': impresoraId,
      if (fecha != null) 'fecha': fecha,
      if (detalle != null) 'detalle': detalle,
      if (reemplazoImpresora != null) 'reemplazo_impresora': reemplazoImpresora,
      if (nuevaImpresoraId != null) 'nueva_impresora_id': nuevaImpresoraId,
    });
  }

  MantenimientosCompanion copyWith(
      {Value<int>? id,
      Value<int>? impresoraId,
      Value<DateTime>? fecha,
      Value<String>? detalle,
      Value<bool>? reemplazoImpresora,
      Value<int?>? nuevaImpresoraId}) {
    return MantenimientosCompanion(
      id: id ?? this.id,
      impresoraId: impresoraId ?? this.impresoraId,
      fecha: fecha ?? this.fecha,
      detalle: detalle ?? this.detalle,
      reemplazoImpresora: reemplazoImpresora ?? this.reemplazoImpresora,
      nuevaImpresoraId: nuevaImpresoraId ?? this.nuevaImpresoraId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (impresoraId.present) {
      map['impresora_id'] = Variable<int>(impresoraId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (detalle.present) {
      map['detalle'] = Variable<String>(detalle.value);
    }
    if (reemplazoImpresora.present) {
      map['reemplazo_impresora'] = Variable<bool>(reemplazoImpresora.value);
    }
    if (nuevaImpresoraId.present) {
      map['nueva_impresora_id'] = Variable<int>(nuevaImpresoraId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MantenimientosCompanion(')
          ..write('id: $id, ')
          ..write('impresoraId: $impresoraId, ')
          ..write('fecha: $fecha, ')
          ..write('detalle: $detalle, ')
          ..write('reemplazoImpresora: $reemplazoImpresora, ')
          ..write('nuevaImpresoraId: $nuevaImpresoraId')
          ..write(')'))
        .toString();
  }
}

class $DocumentosTable extends Documentos
    with TableInfo<$DocumentosTable, Documento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entidadMeta =
      const VerificationMeta('entidad');
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
      'entidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _entidadIdMeta =
      const VerificationMeta('entidadId');
  @override
  late final GeneratedColumn<int> entidadId = GeneratedColumn<int>(
      'entidad_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _contenidoMeta =
      const VerificationMeta('contenido');
  @override
  late final GeneratedColumn<Uint8List> contenido = GeneratedColumn<Uint8List>(
      'contenido', aliasedName, false,
      type: DriftSqlType.blob,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _creadoEnMeta =
      const VerificationMeta('creadoEn');
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
      'creado_en', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT CURRENT_TIMESTAMP',
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, entidad, entidadId, nombre, contenido, creadoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documentos';
  @override
  VerificationContext validateIntegrity(Insertable<Documento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entidad')) {
      context.handle(_entidadMeta,
          entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta));
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    if (data.containsKey('entidad_id')) {
      context.handle(_entidadIdMeta,
          entidadId.isAcceptableOrUnknown(data['entidad_id']!, _entidadIdMeta));
    } else if (isInserting) {
      context.missing(_entidadIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('contenido')) {
      context.handle(_contenidoMeta,
          contenido.isAcceptableOrUnknown(data['contenido']!, _contenidoMeta));
    } else if (isInserting) {
      context.missing(_contenidoMeta);
    }
    if (data.containsKey('creado_en')) {
      context.handle(_creadoEnMeta,
          creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Documento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Documento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidad'])!,
      entidadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entidad_id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      contenido: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}contenido'])!,
      creadoEn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}creado_en'])!,
    );
  }

  @override
  $DocumentosTable createAlias(String alias) {
    return $DocumentosTable(attachedDatabase, alias);
  }
}

class Documento extends DataClass implements Insertable<Documento> {
  final int id;
  final String entidad;
  final int entidadId;
  final String nombre;
  final Uint8List contenido;
  final DateTime creadoEn;
  const Documento(
      {required this.id,
      required this.entidad,
      required this.entidadId,
      required this.nombre,
      required this.contenido,
      required this.creadoEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entidad'] = Variable<String>(entidad);
    map['entidad_id'] = Variable<int>(entidadId);
    map['nombre'] = Variable<String>(nombre);
    map['contenido'] = Variable<Uint8List>(contenido);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  DocumentosCompanion toCompanion(bool nullToAbsent) {
    return DocumentosCompanion(
      id: Value(id),
      entidad: Value(entidad),
      entidadId: Value(entidadId),
      nombre: Value(nombre),
      contenido: Value(contenido),
      creadoEn: Value(creadoEn),
    );
  }

  factory Documento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Documento(
      id: serializer.fromJson<int>(json['id']),
      entidad: serializer.fromJson<String>(json['entidad']),
      entidadId: serializer.fromJson<int>(json['entidadId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      contenido: serializer.fromJson<Uint8List>(json['contenido']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entidad': serializer.toJson<String>(entidad),
      'entidadId': serializer.toJson<int>(entidadId),
      'nombre': serializer.toJson<String>(nombre),
      'contenido': serializer.toJson<Uint8List>(contenido),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Documento copyWith(
          {int? id,
          String? entidad,
          int? entidadId,
          String? nombre,
          Uint8List? contenido,
          DateTime? creadoEn}) =>
      Documento(
        id: id ?? this.id,
        entidad: entidad ?? this.entidad,
        entidadId: entidadId ?? this.entidadId,
        nombre: nombre ?? this.nombre,
        contenido: contenido ?? this.contenido,
        creadoEn: creadoEn ?? this.creadoEn,
      );
  Documento copyWithCompanion(DocumentosCompanion data) {
    return Documento(
      id: data.id.present ? data.id.value : this.id,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
      entidadId: data.entidadId.present ? data.entidadId.value : this.entidadId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      contenido: data.contenido.present ? data.contenido.value : this.contenido,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Documento(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('nombre: $nombre, ')
          ..write('contenido: $contenido, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entidad, entidadId, nombre,
      $driftBlobEquality.hash(contenido), creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Documento &&
          other.id == this.id &&
          other.entidad == this.entidad &&
          other.entidadId == this.entidadId &&
          other.nombre == this.nombre &&
          $driftBlobEquality.equals(other.contenido, this.contenido) &&
          other.creadoEn == this.creadoEn);
}

class DocumentosCompanion extends UpdateCompanion<Documento> {
  final Value<int> id;
  final Value<String> entidad;
  final Value<int> entidadId;
  final Value<String> nombre;
  final Value<Uint8List> contenido;
  final Value<DateTime> creadoEn;
  const DocumentosCompanion({
    this.id = const Value.absent(),
    this.entidad = const Value.absent(),
    this.entidadId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.contenido = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  DocumentosCompanion.insert({
    this.id = const Value.absent(),
    required String entidad,
    required int entidadId,
    required String nombre,
    required Uint8List contenido,
    this.creadoEn = const Value.absent(),
  })  : entidad = Value(entidad),
        entidadId = Value(entidadId),
        nombre = Value(nombre),
        contenido = Value(contenido);
  static Insertable<Documento> custom({
    Expression<int>? id,
    Expression<String>? entidad,
    Expression<int>? entidadId,
    Expression<String>? nombre,
    Expression<Uint8List>? contenido,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidad != null) 'entidad': entidad,
      if (entidadId != null) 'entidad_id': entidadId,
      if (nombre != null) 'nombre': nombre,
      if (contenido != null) 'contenido': contenido,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  DocumentosCompanion copyWith(
      {Value<int>? id,
      Value<String>? entidad,
      Value<int>? entidadId,
      Value<String>? nombre,
      Value<Uint8List>? contenido,
      Value<DateTime>? creadoEn}) {
    return DocumentosCompanion(
      id: id ?? this.id,
      entidad: entidad ?? this.entidad,
      entidadId: entidadId ?? this.entidadId,
      nombre: nombre ?? this.nombre,
      contenido: contenido ?? this.contenido,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    if (entidadId.present) {
      map['entidad_id'] = Variable<int>(entidadId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (contenido.present) {
      map['contenido'] = Variable<Uint8List>(contenido.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentosCompanion(')
          ..write('id: $id, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('nombre: $nombre, ')
          ..write('contenido: $contenido, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ImpresorasTable impresoras = $ImpresorasTable(this);
  late final $ToneresTable toneres = $ToneresTable(this);
  late final $RequisicionesTable requisiciones = $RequisicionesTable(this);
  late final $MantenimientosTable mantenimientos = $MantenimientosTable(this);
  late final $DocumentosTable documentos = $DocumentosTable(this);
  late final ImpresorasDao impresorasDao = ImpresorasDao(this as AppDatabase);
  late final ToneresDao toneresDao = ToneresDao(this as AppDatabase);
  late final RequisicionesDao requisicionesDao =
      RequisicionesDao(this as AppDatabase);
  late final MantenimientosDao mantenimientosDao =
      MantenimientosDao(this as AppDatabase);
  late final DocumentosDao documentosDao = DocumentosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [impresoras, toneres, requisiciones, mantenimientos, documentos];
}

typedef $$ImpresorasTableCreateCompanionBuilder = ImpresorasCompanion Function({
  Value<int> id,
  required String marca,
  required String modelo,
  required String serie,
  required String area,
  Value<String> estado,
});
typedef $$ImpresorasTableUpdateCompanionBuilder = ImpresorasCompanion Function({
  Value<int> id,
  Value<String> marca,
  Value<String> modelo,
  Value<String> serie,
  Value<String> area,
  Value<String> estado,
});

final class $$ImpresorasTableReferences
    extends BaseReferences<_$AppDatabase, $ImpresorasTable, Impresora> {
  $$ImpresorasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ToneresTable, List<Tonere>> _toneresRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.toneres,
          aliasName:
              $_aliasNameGenerator(db.impresoras.id, db.toneres.impresoraId));

  $$ToneresTableProcessedTableManager get toneresRefs {
    final manager = $$ToneresTableTableManager($_db, $_db.toneres)
        .filter((f) => f.impresoraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_toneresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MantenimientosTable, List<Mantenimiento>>
      _origenTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mantenimientos,
              aliasName: $_aliasNameGenerator(
                  db.impresoras.id, db.mantenimientos.impresoraId));

  $$MantenimientosTableProcessedTableManager get origen {
    final manager = $$MantenimientosTableTableManager($_db, $_db.mantenimientos)
        .filter((f) => f.impresoraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_origenTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MantenimientosTable, List<Mantenimiento>>
      _reemplazoTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mantenimientos,
              aliasName: $_aliasNameGenerator(
                  db.impresoras.id, db.mantenimientos.nuevaImpresoraId));

  $$MantenimientosTableProcessedTableManager get reemplazo {
    final manager = $$MantenimientosTableTableManager($_db, $_db.mantenimientos)
        .filter(
            (f) => f.nuevaImpresoraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reemplazoTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ImpresorasTableFilterComposer
    extends Composer<_$AppDatabase, $ImpresorasTable> {
  $$ImpresorasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serie => $composableBuilder(
      column: $table.serie, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get area => $composableBuilder(
      column: $table.area, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  Expression<bool> toneresRefs(
      Expression<bool> Function($$ToneresTableFilterComposer f) f) {
    final $$ToneresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.toneres,
        getReferencedColumn: (t) => t.impresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ToneresTableFilterComposer(
              $db: $db,
              $table: $db.toneres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> origen(
      Expression<bool> Function($$MantenimientosTableFilterComposer f) f) {
    final $$MantenimientosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mantenimientos,
        getReferencedColumn: (t) => t.impresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MantenimientosTableFilterComposer(
              $db: $db,
              $table: $db.mantenimientos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reemplazo(
      Expression<bool> Function($$MantenimientosTableFilterComposer f) f) {
    final $$MantenimientosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mantenimientos,
        getReferencedColumn: (t) => t.nuevaImpresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MantenimientosTableFilterComposer(
              $db: $db,
              $table: $db.mantenimientos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImpresorasTableOrderingComposer
    extends Composer<_$AppDatabase, $ImpresorasTable> {
  $$ImpresorasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serie => $composableBuilder(
      column: $table.serie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get area => $composableBuilder(
      column: $table.area, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));
}

class $$ImpresorasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImpresorasTable> {
  $$ImpresorasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<String> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  Expression<T> toneresRefs<T extends Object>(
      Expression<T> Function($$ToneresTableAnnotationComposer a) f) {
    final $$ToneresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.toneres,
        getReferencedColumn: (t) => t.impresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ToneresTableAnnotationComposer(
              $db: $db,
              $table: $db.toneres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> origen<T extends Object>(
      Expression<T> Function($$MantenimientosTableAnnotationComposer a) f) {
    final $$MantenimientosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mantenimientos,
        getReferencedColumn: (t) => t.impresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MantenimientosTableAnnotationComposer(
              $db: $db,
              $table: $db.mantenimientos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reemplazo<T extends Object>(
      Expression<T> Function($$MantenimientosTableAnnotationComposer a) f) {
    final $$MantenimientosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mantenimientos,
        getReferencedColumn: (t) => t.nuevaImpresoraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MantenimientosTableAnnotationComposer(
              $db: $db,
              $table: $db.mantenimientos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ImpresorasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ImpresorasTable,
    Impresora,
    $$ImpresorasTableFilterComposer,
    $$ImpresorasTableOrderingComposer,
    $$ImpresorasTableAnnotationComposer,
    $$ImpresorasTableCreateCompanionBuilder,
    $$ImpresorasTableUpdateCompanionBuilder,
    (Impresora, $$ImpresorasTableReferences),
    Impresora,
    PrefetchHooks Function({bool toneresRefs, bool origen, bool reemplazo})> {
  $$ImpresorasTableTableManager(_$AppDatabase db, $ImpresorasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImpresorasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImpresorasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImpresorasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> marca = const Value.absent(),
            Value<String> modelo = const Value.absent(),
            Value<String> serie = const Value.absent(),
            Value<String> area = const Value.absent(),
            Value<String> estado = const Value.absent(),
          }) =>
              ImpresorasCompanion(
            id: id,
            marca: marca,
            modelo: modelo,
            serie: serie,
            area: area,
            estado: estado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String marca,
            required String modelo,
            required String serie,
            required String area,
            Value<String> estado = const Value.absent(),
          }) =>
              ImpresorasCompanion.insert(
            id: id,
            marca: marca,
            modelo: modelo,
            serie: serie,
            area: area,
            estado: estado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ImpresorasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {toneresRefs = false, origen = false, reemplazo = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (toneresRefs) db.toneres,
                if (origen) db.mantenimientos,
                if (reemplazo) db.mantenimientos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (toneresRefs)
                    await $_getPrefetchedData<Impresora, $ImpresorasTable,
                            Tonere>(
                        currentTable: table,
                        referencedTable:
                            $$ImpresorasTableReferences._toneresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImpresorasTableReferences(db, table, p0)
                                .toneresRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.impresoraId == item.id),
                        typedResults: items),
                  if (origen)
                    await $_getPrefetchedData<Impresora, $ImpresorasTable,
                            Mantenimiento>(
                        currentTable: table,
                        referencedTable:
                            $$ImpresorasTableReferences._origenTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImpresorasTableReferences(db, table, p0).origen,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.impresoraId == item.id),
                        typedResults: items),
                  if (reemplazo)
                    await $_getPrefetchedData<Impresora, $ImpresorasTable,
                            Mantenimiento>(
                        currentTable: table,
                        referencedTable:
                            $$ImpresorasTableReferences._reemplazoTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ImpresorasTableReferences(db, table, p0)
                                .reemplazo,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.nuevaImpresoraId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ImpresorasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ImpresorasTable,
    Impresora,
    $$ImpresorasTableFilterComposer,
    $$ImpresorasTableOrderingComposer,
    $$ImpresorasTableAnnotationComposer,
    $$ImpresorasTableCreateCompanionBuilder,
    $$ImpresorasTableUpdateCompanionBuilder,
    (Impresora, $$ImpresorasTableReferences),
    Impresora,
    PrefetchHooks Function({bool toneresRefs, bool origen, bool reemplazo})>;
typedef $$ToneresTableCreateCompanionBuilder = ToneresCompanion Function({
  Value<int> id,
  required int impresoraId,
  required String color,
  Value<String> estado,
  Value<DateTime?> fechaInstalacion,
  Value<DateTime?> fechaEstimEntrega,
  Value<DateTime?> fechaEntregaReal,
});
typedef $$ToneresTableUpdateCompanionBuilder = ToneresCompanion Function({
  Value<int> id,
  Value<int> impresoraId,
  Value<String> color,
  Value<String> estado,
  Value<DateTime?> fechaInstalacion,
  Value<DateTime?> fechaEstimEntrega,
  Value<DateTime?> fechaEntregaReal,
});

final class $$ToneresTableReferences
    extends BaseReferences<_$AppDatabase, $ToneresTable, Tonere> {
  $$ToneresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ImpresorasTable _impresoraIdTable(_$AppDatabase db) =>
      db.impresoras.createAlias(
          $_aliasNameGenerator(db.toneres.impresoraId, db.impresoras.id));

  $$ImpresorasTableProcessedTableManager get impresoraId {
    final $_column = $_itemColumn<int>('impresora_id')!;

    final manager = $$ImpresorasTableTableManager($_db, $_db.impresoras)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_impresoraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RequisicionesTable, List<Requisicione>>
      _requisicionesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.requisiciones,
              aliasName: $_aliasNameGenerator(
                  db.toneres.id, db.requisiciones.tonereId));

  $$RequisicionesTableProcessedTableManager get requisicionesRefs {
    final manager = $$RequisicionesTableTableManager($_db, $_db.requisiciones)
        .filter((f) => f.tonereId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requisicionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ToneresTableFilterComposer
    extends Composer<_$AppDatabase, $ToneresTable> {
  $$ToneresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaInstalacion => $composableBuilder(
      column: $table.fechaInstalacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaEntregaReal => $composableBuilder(
      column: $table.fechaEntregaReal,
      builder: (column) => ColumnFilters(column));

  $$ImpresorasTableFilterComposer get impresoraId {
    final $$ImpresorasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableFilterComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> requisicionesRefs(
      Expression<bool> Function($$RequisicionesTableFilterComposer f) f) {
    final $$RequisicionesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.requisiciones,
        getReferencedColumn: (t) => t.tonereId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RequisicionesTableFilterComposer(
              $db: $db,
              $table: $db.requisiciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ToneresTableOrderingComposer
    extends Composer<_$AppDatabase, $ToneresTable> {
  $$ToneresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaInstalacion => $composableBuilder(
      column: $table.fechaInstalacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaEntregaReal => $composableBuilder(
      column: $table.fechaEntregaReal,
      builder: (column) => ColumnOrderings(column));

  $$ImpresorasTableOrderingComposer get impresoraId {
    final $$ImpresorasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableOrderingComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ToneresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToneresTable> {
  $$ToneresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInstalacion => $composableBuilder(
      column: $table.fechaInstalacion, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEntregaReal => $composableBuilder(
      column: $table.fechaEntregaReal, builder: (column) => column);

  $$ImpresorasTableAnnotationComposer get impresoraId {
    final $$ImpresorasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableAnnotationComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> requisicionesRefs<T extends Object>(
      Expression<T> Function($$RequisicionesTableAnnotationComposer a) f) {
    final $$RequisicionesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.requisiciones,
        getReferencedColumn: (t) => t.tonereId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RequisicionesTableAnnotationComposer(
              $db: $db,
              $table: $db.requisiciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ToneresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ToneresTable,
    Tonere,
    $$ToneresTableFilterComposer,
    $$ToneresTableOrderingComposer,
    $$ToneresTableAnnotationComposer,
    $$ToneresTableCreateCompanionBuilder,
    $$ToneresTableUpdateCompanionBuilder,
    (Tonere, $$ToneresTableReferences),
    Tonere,
    PrefetchHooks Function({bool impresoraId, bool requisicionesRefs})> {
  $$ToneresTableTableManager(_$AppDatabase db, $ToneresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToneresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToneresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToneresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> impresoraId = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime?> fechaInstalacion = const Value.absent(),
            Value<DateTime?> fechaEstimEntrega = const Value.absent(),
            Value<DateTime?> fechaEntregaReal = const Value.absent(),
          }) =>
              ToneresCompanion(
            id: id,
            impresoraId: impresoraId,
            color: color,
            estado: estado,
            fechaInstalacion: fechaInstalacion,
            fechaEstimEntrega: fechaEstimEntrega,
            fechaEntregaReal: fechaEntregaReal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int impresoraId,
            required String color,
            Value<String> estado = const Value.absent(),
            Value<DateTime?> fechaInstalacion = const Value.absent(),
            Value<DateTime?> fechaEstimEntrega = const Value.absent(),
            Value<DateTime?> fechaEntregaReal = const Value.absent(),
          }) =>
              ToneresCompanion.insert(
            id: id,
            impresoraId: impresoraId,
            color: color,
            estado: estado,
            fechaInstalacion: fechaInstalacion,
            fechaEstimEntrega: fechaEstimEntrega,
            fechaEntregaReal: fechaEntregaReal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ToneresTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {impresoraId = false, requisicionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (requisicionesRefs) db.requisiciones
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (impresoraId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.impresoraId,
                    referencedTable:
                        $$ToneresTableReferences._impresoraIdTable(db),
                    referencedColumn:
                        $$ToneresTableReferences._impresoraIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (requisicionesRefs)
                    await $_getPrefetchedData<Tonere, $ToneresTable,
                            Requisicione>(
                        currentTable: table,
                        referencedTable: $$ToneresTableReferences
                            ._requisicionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ToneresTableReferences(db, table, p0)
                                .requisicionesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tonereId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ToneresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ToneresTable,
    Tonere,
    $$ToneresTableFilterComposer,
    $$ToneresTableOrderingComposer,
    $$ToneresTableAnnotationComposer,
    $$ToneresTableCreateCompanionBuilder,
    $$ToneresTableUpdateCompanionBuilder,
    (Tonere, $$ToneresTableReferences),
    Tonere,
    PrefetchHooks Function({bool impresoraId, bool requisicionesRefs})>;
typedef $$RequisicionesTableCreateCompanionBuilder = RequisicionesCompanion
    Function({
  Value<int> id,
  required int tonereId,
  required DateTime fechaPedido,
  required DateTime fechaEstimEntrega,
  Value<String> estado,
  Value<String?> proveedor,
});
typedef $$RequisicionesTableUpdateCompanionBuilder = RequisicionesCompanion
    Function({
  Value<int> id,
  Value<int> tonereId,
  Value<DateTime> fechaPedido,
  Value<DateTime> fechaEstimEntrega,
  Value<String> estado,
  Value<String?> proveedor,
});

final class $$RequisicionesTableReferences
    extends BaseReferences<_$AppDatabase, $RequisicionesTable, Requisicione> {
  $$RequisicionesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ToneresTable _tonereIdTable(_$AppDatabase db) =>
      db.toneres.createAlias(
          $_aliasNameGenerator(db.requisiciones.tonereId, db.toneres.id));

  $$ToneresTableProcessedTableManager get tonereId {
    final $_column = $_itemColumn<int>('tonere_id')!;

    final manager = $$ToneresTableTableManager($_db, $_db.toneres)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tonereIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RequisicionesTableFilterComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaPedido => $composableBuilder(
      column: $table.fechaPedido, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedor => $composableBuilder(
      column: $table.proveedor, builder: (column) => ColumnFilters(column));

  $$ToneresTableFilterComposer get tonereId {
    final $$ToneresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tonereId,
        referencedTable: $db.toneres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ToneresTableFilterComposer(
              $db: $db,
              $table: $db.toneres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RequisicionesTableOrderingComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaPedido => $composableBuilder(
      column: $table.fechaPedido, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedor => $composableBuilder(
      column: $table.proveedor, builder: (column) => ColumnOrderings(column));

  $$ToneresTableOrderingComposer get tonereId {
    final $$ToneresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tonereId,
        referencedTable: $db.toneres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ToneresTableOrderingComposer(
              $db: $db,
              $table: $db.toneres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RequisicionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaPedido => $composableBuilder(
      column: $table.fechaPedido, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEstimEntrega => $composableBuilder(
      column: $table.fechaEstimEntrega, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  $$ToneresTableAnnotationComposer get tonereId {
    final $$ToneresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tonereId,
        referencedTable: $db.toneres,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ToneresTableAnnotationComposer(
              $db: $db,
              $table: $db.toneres,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RequisicionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RequisicionesTable,
    Requisicione,
    $$RequisicionesTableFilterComposer,
    $$RequisicionesTableOrderingComposer,
    $$RequisicionesTableAnnotationComposer,
    $$RequisicionesTableCreateCompanionBuilder,
    $$RequisicionesTableUpdateCompanionBuilder,
    (Requisicione, $$RequisicionesTableReferences),
    Requisicione,
    PrefetchHooks Function({bool tonereId})> {
  $$RequisicionesTableTableManager(_$AppDatabase db, $RequisicionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequisicionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequisicionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequisicionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tonereId = const Value.absent(),
            Value<DateTime> fechaPedido = const Value.absent(),
            Value<DateTime> fechaEstimEntrega = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> proveedor = const Value.absent(),
          }) =>
              RequisicionesCompanion(
            id: id,
            tonereId: tonereId,
            fechaPedido: fechaPedido,
            fechaEstimEntrega: fechaEstimEntrega,
            estado: estado,
            proveedor: proveedor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tonereId,
            required DateTime fechaPedido,
            required DateTime fechaEstimEntrega,
            Value<String> estado = const Value.absent(),
            Value<String?> proveedor = const Value.absent(),
          }) =>
              RequisicionesCompanion.insert(
            id: id,
            tonereId: tonereId,
            fechaPedido: fechaPedido,
            fechaEstimEntrega: fechaEstimEntrega,
            estado: estado,
            proveedor: proveedor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RequisicionesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tonereId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tonereId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tonereId,
                    referencedTable:
                        $$RequisicionesTableReferences._tonereIdTable(db),
                    referencedColumn:
                        $$RequisicionesTableReferences._tonereIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RequisicionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RequisicionesTable,
    Requisicione,
    $$RequisicionesTableFilterComposer,
    $$RequisicionesTableOrderingComposer,
    $$RequisicionesTableAnnotationComposer,
    $$RequisicionesTableCreateCompanionBuilder,
    $$RequisicionesTableUpdateCompanionBuilder,
    (Requisicione, $$RequisicionesTableReferences),
    Requisicione,
    PrefetchHooks Function({bool tonereId})>;
typedef $$MantenimientosTableCreateCompanionBuilder = MantenimientosCompanion
    Function({
  Value<int> id,
  required int impresoraId,
  required DateTime fecha,
  required String detalle,
  Value<bool> reemplazoImpresora,
  Value<int?> nuevaImpresoraId,
});
typedef $$MantenimientosTableUpdateCompanionBuilder = MantenimientosCompanion
    Function({
  Value<int> id,
  Value<int> impresoraId,
  Value<DateTime> fecha,
  Value<String> detalle,
  Value<bool> reemplazoImpresora,
  Value<int?> nuevaImpresoraId,
});

final class $$MantenimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MantenimientosTable, Mantenimiento> {
  $$MantenimientosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ImpresorasTable _impresoraIdTable(_$AppDatabase db) =>
      db.impresoras.createAlias($_aliasNameGenerator(
          db.mantenimientos.impresoraId, db.impresoras.id));

  $$ImpresorasTableProcessedTableManager get impresoraId {
    final $_column = $_itemColumn<int>('impresora_id')!;

    final manager = $$ImpresorasTableTableManager($_db, $_db.impresoras)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_impresoraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ImpresorasTable _nuevaImpresoraIdTable(_$AppDatabase db) =>
      db.impresoras.createAlias($_aliasNameGenerator(
          db.mantenimientos.nuevaImpresoraId, db.impresoras.id));

  $$ImpresorasTableProcessedTableManager? get nuevaImpresoraId {
    final $_column = $_itemColumn<int>('nueva_impresora_id');
    if ($_column == null) return null;
    final manager = $$ImpresorasTableTableManager($_db, $_db.impresoras)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nuevaImpresoraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MantenimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MantenimientosTable> {
  $$MantenimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detalle => $composableBuilder(
      column: $table.detalle, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reemplazoImpresora => $composableBuilder(
      column: $table.reemplazoImpresora,
      builder: (column) => ColumnFilters(column));

  $$ImpresorasTableFilterComposer get impresoraId {
    final $$ImpresorasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableFilterComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImpresorasTableFilterComposer get nuevaImpresoraId {
    final $$ImpresorasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nuevaImpresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableFilterComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MantenimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MantenimientosTable> {
  $$MantenimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detalle => $composableBuilder(
      column: $table.detalle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reemplazoImpresora => $composableBuilder(
      column: $table.reemplazoImpresora,
      builder: (column) => ColumnOrderings(column));

  $$ImpresorasTableOrderingComposer get impresoraId {
    final $$ImpresorasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableOrderingComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImpresorasTableOrderingComposer get nuevaImpresoraId {
    final $$ImpresorasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nuevaImpresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableOrderingComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MantenimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MantenimientosTable> {
  $$MantenimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get detalle =>
      $composableBuilder(column: $table.detalle, builder: (column) => column);

  GeneratedColumn<bool> get reemplazoImpresora => $composableBuilder(
      column: $table.reemplazoImpresora, builder: (column) => column);

  $$ImpresorasTableAnnotationComposer get impresoraId {
    final $$ImpresorasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.impresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableAnnotationComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ImpresorasTableAnnotationComposer get nuevaImpresoraId {
    final $$ImpresorasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nuevaImpresoraId,
        referencedTable: $db.impresoras,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImpresorasTableAnnotationComposer(
              $db: $db,
              $table: $db.impresoras,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MantenimientosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MantenimientosTable,
    Mantenimiento,
    $$MantenimientosTableFilterComposer,
    $$MantenimientosTableOrderingComposer,
    $$MantenimientosTableAnnotationComposer,
    $$MantenimientosTableCreateCompanionBuilder,
    $$MantenimientosTableUpdateCompanionBuilder,
    (Mantenimiento, $$MantenimientosTableReferences),
    Mantenimiento,
    PrefetchHooks Function({bool impresoraId, bool nuevaImpresoraId})> {
  $$MantenimientosTableTableManager(
      _$AppDatabase db, $MantenimientosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MantenimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MantenimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MantenimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> impresoraId = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String> detalle = const Value.absent(),
            Value<bool> reemplazoImpresora = const Value.absent(),
            Value<int?> nuevaImpresoraId = const Value.absent(),
          }) =>
              MantenimientosCompanion(
            id: id,
            impresoraId: impresoraId,
            fecha: fecha,
            detalle: detalle,
            reemplazoImpresora: reemplazoImpresora,
            nuevaImpresoraId: nuevaImpresoraId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int impresoraId,
            required DateTime fecha,
            required String detalle,
            Value<bool> reemplazoImpresora = const Value.absent(),
            Value<int?> nuevaImpresoraId = const Value.absent(),
          }) =>
              MantenimientosCompanion.insert(
            id: id,
            impresoraId: impresoraId,
            fecha: fecha,
            detalle: detalle,
            reemplazoImpresora: reemplazoImpresora,
            nuevaImpresoraId: nuevaImpresoraId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MantenimientosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {impresoraId = false, nuevaImpresoraId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (impresoraId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.impresoraId,
                    referencedTable:
                        $$MantenimientosTableReferences._impresoraIdTable(db),
                    referencedColumn: $$MantenimientosTableReferences
                        ._impresoraIdTable(db)
                        .id,
                  ) as T;
                }
                if (nuevaImpresoraId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.nuevaImpresoraId,
                    referencedTable: $$MantenimientosTableReferences
                        ._nuevaImpresoraIdTable(db),
                    referencedColumn: $$MantenimientosTableReferences
                        ._nuevaImpresoraIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MantenimientosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MantenimientosTable,
    Mantenimiento,
    $$MantenimientosTableFilterComposer,
    $$MantenimientosTableOrderingComposer,
    $$MantenimientosTableAnnotationComposer,
    $$MantenimientosTableCreateCompanionBuilder,
    $$MantenimientosTableUpdateCompanionBuilder,
    (Mantenimiento, $$MantenimientosTableReferences),
    Mantenimiento,
    PrefetchHooks Function({bool impresoraId, bool nuevaImpresoraId})>;
typedef $$DocumentosTableCreateCompanionBuilder = DocumentosCompanion Function({
  Value<int> id,
  required String entidad,
  required int entidadId,
  required String nombre,
  required Uint8List contenido,
  Value<DateTime> creadoEn,
});
typedef $$DocumentosTableUpdateCompanionBuilder = DocumentosCompanion Function({
  Value<int> id,
  Value<String> entidad,
  Value<int> entidadId,
  Value<String> nombre,
  Value<Uint8List> contenido,
  Value<DateTime> creadoEn,
});

class $$DocumentosTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entidad => $composableBuilder(
      column: $table.entidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entidadId => $composableBuilder(
      column: $table.entidadId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get contenido => $composableBuilder(
      column: $table.contenido, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
      column: $table.creadoEn, builder: (column) => ColumnFilters(column));
}

class $$DocumentosTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entidad => $composableBuilder(
      column: $table.entidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entidadId => $composableBuilder(
      column: $table.entidadId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get contenido => $composableBuilder(
      column: $table.contenido, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
      column: $table.creadoEn, builder: (column) => ColumnOrderings(column));
}

class $$DocumentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entidad =>
      $composableBuilder(column: $table.entidad, builder: (column) => column);

  GeneratedColumn<int> get entidadId =>
      $composableBuilder(column: $table.entidadId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<Uint8List> get contenido =>
      $composableBuilder(column: $table.contenido, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$DocumentosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentosTable,
    Documento,
    $$DocumentosTableFilterComposer,
    $$DocumentosTableOrderingComposer,
    $$DocumentosTableAnnotationComposer,
    $$DocumentosTableCreateCompanionBuilder,
    $$DocumentosTableUpdateCompanionBuilder,
    (Documento, BaseReferences<_$AppDatabase, $DocumentosTable, Documento>),
    Documento,
    PrefetchHooks Function()> {
  $$DocumentosTableTableManager(_$AppDatabase db, $DocumentosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entidad = const Value.absent(),
            Value<int> entidadId = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<Uint8List> contenido = const Value.absent(),
            Value<DateTime> creadoEn = const Value.absent(),
          }) =>
              DocumentosCompanion(
            id: id,
            entidad: entidad,
            entidadId: entidadId,
            nombre: nombre,
            contenido: contenido,
            creadoEn: creadoEn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entidad,
            required int entidadId,
            required String nombre,
            required Uint8List contenido,
            Value<DateTime> creadoEn = const Value.absent(),
          }) =>
              DocumentosCompanion.insert(
            id: id,
            entidad: entidad,
            entidadId: entidadId,
            nombre: nombre,
            contenido: contenido,
            creadoEn: creadoEn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentosTable,
    Documento,
    $$DocumentosTableFilterComposer,
    $$DocumentosTableOrderingComposer,
    $$DocumentosTableAnnotationComposer,
    $$DocumentosTableCreateCompanionBuilder,
    $$DocumentosTableUpdateCompanionBuilder,
    (Documento, BaseReferences<_$AppDatabase, $DocumentosTable, Documento>),
    Documento,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ImpresorasTableTableManager get impresoras =>
      $$ImpresorasTableTableManager(_db, _db.impresoras);
  $$ToneresTableTableManager get toneres =>
      $$ToneresTableTableManager(_db, _db.toneres);
  $$RequisicionesTableTableManager get requisiciones =>
      $$RequisicionesTableTableManager(_db, _db.requisiciones);
  $$MantenimientosTableTableManager get mantenimientos =>
      $$MantenimientosTableTableManager(_db, _db.mantenimientos);
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db, _db.documentos);
}
