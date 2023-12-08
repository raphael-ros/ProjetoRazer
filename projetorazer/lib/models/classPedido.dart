import 'package:projetorazer/models/classCliente.dart';
import 'package:projetorazer/models/classItemDoPedido.dart';

class Pedido {
  final int id;
  final DateTime data;
  final int idCliente;
  final Cliente cliente;
  final List<ItemDoPedido>? itensDoPedido;

  Pedido({
    required this.id,
    required this.data,
    required this.idCliente,
    required this.cliente,
    this.itensDoPedido,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? itensDoPedidoJson = json['itensDoPedido'];
    final List<ItemDoPedido> itensDoPedido = (itensDoPedidoJson ?? [])
        .map((itemJson) => ItemDoPedido.fromJson(itemJson))
        .toList();

    return Pedido(
      id: json['id'] as int,
      data: DateTime.parse(json['data']),
      idCliente: json['cliente']['id'] as int,
      cliente: Cliente.fromJson(json['cliente']),
      itensDoPedido: itensDoPedido.isNotEmpty ? itensDoPedido : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data.toIso8601String(),
      'id_cliente': idCliente,
      'cliente': cliente.toJson(),
      'itensDoPedido': itensDoPedido?.map((item) => item.toJson()).toList(),
    };
  }

  // Novo construtor para criação de um pedido com data e cliente específicos
  Pedido.create({
    required this.data,
    required this.idCliente,
    required this.cliente,
    this.itensDoPedido,
  }) : id = 0; // Defina um valor padrão para o ID (por exemplo, 0 ou null)
}
