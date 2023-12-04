import 'package:flutter/material.dart';
import 'package:projetorazer/screens/produtosScreen.dart';
import 'package:projetorazer/screens/clientesScreen.dart';
import 'package:projetorazer/screens/produtosScreen.dart';
import 'package:projetorazer/screens/vendasScreen.dart';
import 'package:projetorazer/screens/pedidosScreen.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Vendinha do Razer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Página Inicial',
            onTap: () {
              // Implemente a navegação para a página inicial aqui.
              Navigator.pop(context); // Fecha o Drawer
              // Adicione aqui a lógica para a página inicial, se necessário.
            },
          ),
          _createDrawerItem(
            icon: Icons.people,
            text: 'Clientes',
            onTap: () {
              // Implemente a navegação para a tela de clientes aqui.
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClientesScreen()),
              );
            },
          ),
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
          _createDrawerItem(
            icon: Icons.attach_money,
            text: 'Vendas',
            onTap: () {
              // Implemente a navegação para a tela de vendas aqui.
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendasScreen()),
              );
            },
          ),

          _createDrawerItem(
            icon: Icons.list_alt,
            text: 'Pedidos',
            onTap: () {
              // Implemente a navegação para a tela de pedidos aqui.
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PedidosScreen()),
              );
            },
          ),

          // Adicione mais itens de menu conforme necessário.
        ],
      ),
    );
  }
}
