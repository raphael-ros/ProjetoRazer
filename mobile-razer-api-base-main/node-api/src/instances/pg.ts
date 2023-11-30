import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

//CRIAÇÃO DA MINHA CONEXÃO COM O BANCO DE DADOS COM POSTGREE
export const sequelize = new Sequelize(
    process.env.PG_DB as string,
    process.env.PG_USER as string,
    process.env.PG_PASSWORD as string,
    {
        dialect: 'postgres',
        port: parseInt(process.env.PG_PORT as string)
    }
);