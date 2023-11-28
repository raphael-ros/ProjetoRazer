import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../instances/mysql';
import { Cliente } from './Cliente';

export interface PedidoInstance extends Model {
    id: number;
    data: Date;
    id_cliente: number;
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
            key: 'id_cliente'
        }
    },
}, {
    tableName: 'pedidos',
    timestamps: false
});

