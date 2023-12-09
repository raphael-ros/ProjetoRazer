class Produto {
  // Atributos da classe Produto
  final int id;
  final String descricao;

  // Construtor da classe Produto
  Produto({required this.id, required this.descricao});

  // Método de fábrica para criar uma instância de Produto a partir de um mapa (JSON).
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      descricao: json['descricao'],
    );
  }

  // Método para converter o objeto Produto em um mapa (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }
}
