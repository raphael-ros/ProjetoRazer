import 'package:flutter/material.dart';

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
  List<String> vendas = []; // Adapte conforme necessário

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
            title: Text('Venda: $venda'), // Adapte conforme necessário
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  vendas.removeAt(index);
                });
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
    // Implemente o diálogo de inclusão de venda semelhante ao da tela de produtos
  }
}
