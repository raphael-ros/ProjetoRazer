import { Request, Response } from 'express';
import { Produto } from '../models/Produto';
import { Pedido } from '../models/Pedido';
import { ItemDoPedido } from '../models/ItemDoPedido';


export const listarItensDoPedido = async (req: Request, res: Response) => {
    try {
        const itensDoPedido = await ItemDoPedido.findAll();
        res.json({ itensDoPedido });
    } catch (error) {
        console.error('Erro ao listar itens do pedido:', error);
        res.status(500).json({ message: 'Erro ao listar itens do pedido' });
    }
};

export const incluirItemDoPedido = async (req: Request, res: Response) => {
    try {
        const { id_pedido, id_produto, qtdade } = req.body;

        // Certifique-se de que o pedido e o produto existem antes de criar o item do pedido
        const pedidoExistente = await Pedido.findByPk(id_pedido);
        const produtoExistente = await Produto.findByPk(id_produto);

        if (!pedidoExistente || !produtoExistente) {
            return res.status(404).json({ message: 'Pedido ou Produto não encontrado' });
        }

        const novoItemDoPedido = await ItemDoPedido.create({
            id_pedido: parseInt(id_pedido),
            id_produto: parseInt(id_produto),
            qtdade: parseInt(qtdade),
        });
        res.status(201).json(novoItemDoPedido);
    } catch (error) {
        console.error('Erro ao incluir item do pedido:', error);
        res.status(500).json({ message: 'Erro ao incluir item do pedido' });
    }
};

export const atualizarItemDoPedido = async (req: Request, res: Response) => {
    try {
        const itemId = parseInt(req.params.id, 10);
        const { id_pedido, id_produto, qtdade } = req.body;

        const itemDoPedido = await ItemDoPedido.findByPk(itemId);

        if (itemDoPedido) {
            // Certifique-se de que o pedido e o produto existem antes de atualizar o item do pedido
            const pedidoExistente = await Pedido.findByPk(id_pedido);
            const produtoExistente = await Produto.findByPk(id_produto);

            if (!pedidoExistente || !produtoExistente) {
                return res.status(404).json({ message: 'Pedido ou Produto não encontrado' });
            }

            await itemDoPedido.update({ id_pedido, id_produto, qtdade });
            res.json(itemDoPedido);
        } else {
            res.status(404).json({ message: 'Item do Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar item do pedido:', error);
        res.status(500).json({ message: 'Erro ao atualizar item do pedido' });
    }
};

export const excluirItemDoPedido = async (req: Request, res: Response) => {
    try {
        const itemId = parseInt(req.params.id, 10);
        const itemDoPedido = await ItemDoPedido.findByPk(itemId);

        if (itemDoPedido) {
            await itemDoPedido.destroy();
            res.json({ message: 'Item do Pedido excluído com sucesso' });
        } else {
            res.status(404).json({ message: 'Item do Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao excluir item do pedido:', error);
        res.status(500).json({ message: 'Erro ao excluir item do pedido' });
    }
};

export const getItemDoPedidoById = async (req: Request, res: Response) => {
    try {
        const itemId = parseInt(req.params.id, 10);
        const itemDoPedido = await ItemDoPedido.findByPk(itemId);

        if (itemDoPedido) {
            res.json(itemDoPedido);
        } else {
            res.status(404).json({ message: 'Item do Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao buscar item do pedido:', error);
        res.status(500).json({ message: 'Erro ao buscar item do pedido' });
    }
};