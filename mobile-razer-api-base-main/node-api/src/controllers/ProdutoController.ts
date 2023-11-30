import { Request, Response } from 'express';
import { Produto } from '../models/Produto';
import { Cliente } from '../models/Cliente';
import { Pedido } from '../models/Pedido';


export const listarProdutos = async (req: Request, res: Response) => {
    try {
        const produtos = await Produto.findAll();
        res.json({ produtos });
    } catch (error) {
        console.error('Erro ao listar produtos:', error);
        res.status(500).json({ message: 'Erro ao listar produtos' });
    }
};

export const incluirProduto = async (req: Request, res: Response) => {
    try {
        const { descricao } = req.body;
        const novoProduto = await Produto.create({ descricao });

        res.status(201).json(novoProduto);
    } catch (error) {
        console.error('Erro ao incluir produto:', error);
        res.status(500).json({ message: 'Erro ao incluir produto' });
    }
};

export const atualizarProduto = async (req: Request, res: Response) => {
    try {
        const produtoId = parseInt(req.params.id, 10);
        const { descricao } = req.body;

        const produto = await Produto.findByPk(produtoId);

        if (produto) {
            await produto.update({ descricao });
            res.json(produto);
        } else {
            res.status(404).json({ message: 'Produto não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao atualizar produto:', error);
        res.status(500).json({ message: 'Erro ao atualizar produto' });
    }
};

export const excluirProduto = async (req: Request, res: Response) => {
    try {
        const produtoId = parseInt(req.params.id, 10);
        const produto = await Produto.findByPk(produtoId);

        if (produto) {
            await produto.destroy();
            res.json({ message: 'Produto excluído com sucesso' });
        } else {
            res.status(404).json({ message: 'Produto não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao excluir produto:', error);
        res.status(500).json({ message: 'Erro ao excluir produto' });
    }
};

export const getProdutoById = async (req: Request, res: Response) => {
    try {
        const produtoId = parseInt(req.params.id, 10);
        const produto = await Produto.findByPk(produtoId);

        if (produto) {
            res.json(produto);
        } else {
            res.status(404).json({ message: 'Produto não encontrado' });
        }
    } catch (error) {
        console.error('Erro ao buscar produto:', error);
        res.status(500).json({ message: 'Erro ao buscar produto' });
    }
};