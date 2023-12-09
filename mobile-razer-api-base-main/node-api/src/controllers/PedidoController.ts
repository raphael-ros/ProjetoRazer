import { Request, Response } from 'express';
import { Produto, ProdutoInstance } from '../models/Produto';
import { Cliente, ClienteInstance } from '../models/Cliente';
import { Pedido, PedidoInstance } from '../models/Pedido';
import { ItemDoPedido } from '../models/ItemDoPedido';

export const listarPedidos = async (req: Request, res: Response) => {
    try {
        const pedidos = await Pedido.findAll({
            include: [
                {
                    model: Cliente,
                },
                {
                    model: ItemDoPedido,
                    as: 'ItensDoPedido',
                    include: [
                        {
                            model: Produto,
                            attributes: ['id', 'descricao'],
                        },
                    ],
                },
            ],
        });
        // Mapeia o resultado para formatar a resposta conforme desejado
        const pedidosFormatados = pedidos.map((pedido: PedidoInstance) => {
            const clienteFormatado = {
                id: pedido.Cliente.id,
                nome: pedido.Cliente.nome,
                sobrenome: pedido.Cliente.sobrenome,
                cpf: pedido.Cliente.cpf,
            } as ClienteInstance;

            const itensDoPedidoFormatados = pedido.ItensDoPedido ? pedido.ItensDoPedido.map((itemDoPedido) => ({
                id: itemDoPedido.id,
                qtdade: itemDoPedido.qtdade,
                produto: {
                    id: itemDoPedido.id_produto,
                    descricao: itemDoPedido.Produto ? itemDoPedido.Produto.descricao : '',
                },
            })) : [];

            return {
                id: pedido.id,
                data: pedido.data,
                cliente: clienteFormatado,
                itensDoPedido: itensDoPedidoFormatados,
            };
        });



        res.json({ pedidos: pedidosFormatados });
    } catch (error) {
        console.error('Erro ao listar pedidos:', error);
        res.status(500).json({ message: 'Erro ao listar pedidos' });
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

