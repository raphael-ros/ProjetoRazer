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
  List<Map<String, dynamic>> vendas = []; // Adapte conforme necessário
  List<Map<String, dynamic>> pedidos = []; // Lista de pedidos

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, carrega a lista de pedidos e vendas
    _carregarPedidos();
    _carregarVendas();
  }

  Future<void> _carregarPedidos() async {
    try {
      // Faz uma requisição GET para a API para carregar os pedidos
      final response =
          await http.get(Uri.parse('http://infopguaifpr.com.br:3052'));

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Obtém a lista de pedidos da chave "pedidos" no mapa
        final List<dynamic> pedidosData = data['pedidos'];

        // Atualiza o estado com a lista de pedidos
        setState(() {
          pedidos = List<Map<String, dynamic>>.from(pedidosData);
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Vendas'),
      ),
      body: ListView.builder(
        itemCount: vendas.length,
        itemBuilder: (context, index) {
          final venda = vendas[index];
          return ListTile(
            title: Text(
                'Venda: ${venda['id']} - ${venda['data']}'), // Adapte conforme necessário
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Implemente a lógica para excluir a venda aqui
              },
            ),
          );
        },
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
                  // Aqui você pode lidar com o valor selecionado
                  print('Pedido selecionado: $value');
                },
                decoration: InputDecoration(labelText: 'Selecione o Pedido'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Produto'),
              ),
              TextField(
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
                // Adicione sua lógica para incluir a venda aqui
                // Atualize a lista de vendas e feche o diálogo
                setState(() {
                  vendas.add({
                    'id': vendas.length + 1, // Substitua com os dados reais
                    'data': '2023-12-10', // Substitua com os dados reais
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
}
