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
  List<Pedido> pedidos = [];
  final String baseUrl = 'http://infopguaifpr.com.br:3052';

  // TextEditingController dataController = TextEditingController();
  int? selectedClientId; // Variável para armazenar o cliente selecionado
  List<Cliente> clientes = [];

  TextEditingController dataController = TextEditingController();
  DateTime? selectedDate;

  // Adicione um DateFormat para formatar a data
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

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

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
    _listarClientes().then((clientes) {
      setState(() {
        this.clientes = clientes;
      });
    }).catchError((error) {
      print('Erro ao carregar clientes: $error');
    });
  }

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

  Future<void> _carregarPedidos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> pedidosData = data['pedidos'];

        print(
            'Dados recebidos da API: $pedidosData'); // Adicione esta linha para debugar

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

      // Criar um objeto Cliente associado ao pedido
      final clienteSelecionado =
          clientes.firstWhere((cliente) => cliente.id == selectedClientId);

      // Criar o novo pedido com o cliente associado
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

  // Método para mostrar o DatePicker
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

  void _mostrarSnackBar(String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          children: [
                            Text('Itens do Pedido:'),
                            for (var item in pedido.itensDoPedido!)
                              Text(
                                '- ${item.qtdade}x ${item.produto.descricao}',
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
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
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
