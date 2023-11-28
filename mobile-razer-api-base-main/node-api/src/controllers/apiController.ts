import { Request, Response } from 'express';
import { Produto } from '../models/Produto';
import { Cliente } from '../models/Cliente';
import { Pedido } from '../models/Pedido';

export const ping = (req: Request, res: Response) => {
    res.json({ pong: true });
}











// export const register = async (req: Request, res: Response) => {

//     const { email, password, name, discipline } = req.body;

//     if (email && password && name && discipline) {

//         let hasUser = await User.findOne({ where: { email } });
//         if (!hasUser) {
//             let newUser = await User.create({ email, password, name, discipline });

//             res.status(201);
//             return res.json({
//                 message: "Usuário cadastradado com sucesso.",
//                 newUser
//                 // id: newUser.id,
//                 // name: newUser.name,
//                 // email: newUser.email,
//                 // discipline: newUser.discipline
//             });
//         } else {
//             return res.json({ error: 'E-mail já existe.' });
//         }
//     }

//     return res.json({ error: 'E-mail e/ou senha não enviados.' });;
// }

// export const login = async (req: Request, res: Response) => {
//     if (req.body.email && req.body.password) {
//         let email: string = req.body.email;
//         let password: string = req.body.password;

//         let user = await User.findOne({
//             where: { email, password }
//         });

//         if (user) {
//             res.json({ status: true });
//             return;
//         }
//     }

//     res.json({ status: false });
// }

// export const listEmail = async (req: Request, res: Response) => {
//     let users = await User.findAll();
//     let list: string[] = [];

//     for (let i in users) {
//         list.push(users[i].email);
//     }

//     res.json({ list });
// }




// export const deleteUser = async (req: Request, res: Response) => {
//     const { id } = req.params;

//     try {
//         const user = await User.findByPk(id);

//         if (user) {
//             const deletedUserName = user.name; // Obtém o nome do usuário que será deletado

//             user.destroy();
//             await user.save(); // Salva as alterações do status



//             res.status(200).json({ message: `Usuário ${deletedUserName} foi removido com sucesso.`, status: '200' });
//         } else {
//             res.status(404).json({ message: `Usuário com ID ${id} não encontrado.`, status: '404' });
//         }
//     } catch (error) {
//         res.status(500).json({ message: 'Ocorreu um erro ao remover o usuário.', status: '500', error });
//     }
// }

// export const updateUser = async (req: Request, res: Response) => {
//     const { id } = req.params;
//     const values = req.body;

//     // Verificar se algum valor é vazio ou nulo
//     const isEmpty = Object.values(values).some((value) => value === null || value === '');

//     if (isEmpty) {
//         return res.status(400).json({ message: 'Os dados enviados estão incompletos.', status: '400' });
//     }

//     try {
//         const user = await User.findOne({ where: { id } });

//         if (!user) {
//             return res.status(404).json({ message: 'Usuário não encontrado.', status: '404' });
//         }

//         await User.update(values, { where: { id } });

//         const updatedUser = await User.findOne({ where: { id } });

//         return res.status(200).json({ message: 'Usuário atualizado com sucesso.', status: '200', updatedUser });
//     } catch (error) {
//         console.error(error);

//         return res.status(500).json({ message: 'Erro ao atualizar usuário.', status: '500', error });
//     }
// }