class clientesDia{
  int dia;
  int id;
  int orden;
  String nombre;
  int agenteId;
  String domicilio;
  double latitud;
  double longitud;
  int checado;

  clientesDia(
    this.dia,
      this.id,
       this.orden,
       this.nombre,
       this.agenteId,
       this.domicilio,
       this.latitud,
       this.longitud,
       this.checado
);

//Map for insert
  Map<String,dynamic> mapForInsert(){
    return {
      'dia' : dia,
      'id': id,
      'orden': orden,
      'nombre': nombre,
      'agenteId': agenteId,
      'domicilio': domicilio,
      'latitud': latitud,
      'longitud': longitud,
      'checado' : checado
    };
  }
//Map for update
  Map<String,dynamic> mapForUpdate(){
    return {
      'id': id,
      'checado' : checado
    };
  }
//Map for update check
  Map<String,dynamic> mapForUpdateCheck(){
    return {
      'dia' : dia,
      'id': id,
      'checado' : checado
    };
  }
}
        
  