class ClienteDia {
  int dia;
  int id;
  int orden;
  String nombre;
  int agenteId;
  String domicilio;
  double latitud;
  double longitud;
  int checado;

  ClienteDia(this.dia, this.id, this.orden, this.nombre, this.agenteId,
      this.domicilio, this.latitud, this.longitud, this.checado);

  ClienteDia.fromMap(Map<String, dynamic> map)
      : dia = map['Dia'],
        id = map['Id'],
        orden = map['Orden'],
        nombre = map['Nombre'],
        agenteId = map['AgenteId'],
        domicilio = map['Domicilio'],
        latitud = map['Latitud'] == null ? 0.0 : map["Latitud"].toDouble(),
        longitud = map['Longitud'] == null ? 0.0 : map["Longitud"].toDouble(),
        checado = map['Checado'];

//Map for insert
  Map<String, dynamic> toMapForDb() {
    return {
      'dia': dia,
      'id': id,
      'orden': orden,
      'nombre': nombre,
      'agenteId': agenteId,
      'domicilio': domicilio,
      'latitud': latitud,
      'longitud': longitud,
      'checado': checado
    };
  }

//Map for update
  Map<String, dynamic> mapForUpdate() {
    return {'id': id, 'checado': checado};
  }

//Map for update check
  Map<String, dynamic> mapForUpdateCheck() {
    return {'dia': dia, 'id': id, 'checado': checado};
  }
}
