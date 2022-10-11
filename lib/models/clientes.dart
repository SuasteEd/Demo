class clientes{
  int id;
  int orden;
  String nombre;
  int agenteId;
  String domicilio;
  double latitud;
  double longitud;

  clientes({
      required this.id,
      required this.orden,
      required this.nombre,
      required this.agenteId,
      required this.domicilio,
      required this.latitud,
      required this.longitud
});

//Map for insert
  Map<String,dynamic> mapForInsert(){
    return {
      'id': id,
      'orden': orden,
      'nombre': nombre,
      'agenteId': agenteId,
      'domicilio': domicilio,
      'latitud': latitud,
      'longitud': longitud
    };
  }
//Map for update
  Map<String,dynamic> mapForUpdate(){
    return {
      'id': id,
      'orden': orden,
      'nombre': nombre,
      'agenteId': agenteId,
      'domicilio': domicilio,
      'latitud': latitud,
      'longitud': longitud
    };
  }

factory clientes.fromJson(Map json){
  return clientes(
    id : json['Id'],
    orden : json['Orden'],
    nombre : json['Nombre'],
    agenteId : json['AgenteId'],
    domicilio : json['Domicilio'],
    latitud: json["Latitud"]  == null ? 0.0 : json["Latitud"].toDouble(),
    longitud: json["Longitud"] == null ? 0.0 : json["Longitud"].toDouble(),
  );
}
}
        