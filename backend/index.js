// index.js (Versión Final)

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const User = require('./user.model');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)



    .then(() => {
        console.log("✅ ¡Conexión a MongoDB Atlas establecida exitosamente!");
    })
    .catch(err => {
        console.error("❌ Error al conectar a MongoDB:", err);
    });

app.get('/api/users', async (req, res) => {
    try {
        const { busqueda } = req.query;
        let filtro = {};

        if (busqueda) {
            filtro.business_name = { $regex: busqueda, $options: 'i' };
        }

        const users = await User.find(filtro);
        res.json(users);

    } catch (error) {
        console.error("Error detallado en la ruta /api/users:", error);
        res.status(500).json({ message: 'Error en el servidor', error: error.message });
    }
});

app.listen(port, () => {
    console.log(`🚀 Servidor corriendo en el puerto: ${port}`);
});
