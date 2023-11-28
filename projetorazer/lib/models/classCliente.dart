class Cliente {
  int id;
  String nome;
  String sobrenome;
  String cpf;

  Cliente({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.cpf,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      cpf: json['cpf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
    };
  }
}
