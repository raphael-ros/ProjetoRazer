import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorazer/models/classPedido.dart';
import 'package:projetorazer/models/classCliente.dart';
import 'package:intl/intl.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({Key? key});

  @override
  _PedidosScreenState createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  // Variáveis de estado
  int? produtoSelecionado;
  int quantidadeDigitada = 0;
  List<Pedido> pedidos = [];
  final String baseUrl = 'http://infopguaifpr.com.br:3052';

  int? selectedClientId; // Cliente selecionado
  List<Cliente> clientes = [];
  TextEditingController dataController = TextEditingController();
  DateTime? selectedDate;

  List<Map<String, dynamic>> produtos = [];
  int? selectedProductId;
  int? pedidoId;
  int? pedidoSelecionado;

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
    _carregarProdutos();
    _listarClientes().then((clientes) {
      setState(() {
        this.clientes = clientes;
      });
    }).catchError((error) {
      print('Erro ao carregar clientes: $error');
    });
  }

  // Widgets personalizados

  // Constrói o dropdown para produtos
  Widget _buildProdutoDropdownButton() {
    return DropdownButtonFormField<int?>(
      value: selectedProductId,
      onChanged: (value) {
        setState(() {
          selectedProductId = value;
          _exibirDetalhesProdutoSelecionado();
        });
      },
      items: produtos.map((produto) {
        return DropdownMenuItem<int?>(
          value: produto['id'],
          child: Text('Produto ${produto['id']} - ${produto['descricao']}'),
        );
      }).toList(),
      decoration: InputDecoration(labelText: 'Selecione um Produto'),
    );
  }

  // Constrói o dropdown para clientes
  Widget _buildDropdownButton() {
    return DropdownButton<int?>(
      value: selectedClientId,
      onChanged: (value) {
        setState(() {
          selectedClientId = value;
        });
      },
      items: clientes.map((cliente) {
        return DropdownMenuItem<int?>(
          value: cliente.id,
          child: Text('${cliente.nome} ${cliente.sobrenome}'),
        );
      }).toList(),
      hint: Text('Selecione um Cliente'),
    );
  }

  // Métodos auxiliares

  // Envia a venda para a API
  Future<void> _enviarVendaParaAPI(
      int? pedidoId, int? produtoId, int quantidade) async {
    try {
      if (pedidoId == null || produtoId == null) {
        print('Pedido ID ou Produto ID é nulo.');
        _mostrarSnackBar(
            'Erro ao adicionar venda: Pedido ID ou Produto ID é nulo.');
        return;
      }

      final Map<String, dynamic> vendaData = {
        'id_pedido': pedidoId,
        'id_produto': produtoId,
        'qtdade': quantidade,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/incluirItemDoPedido'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vendaData),
      );

      if (response.statusCode == 201) {
        print('Venda adicionada com sucesso');

        // Carrega os detalhes atualizados do pedido
        await _carregarPedidos();

        // Encontra o pedido atualizado
        final Pedido pedidoAtualizado =
            pedidos.firstWhere((pedido) => pedido.id == pedidoId);

        // Exibe os detalhes do pedido atualizado
        _mostrarDetalhesPedido(context, pedidoAtualizado);
      } else {
        print('Erro ao adicionar venda: ${response.statusCode}');
        // Lógica para tratar falhas na adição da venda
      }
    } catch (e) {
      print('Erro ao adicionar venda: $e');
      // Lógica para tratar exceções durante a adição da venda
    }
  }

  // Exibe os detalhes do produto selecionado
  void _exibirDetalhesProdutoSelecionado() {
    if (produtoSelecionado != null) {
      int? produtoSelecionadoId = produtos.firstWhere(
        (produto) => produto['id'] == produtoSelecionado,
        orElse: () => {'id': null},
      )['id'] as int?;

      print('ID do Produto selecionado: $produtoSelecionadoId');
      _adicionarVenda(pedidoId, produtoSelecionadoId, quantidadeDigitada);
    } else {
      print('Produto não selecionado.');
    }
  }

  // Carrega a lista de produtos
  Future<void> _carregarProdutos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produtos'));

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

  // Carrega a lista de clientes
  Future<List<Cliente>> _listarClientes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clientes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['clientes'];
        return data.map((json) => Cliente.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar clientes da API');
      }
    } catch (e) {
      throw Exception('Erro ao carregar clientes: $e');
    }
  }

  // Carrega a lista de pedidos
  Future<void> _carregarPedidos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> pedidosData = data['pedidos'];

        setState(() {
          pedidos = pedidosData.map((json) => Pedido.fromJson(json)).toList();
        });
      } else {
        print('Erro ao carregar pedidos da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
    }
  }

  // Adiciona um novo pedido
  Future<void> _adicionarPedido() async {
    try {
      if (selectedDate == null) {
        _mostrarSnackBar('Selecione uma data para o pedido.');
        return;
      }

      if (selectedClientId == null) {
        _mostrarSnackBar('Selecione um cliente para o pedido.');
        return;
      }

      final clienteSelecionado =
          clientes.firstWhere((cliente) => cliente.id == selectedClientId);

      final novoPedido = Pedido.create(
        data: selectedDate!,
        idCliente: selectedClientId!,
        cliente: clienteSelecionado,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/incluirPedido'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(novoPedido.toJson()),
      );

      if (response.statusCode == 201) {
        _carregarPedidos();
        _mostrarSnackBar('Pedido adicionado com sucesso');
      } else {
        print('Erro ao adicionar pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao adicionar pedido: $e');
    }
  }

  // Seleciona uma data para o pedido
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dataController.text = dateFormat.format(selectedDate!);
      });
    }
  }

  // Exibe uma snackbar com a mensagem fornecida
  void _mostrarSnackBar(String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Adiciona uma nova venda ao pedido
  Future<void> _adicionarVenda(
      int? pedidoId, int? produtoId, int quantidade) async {
    try {
      await _carregarProdutos();

      int? produtoSelecionado;
      int quantidadeDigitada = 0;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Adicionar Venda'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProdutoDropdownButton(),
                  TextField(
                    onChanged: (value) {
                      quantidadeDigitada = int.parse(value);
                      print('Quantidade: $quantidadeDigitada');
                    },
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  produtoSelecionado = selectedProductId;
                  _enviarVendaParaAPI(
                      pedidoId, produtoSelecionado, quantidadeDigitada);

                  Navigator.of(context).pop();
                },
                child: Text('Confirmar Venda'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Erro ao adicionar venda: $error');
    }
  }

  // Exibe os detalhes do pedido em um AlertDialog
  void _mostrarDetalhesPedido(BuildContext context, Pedido pedido) {
    int pedidoId = pedido.id;
    print('Pedido ID: $pedidoId');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes do Pedido #${pedido.id}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data: ${dateFormat.format(pedido.data)}'),
              Text(
                'Cliente: ${pedido.cliente.nome} ${pedido.cliente.sobrenome}',
              ),
              if (pedido.itensDoPedido != null &&
                  pedido.itensDoPedido!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Itens do Pedido:'),
                    for (var item in pedido.itensDoPedido!)
                      ListTile(
                        title: Text(
                          '${item.qtdade}x ${item.produto.descricao}',
                        ),
                        subtitle: Text(
                          'Produto #${item.produto.id}',
                        ),
                      ),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
            FloatingActionButton(
              onPressed: () {
                _adicionarVenda(
                    pedidoId, produtoSelecionado, quantidadeDigitada);
              },
              child: Icon(Icons.add_shopping_cart),
              tooltip: 'Adicionar Venda',
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pedidos'),
      ),
      body: pedidos.isEmpty
          ? Center(child: Text('Nenhum pedido encontrado.'))
          : ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Pedido #${pedido.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data: ${dateFormat.format(pedido.data)}'),
                      Text(
                        'Cliente: ${pedido.cliente.nome} ${pedido.cliente.sobrenome}',
                      ),
                      if (pedido.itensDoPedido != null &&
                          pedido.itensDoPedido!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                    ],
                  ),
                  onTap: () {
                    _mostrarDetalhesPedido(context, pedido);
                  },
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Adicionar Pedido'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Data do Pedido',
                                suffixIcon: Icon(Icons.date_range),
                              ),
                              child: Text(
                                selectedDate != null
                                    ? dateFormat.format(selectedDate!)
                                    : 'Selecionar data',
                              ),
                            ),
                          ),
                          _buildDropdownButton(),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _adicionarPedido();
                          Navigator.of(context).pop();
                        },
                        child: Text('Adicionar Pedido'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
            tooltip: 'Adicionar Pedido',
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
