
enum PrinterStatus { activa, pendienteBaja, baja, mantenimiento }

/// Estados para tóner
enum TonerStatus   { almacenado, instalado, enPedido }

/// Estados para requisición
enum RequisitionStatus { pendiente, completada }

extension PrinterStatusX on PrinterStatus {
  String get dbValue {
    switch (this) {
      case PrinterStatus.activa:        return 'activa';
      case PrinterStatus.pendienteBaja: return 'pendiente_baja';
      case PrinterStatus.baja:          return 'baja';
      case PrinterStatus.mantenimiento: return 'mantenimiento';
    }
  }
  static PrinterStatus fromDb(String v) =>
    PrinterStatus.values.firstWhere((e) => e.dbValue == v);
}

extension TonerStatusX on TonerStatus {
  String get dbValue {
    switch (this) {
      case TonerStatus.almacenado: return 'almacenado';
      case TonerStatus.instalado:  return 'instalado';
      case TonerStatus.enPedido:    return 'en_pedido';
    }
  }
  static TonerStatus fromDb(String v) =>
    TonerStatus.values.firstWhere((e) => e.dbValue == v);
}

extension RequisitionStatusX on RequisitionStatus {
  String get dbValue {
    switch (this) {
      case RequisitionStatus.pendiente:  return 'pendiente';
      case RequisitionStatus.completada: return 'completada';
    }
  }
  static RequisitionStatus fromDb(String v) =>
    RequisitionStatus.values.firstWhere((e) => e.dbValue == v);
}
