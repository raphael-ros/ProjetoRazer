import 'package:flutter/material.dart';
import 'package:projetorazer/screens/produtosScreen.dart';
import 'package:projetorazer/screens/clientesScreen.dart';
import 'package:projetorazer/screens/pedidosScreen.dart';

// Widget para representar o Drawer da aplicação
class AppDrawer extends StatelessWidget {
  // Cria o cabeçalho do Drawer com o nome da aplicação
  Widget _createHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Vendinha do Lyures',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  // Cria um item do Drawer com ícone, texto e ação ao ser tocado
  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retorna o Drawer com uma lista de itens
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          // Item do Drawer para a Página Inicial
          _createDrawerItem(
            icon: Icons.home,
            text: 'Página Inicial',
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              // Adicione a lógica de navegação para a página inicial aqui, se necessário.
            },
          ),
          // Item do Drawer para a tela de Clientes
          _createDrawerItem(
            icon: Icons.people,
            text: 'Clientes',
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientesScreen()),
              );
            },
          ),
          // Item do Drawer para a tela de Produtos
          _createDrawerItem(
            icon: Icons.shopping_cart,
            text: 'Produtos',
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProdutosScreen()),
              );
            },
          ),
          // Item do Drawer para a tela de Pedidos
          _createDrawerItem(
            icon: Icons.list_alt,
            text: 'Pedidos',
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PedidosScreen()),
              );
            },
          ),
          // Adicione mais itens do menu conforme necessário.
        ],
      ),
    );
  }
}
