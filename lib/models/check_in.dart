class check_inn{
  int dia;
  int id;
  double latitud;
  double longitud;
  String title;
  String snippet;

  check_inn(
    this.dia,
      this.id,
       this.latitud,
       this.longitud,
       this.title,
       this.snippet
);

//Map for insert
  Map<String,dynamic> mapForInsert(){
    return {
      'dia' : dia,
      'id': id,
      'latitud': latitud,
      'longitud': longitud,
      'title': title,
      'snippet': snippet
    };
  }
}
        
  