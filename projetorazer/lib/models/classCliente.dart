// Classe Cliente representa um cliente com informações básicas: id, nome, sobrenome, e cpf.
class Cliente {
  // Atributos do cliente
  int id;
  String nome;
  String sobrenome;
  String cpf;

  // Construtor da classe Cliente.
  Cliente({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.cpf,
  });

  // Método de fábrica para criar uma instância de Cliente a partir de um mapa (JSON).
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      cpf: json['cpf'],
    );
  }

  // Método para converter o objeto Cliente em um mapa (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'cpf': cpf,
    };
  }
}
