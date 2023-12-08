import 'package:projetorazer/models/classCliente.dart';

class Pedido {
  final int id;
  final DateTime data;
  final int idCliente;
  final Cliente cliente; // Adicionando uma propriedade para o cliente

  Pedido({
    required this.id,
    required this.data,
    required this.idCliente,
    required this.cliente,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as int,
      data: DateTime.parse(json['data']),
      idCliente: json['id_cliente'] as int,
      cliente: Cliente.fromJson(json['Cliente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'id_cliente': idCliente,
      'Cliente': cliente.toJson(), // Convertendo o cliente para JSON
    };
  }

  // Novo construtor para criação de um pedido com data e cliente específicos
  Pedido.create(
      {required this.data, required this.idCliente, required this.cliente})
      : id = 0; // Defina um valor padrão para o ID (por exemplo, 0 ou null)
}
