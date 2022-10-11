class Datos {
  String etiqueta;
  int valor;
  double kpi;

  Datos(this.etiqueta, this.valor, this.kpi);

  Datos.fromJson(Map<String, dynamic> json)
      : etiqueta = json['Etiqueta'],
        valor = json['Valor'],
        kpi = json['KPI'];

  Datos.fromMap(Map<String, dynamic> map)
      : etiqueta = map['Etiqueta'],
        valor = map['Valor'],
        kpi = map['KPI'];
}
