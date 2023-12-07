class ItemDoPedido {
  int id;
  int idProduto;
  int idPedido;
  int quantidade;

  ItemDoPedido({
    required this.id,
    required this.idProduto,
    required this.idPedido,
    required this.quantidade,
  });

  // Método para criar uma instância de ItemDoPedido a partir de um mapa
  factory ItemDoPedido.fromMap(Map<String, dynamic> map) {
    return ItemDoPedido(
      id: map['id'],
      idProduto: map['id_produto'],
      idPedido: map['id_pedido'],
      quantidade: map['qtdade'],
    );
  }
}
