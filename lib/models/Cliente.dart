class Cliente {
  int id;
  int orden;
  String nombre;
  int agenteId;
  String domicilio;
  double latitud;
  double longitud;

  Cliente(
      {required this.id,
      required this.orden,
      required this.nombre,
      required this.agenteId,
      required this.domicilio,
      required this.latitud,
      required this.longitud});

  Cliente.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        orden = json['Orden'],
        nombre = json['Nombre'],
        agenteId = json['AgenteId'],
        domicilio = json['Domicilio'],
        latitud = json['Latitud'] == null ? 0.0 : json["Latitud"].toDouble(),
        longitud = json['Longitud'] == null ? 0.0 : json["Longitud"].toDouble();

  Cliente.fromMap(Map<String, dynamic> map)
      : id = map['Id'],
        orden = map['Orden'],
        nombre = map['Nombre'],
        agenteId = map['AgenteId'],
        domicilio = map['Domicilio'],
        latitud = map['Latitud'] == null ? 0.0 : map["Latitud"].toDouble(),
        longitud = map['Longitud'] == null ? 0.0 : map["Longitud"].toDouble();

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'Id': id,
      'Orden': orden,
      'Nombre': nombre,
      'AgenteId': agenteId,
      'Domicilio': domicilio,
      'latitud': latitud,
      'longitud': longitud
    };
  }
}
