import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../instances/mysql';

export interface ProdutoInstance extends Model {
    id: number;
    descricao: string;
}

export const Produto = sequelize.define<ProdutoInstance>('Produto', {
    id: {
        primaryKey: true,
        autoIncrement: true,
        type: DataTypes.INTEGER
    },
    descricao: {
        type: DataTypes.STRING
    },
}, {
    tableName: 'produtos',
    timestamps: false
});
