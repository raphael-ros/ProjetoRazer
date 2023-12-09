// Agora, vamos corrigir a associação no modelo Pedido
import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../instances/mysql';
import { Cliente, ClienteInstance } from './Cliente';
import { ItemDoPedido, ItemDoPedidoInstance } from './ItemDoPedido';

export interface PedidoInstance extends Model {
    id: number;
    data: Date;
    id_cliente: number;
    Cliente: ClienteInstance;
    ItensDoPedido: ItemDoPedidoInstance[];
}

export const Pedido = sequelize.define<PedidoInstance>('Pedido', {
    id: {
        primaryKey: true,
        autoIncrement: true,
        type: DataTypes.INTEGER
    },
    data: {
        type: DataTypes.DATE
    },
    id_cliente: {
        type: DataTypes.INTEGER,
        references: {
            model: Cliente,
            key: 'id'
        }
    },
}, {
    tableName: 'pedidos',
    timestamps: false
});

// Defina a associação corretamente
Pedido.belongsTo(Cliente, { foreignKey: 'id_cliente' });
Pedido.hasMany(ItemDoPedido, { foreignKey: 'id_pedido' });
Pedido.hasMany(ItemDoPedido, { foreignKey: 'id_pedido', as: 'ItensDoPedido' });