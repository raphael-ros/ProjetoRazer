import { Model, DataTypes } from 'sequelize';
import { sequelize } from '../instances/mysql';

export interface ClienteInstance extends Model {
    id: number;
    nome: string;
    sobrenome: string;
    cpf: string;
}

export const Cliente = sequelize.define<ClienteInstance>('Cliente', {
    id: {
        primaryKey: true,
        autoIncrement: true,
        type: DataTypes.INTEGER
    },
    nome: {
        type: DataTypes.STRING
    },
    sobrenome: {
        type: DataTypes.STRING
    },
    cpf: {
        type: DataTypes.STRING,
        unique: true
    },
}, {
    tableName: 'clientes',
    timestamps: false
});