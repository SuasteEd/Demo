class Indicadores {
  String titulo;
  int valor;
  String etiqueta;
  int valorDato;
  double kpi;

  Indicadores(this.titulo, this.valor, this.etiqueta, this.valorDato, this.kpi);

  Indicadores.fromJson(Map<String, dynamic> json)
      : titulo = json['Titulo'],
        valor = json['Valor'],
        etiqueta = json['Etiqueta'],
        valorDato = json['Valor'],
        kpi = json['KPI'];

  Indicadores.fromMap(Map<String, dynamic> map)
      : titulo = map['Titulo'],
        valor = map['Valor'],
        etiqueta = map['Etiqueta'],
        valorDato = map['Valor'],
        kpi = map['KPI'];

  Map<String, dynamic> toMapForDb() {
    return {
      'titulo': titulo,
      'valor': valor,
      'etiqueta': etiqueta,
      'valorDato': valorDato,
      'kpi': kpi
    };
  }
}
