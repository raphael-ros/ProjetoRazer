import { Request, Response } from 'express';
import { Produto } from '../models/Produto';
import { Cliente } from '../models/Cliente';
import { Pedido } from '../models/Pedido';

export const listarClientes = async (req: Request, res: Response) => {
    try {
        const clientes = await Cliente.findAll();
        res.json({ clientes });
    } catch (error) {
        console.error('Erro ao listar clientes:', error);
        res.status(500).json({ message: 'Erro ao listar clientes' });
    }
};

export const getClienteById = async (req: Request, res: Response) => {
    try {
        const clienteId = parseInt(req.params.id, 10); // Obter o ID do cliente a partir dos parâmetros da solicitação
        const cliente = await Cliente.findByPk(clienteId);

        if (cliente) {
            res.json(cliente); // Cliente encontrado, retorne-o como resposta
        } else {
            res.status(404).json({ message: 'Cliente não encontrado' }); // Cliente não encontrado
        }
    } catch (error) {
        console.error('Erro ao buscar cliente:', error);
        res.status(500).json({ message: 'Erro ao buscar cliente' });
    }
};

export const excluirCliente = async (req: Request, res: Response) => {
    try {
        const clienteId = parseInt(req.params.id, 10);

        // Verifica se o cliente existe
        const cliente = await Cliente.findByPk(clienteId);
        if (!cliente) {
            return res.status(404).json({ message: 'Cliente não encontrado' });
        }

        // Verifica se o cliente possui pedidos vinculados
        const pedidosDoCliente = await Pedido.findAll({ where: { id_cliente: clienteId } });
        if (pedidosDoCliente.length > 0) {
            return res.status(400).json({ message: 'Não é possível excluir o cliente, pois há pedidos vinculados a ele.' });
        }

        // Se não houver pedidos vinculados, procede com a exclusão
        await cliente.destroy();
        res.json({ message: 'Cliente excluído com sucesso' });
    } catch (error) {
        console.error('Erro ao excluir cliente:', error);
        res.status(500).json({ message: 'Erro ao excluir cliente' });
    }
};

export const atualizarCliente = async (req: Request, res: Response) => {
    try {
        const clienteId = parseInt(req.params.id, 10);
        const { nome, sobrenome, cpf } = req.body;

        const cliente = await Cliente.findByPk(clienteId);

        if (cliente) {
            await cliente.update({ nome, sobrenome, cpf });
            res.json(cliente);
        } else {
            res.status(404).json({ message: 'Cliente não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar cliente:', error);
        res.status(500).json({ message: 'Erro ao atualizar cliente' });
    }
};

export const incluirCliente = async (req: Request, res: Response) => {
    try {
        const { nome, sobrenome, cpf } = req.body;
        const novoCliente = await Cliente.create({ nome, sobrenome, cpf });

        res.status(201).json(novoCliente);
    } catch (error) {
        console.error('Erro ao incluir cliente:', error);
        res.status(500).json({ message: 'Erro ao incluir cliente' });
    }
};