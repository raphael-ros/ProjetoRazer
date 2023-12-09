import 'package:projetorazer/models/classProduto.dart';

class ItemDoPedido {
  //Atributos de Item do Pedido
  final int id;
  final int qtdade;
  final Produto produto;

  // Construtor da classe ItemDoPedido.
  ItemDoPedido({
    required this.id,
    required this.qtdade,
    required this.produto,
  });

  // Método de fábrica para criar uma instância de ItemDoPedido a partir de um mapa (JSON).
  factory ItemDoPedido.fromJson(Map<String, dynamic> json) {
    return ItemDoPedido(
      id: json['id'] as int,
      qtdade: json['qtdade'] as int,
      produto: Produto.fromJson(json['produto']),
    );
  }

  // Método para converter o objeto ItemDoPedido em um mapa (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qtdade': qtdade,
      'produto': produto.toJson(),
    };
  }
}
