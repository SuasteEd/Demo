class Indicador {
  String titulo;
  int valor;

  Indicador(this.titulo, this.valor);

  Indicador.fromJson(Map<String, dynamic> json)
      : titulo = json['Titulo'],
        valor = json['Valor'];

  Indicador.fromMap(Map<String, dynamic> map)
      : titulo = map['Titulo'],
        valor = map['Valor'];
}
