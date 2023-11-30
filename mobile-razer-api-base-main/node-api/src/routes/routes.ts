import { Router } from 'express';

import * as ApiController from '../controllers/apiController';
import * as ClienteController from '../controllers/ClienteController';
import * as ItemDoPedidoController from '../controllers/ItemDoPedidoController'
import * as PedidoController from '../controllers/PedidoController'
import * as ProdutoController from '../controllers/ProdutoController'



const router = Router();

//CLIENTES
router.get('/clientes', ClienteController.listarClientes);
router.get('/clientes/:id', ClienteController.getClienteById);
router.post('/incluirCliente', ClienteController.incluirCliente);
router.put('/atualizarCliente/:id', ClienteController.atualizarCliente);
router.delete('/excluirCliente/:id', ClienteController.excluirCliente);

//PRODUTOS
router.get('/produtos', ProdutoController.listarProdutos);
router.get('/produtos/:id', ProdutoController.getProdutoById);
router.post('/incluirProduto', ProdutoController.incluirProduto);
router.put('/atualizarProduto/:id', ProdutoController.atualizarProduto);
router.delete('/excluirProduto/:id', ProdutoController.excluirProduto);


//PEDIDOS
router.get('/listarPedidos', PedidoController.listarPedidos);
router.get('/pedidos/:id', PedidoController.getPedidoById);
router.post('/incluirPedido', PedidoController.incluirPedido);
router.put('/atualizarPedido/:id', PedidoController.atualizarPedido);
router.delete('/excluirPedido/:id', PedidoController.excluirPedido);

// ITENS DO PEDIDO
router.get('/itensDoPedido', ItemDoPedidoController.listarItensDoPedido);
router.get('/itensDoPedido/:id', ItemDoPedidoController.getItemDoPedidoById);
router.post('/incluirItemDoPedido', ItemDoPedidoController.incluirItemDoPedido);
router.put('/atualizarItemDoPedido/:id', ItemDoPedidoController.atualizarItemDoPedido);
router.delete('/excluirItemDoPedido/:id', ItemDoPedidoController.excluirItemDoPedido);














export default router;
