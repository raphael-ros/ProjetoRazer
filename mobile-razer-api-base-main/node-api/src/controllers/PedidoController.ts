import { Request, Response } from 'express';
import { Produto } from '../models/Produto';
import { Cliente } from '../models/Cliente';
import { Pedido } from '../models/Pedido';

export const listarPedidos = async (req: Request, res: Response) => {
    try {
        const pedidos = await Pedido.findAll();
        res.json({ pedidos });
    } catch (error) {
        console.error('Erro ao listar pedidos:', error);
        res.status(500).json({ message: 'Erro ao listar pedidos' });
    }
};


export const incluirPedido = async (req: Request, res: Response) => {
    try {
        const { data, id_cliente } = req.body;
        const novoPedido = await Pedido.create({ data, id_cliente });

        res.status(201).json(novoPedido);
    } catch (error) {
        console.error('Erro ao incluir pedido:', error);
        res.status(500).json({ message: 'Erro ao incluir pedido' });
    }
};

export const atualizarPedido = async (req: Request, res: Response) => {
    try {
        const pedidoId = parseInt(req.params.id, 10);
        const { data, id_cliente } = req.body;

        const pedido = await Pedido.findByPk(pedidoId);

        if (pedido) {
            await pedido.update({ data, id_cliente });
            res.json(pedido);
        } else {
            res.status(404).json({ message: 'Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar pedido:', error);
        res.status(500).json({ message: 'Erro ao atualizar pedido' });
    }
};

export const excluirPedido = async (req: Request, res: Response) => {
    try {
        const pedidoId = parseInt(req.params.id, 10);
        const pedido = await Pedido.findByPk(pedidoId);

        if (pedido) {
            await pedido.destroy();
            res.json({ message: 'Pedido excluído com sucesso' });
        } else {
            res.status(404).json({ message: 'Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao excluir pedido:', error);
        res.status(500).json({ message: 'Erro ao excluir pedido' });
    }
};

export const getPedidoById = async (req: Request, res: Response) => {
    try {
        const pedidoId = parseInt(req.params.id, 10);
        const pedido = await Pedido.findByPk(pedidoId);

        if (pedido) {
            res.json(pedido);
        } else {
            res.status(404).json({ message: 'Pedido não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao buscar pedido:', error);
        res.status(500).json({ message: 'Erro ao buscar pedido' });
    }
};