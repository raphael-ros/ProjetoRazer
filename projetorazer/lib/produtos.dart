import 'package:flutter/material.dart';
import 'classProduto.dart';

class CadastroProduto extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Produtos',
      home: const ProdutosScreen(),
    );
  }
}

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key});

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> produtos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return ListTile(
            title: Text(produto.descricao),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  produtos.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirProduto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoIncluirProduto(BuildContext context) {
    final TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incluir Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                final descricao = descricaoController.text;

                if (descricao.isNotEmpty) {
                  final novoProduto = Produto(
                    descricao: descricao,
                  );
                  setState(() {
                    produtos.add(novoProduto);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha a descrição do produto.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
