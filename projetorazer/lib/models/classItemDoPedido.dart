import 'package:projetorazer/models/classProduto.dart';

class ItemDoPedido {
  final int id;
  final int qtdade;
  final Produto produto;

  ItemDoPedido({
    required this.id,
    required this.qtdade,
    required this.produto,
  });

  factory ItemDoPedido.fromJson(Map<String, dynamic> json) {
    return ItemDoPedido(
      id: json['id'] as int,
      qtdade: json['qtdade'] as int,
      produto: Produto.fromJson(json['produto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qtdade': qtdade,
      'produto': produto.toJson(),
    };
  }
}
