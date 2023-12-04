class Pedido {
  final int id;
  final DateTime data;
  final int idCliente;

  Pedido({
    required this.id,
    required this.data,
    required this.idCliente,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as int,
      data: DateTime.parse(json['data']),
      idCliente: json['id_cliente'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'id_cliente': idCliente,
    };
  }

  // Novo construtor para criação de um pedido com data e cliente específicos
  Pedido.create({required this.data, required this.idCliente})
      : id = 0; // Defina um valor padrão para o ID (por exemplo, 0 ou null)
}
