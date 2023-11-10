import 'package:flutter/material.dart';
import 'package:projetorazer/produtos.dart';
import 'classCliente.dart';
import 'package:projetorazer/widgets/drawer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  static const appTitle = 'Projeto Razer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const ClientesScreen(),
    );
  }
}

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key});

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> clientes = []; // Lista de clientes

  void trocaTela() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProdutosScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      drawer: AppDrawer(), // Adicionando o Drawer aqui
      body: Column(
        children: [
          ElevatedButton(
            onPressed: trocaTela,
            child: const Text('Lista de Produtos'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return ListTile(
                  title: Text('${cliente.nome} ${cliente.sobrenome}'),
                  subtitle: Text('CPF: ${cliente.cpf}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Verifique se o cliente não possui pedidos antes de excluí-lo
                      if (podeExcluirCliente(cliente)) {
                        setState(() {
                          clientes.removeAt(index);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Este cliente possui pedidos e não pode ser excluído.'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirCliente(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  bool podeExcluirCliente(Cliente cliente) {
    // Implemente a lógica para verificar se o cliente possui pedidos
    // Se tiver pedidos, retorne false; caso contrário, retorne true.
    return true; // Modifique de acordo com a sua lógica real.
  }

  void _mostrarDialogoIncluirCliente(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController sobrenomeController = TextEditingController();
    final cpfController = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incluir Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: sobrenomeController,
                decoration: InputDecoration(labelText: 'Sobrenome'),
              ),
              TextField(
                controller:
                    TextEditingController(text: cpfController.getMaskedText()),
                inputFormatters: [cpfController],
                decoration: InputDecoration(labelText: 'CPF'),
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
                final nome = nomeController.text;
                final sobrenome = sobrenomeController.text;
                final cpf = cpfController.getUnmaskedText();

                if (nome.isNotEmpty && sobrenome.isNotEmpty && cpf.isNotEmpty) {
                  final novoCliente = Cliente(
                    nome: nome,
                    sobrenome: sobrenome,
                    cpf: cpf,
                  );
                  setState(() {
                    clientes.add(novoCliente);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
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
