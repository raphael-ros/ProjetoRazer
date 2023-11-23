import 'package:flutter/material.dart';
import '../models/classCliente.dart';

class CadastroCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Clientes',
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
  List<Cliente> clientes = [];

  // Controller para os campos de edição
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobrenomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  // Variável para rastrear se estamos adicionando ou editando
  bool isEditing = false;
  int editingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return ListTile(
            title: Text('${cliente.nome} ${cliente.sobrenome}'),
            subtitle: Text('CPF: ${cliente.cpf}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _mostrarDialogoEditarCliente(context, index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      clientes.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoIncluirEditarCliente(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoIncluirEditarCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Cliente' : 'Incluir Cliente'),
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
                controller: cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                _limparCampos();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isEditing ? 'Salvar Alterações' : 'Salvar'),
              onPressed: () {
                _incluirEditarCliente();
                _limparCampos();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEditarCliente(BuildContext context, int index) {
    // Preencha os campos de edição com as informações do cliente selecionado
    nomeController.text = clientes[index].nome;
    sobrenomeController.text = clientes[index].sobrenome;
    cpfController.text = clientes[index].cpf;

    // Atualize as variáveis de controle
    isEditing = true;
    editingIndex = index;

    // Abra o diálogo de inclusão/editar
    _mostrarDialogoIncluirEditarCliente(context);
  }

  void _incluirEditarCliente() {
    final nome = nomeController.text;
    final sobrenome = sobrenomeController.text;
    final cpf = cpfController.text;

    if (nome.isNotEmpty && sobrenome.isNotEmpty && cpf.isNotEmpty) {
      final novoCliente = Cliente(
        nome: nome,
        sobrenome: sobrenome,
        cpf: cpf,
      );

      if (isEditing) {
        // Se estamos editando, substitua o cliente existente
        setState(() {
          clientes[editingIndex] = novoCliente;
        });
      } else {
        // Se estamos adicionando, inclua o novo cliente
        setState(() {
          clientes.add(novoCliente);
        });
      }
    }
  }

  void _limparCampos() {
    // Limpe os campos de edição e redefina as variáveis de controle
    nomeController.clear();
    sobrenomeController.clear();
    cpfController.clear();
    isEditing = false;
    editingIndex = -1;
  }
}
