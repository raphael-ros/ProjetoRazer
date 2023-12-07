import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CadastroVenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Vendas',
      home: const VendasScreen(),
    );
  }
}

class VendasScreen extends StatefulWidget {
  const VendasScreen({Key? key});

  @override
  _VendasScreenState createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  List<Map<String, dynamic>> vendas = []; //Lista de Vendas
  List<Map<String, dynamic>> pedidos = []; // Lista de pedidos
  List<Map<String, dynamic>> produtos = []; //Lista de produtos
  List<Map<String, dynamic>> itensDoPedidoSelecionado = [];
  int? pedidoSelecionado;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, carrega a lista de pedidos e vendas
    _carregarPedidos();
    _carregarVendas();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final response =
          await http.get(Uri.parse('http://infopguaifpr.com.br:3052/produtos'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('produtos')) {
          final List<dynamic> produtosData = data['produtos'];

          setState(() {
            produtos = List<Map<String, dynamic>>.from(produtosData);
          });
        } else {
          print('Erro ao carregar produtos. Resposta inesperada: $data');
        }
      } else {
        print('Erro ao carregar produtos. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar produtos: $error');
    }
  }

  Future<void> _carregarPedidos() async {
    try {
      // Faz uma requisição GET para a API para carregar os pedidos
      final response =
          await http.get(Uri.parse('http://infopguaifpr.com.br:3052/pedidos'));

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('pedidos')) {
          // Obtém a lista de pedidos da chave "pedidos" no mapa
          final List<dynamic> pedidosData = data['pedidos'];

          // Atualiza o estado com a lista de pedidos
          setState(() {
            pedidos = List<Map<String, dynamic>>.from(pedidosData);
          });
        } else {
          print('Erro ao carregar pedidos. Resposta inesperada: $data');
        }
      } else {
        // Trata o erro
        print('Erro ao carregar pedidos. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Trata o erro
      print('Erro ao carregar pedidos: $error');
    }
  }

  Future<void> _carregarVendas() async {
    // Adicione aqui a lógica para carregar as vendas, se necessário
  }

  Future<void> _carregarItensDoPedido(int? pedidoId) async {
    try {
      // Limpar a lista de itens ao iniciar o carregamento de um novo pedido
      setState(() {
        itensDoPedidoSelecionado = [];
      });

      if (pedidoId != null) {
        final response = await http.get(
          Uri.parse('http://infopguaifpr.com.br:3052/itensDoPedido/$pedidoId'),
        );

        if (response.statusCode == 200) {
          final dynamic data = json.decode(response.body);

          if (data is List<dynamic>) {
            setState(() {
              itensDoPedidoSelecionado = List<Map<String, dynamic>>.from(data);
            });

            if (itensDoPedidoSelecionado.isEmpty) {
              // Mostra uma mensagem indicando que não há produtos relacionados ao pedido
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sem produtos'),
                    content: Text('Este pedido não tem produtos relacionados.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          } else if (data is Map<String, dynamic>) {
            // Se a resposta for um único item, envolva-o em uma lista
            setState(() {
              itensDoPedidoSelecionado = [data];
            });
          } else {
            print(
                'Erro ao carregar itens do pedido. Resposta inesperada: $data');
          }
        } else if (response.statusCode == 404) {
          // Mostra uma mensagem indicando que o pedido não foi encontrado
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pedido Vazio'),
                content: Text('O pedido selecionado ainda não tem produtos.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print(
              'Erro ao carregar itens do pedido. Status code: ${response.statusCode}');
        }
      } else {
        print('Erro ao carregar itens do pedido: pedidoId é nulo');
      }
    } catch (error) {
      print('Erro ao carregar itens do pedido: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Vendas'),
      ),
      body: Column(
        children: [
          DropdownButtonFormField(
            items: pedidos.map((pedido) {
              return DropdownMenuItem(
                value: pedido['id'],
                child: Text('Pedido ${pedido['id']} - ${pedido['data']}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                // Atualize o estado com o pedido selecionado
                pedidoSelecionado = value as int?;
                print('Pedido selecionado: $pedidoSelecionado');
                _carregarItensDoPedido(
                    pedidoSelecionado); // Carregar itens do pedido
              });
            },
            decoration: InputDecoration(labelText: 'Selecione o Pedido'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itensDoPedidoSelecionado.length,
              itemBuilder: (context, index) {
                final itemDoPedido = itensDoPedidoSelecionado[index];
                return ListTile(
                  title: Text(
                      'Item ${itemDoPedido['id']} - Produto ${itemDoPedido['id_produto']} - Quantidade ${itemDoPedido['qtdade']}'),
                  // Adicione outros campos conforme necessário
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vendas.length,
              itemBuilder: (context, index) {
                final venda = vendas[index];
                return ListTile(
                  title: Text(
                    'Item: ${venda['id']} - Quantidade: ${venda['qtdade']}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirVenda(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoIncluirVenda(BuildContext context) {
    int? produtoSelecionado;
    String?
        produtoSelecionadoDescricao; // Agora, pode ser nulo // Variável para armazenar o produto selecionado
    int quantidadeDigitada = 0; // Inicializa com um valor padrão
    int? pedidoSelecionado;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incluir Venda'),
          content: Column(
            children: [
              // Adicione seus campos para incluir a venda aqui
              DropdownButtonFormField(
                items: pedidos.map((pedido) {
                  return DropdownMenuItem(
                    value: pedido['id'],
                    child: Text('Pedido ${pedido['id']} - ${pedido['data']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // Atualize o estado com o pedido selecionado
                    pedidoSelecionado = value as int?;
                    print('Pedido selecionado: $pedidoSelecionado');
                  });
                },
                decoration: InputDecoration(labelText: 'Selecione o Pedido'),
              ),
              DropdownButtonFormField(
                items: produtos.map((produto) {
                  return DropdownMenuItem(
                    value: produto['id'],
                    child: Text(
                        'Produto ${produto['id']} - ${produto['descricao']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // Atualize o estado com o produto selecionado e sua descrição
                    produtoSelecionado =
                        value != null ? int.tryParse(value.toString()) : null;
                    produtoSelecionadoDescricao = produtos.firstWhere(
                        (produto) => produto['id'] == produtoSelecionado,
                        orElse: () => {
                              'descricao': 'Produto não encontrado'
                            })['descricao'] as String?;
                    print(
                        'Descricao Produto selecionado: $produtoSelecionadoDescricao');
                    print('ID do Produto selecionado: $produtoSelecionado');
                  });
                },
                decoration: InputDecoration(labelText: 'Selecione o Produto'),
              ),
              TextField(
                onChanged: (value) {
                  // Atualize o estado com a quantidade digitada
                  quantidadeDigitada = int.parse(value);
                  print('Quantidade: $quantidadeDigitada');
                },
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _incluirItemDoPedido(
                    pedidoSelecionado, produtoSelecionado, quantidadeDigitada);
                Navigator.of(context).pop(); // Fechar o diálogo
                // Atualize a lista de vendas e feche o diálogo
                setState(() {
                  vendas.add({
                    'produto':
                        produtoSelecionado, // Utilize a variável para o produto selecionado
                    'quantidade':
                        quantidadeDigitada, // Utilize a variável para a quantidade digitada
                  });
                });
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: Text('Incluir'),
            ),
          ],
        );
      },
    );
  }

  void _incluirItemDoPedido(
      int? pedidoSelecionado, int? produtoId, int quantidade) async {
    try {
      print('Pedido selecionado: $pedidoSelecionado');
      print('Produto ID: $produtoId');
      print('Quantidade: $quantidade');

      if (pedidoSelecionado != null) {
        final response = await http.post(
          Uri.parse('http://infopguaifpr.com.br:3052/incluirItemDoPedido'),
          headers: {
            'Content-Type':
                'application/json', // Configura o cabeçalho para JSON
          },
          body: jsonEncode({
            'id_pedido': pedidoSelecionado,
            'id_produto': produtoId,
            'qtdade': quantidade,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 201) {
          print('Venda incluída com sucesso');
          // Faça o que for necessário aqui após incluir a venda com sucesso
        } else {
          print('Erro ao incluir venda. Status code: ${response.statusCode}');
          // Lida com o erro, se necessário
        }
      } else {
        print('Erro ao incluir venda: pedidoSelecionado é nulo');
      }
    } catch (error) {
      print('Erro ao incluir venda: $error');
    }
  }
}
