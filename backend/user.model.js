// user.model.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Definimos un sub-esquema para los mensajes del historial de conversación
const conversationSchema = new Schema({
    sender: { type: String, required: true },
    message: { type: String, required: true },
    timestamp: { type: Date, required: true }
}, { _id: false }); // _id: false evita que Mongoose cree un ID para cada mensaje

// Este es el esquema principal que coincide con tu documento
const userSchema = new Schema({
    whatsapp_number: { type: String },
    business_name: { type: String },
    recommendation: { type: String },
    createdAt: { type: Date },
    lastBotInteraction: { type: Date },
    // Aquí definimos que 'conversationHistory' es un arreglo de objetos
    // que siguen la estructura de 'conversationSchema'
    conversationHistory: [conversationSchema]
}, {
    timestamps: false, // Desactivamos timestamps porque ya tienes 'createdAt'
    collection: 'users' // Le decimos explícitamente que la colección se llama 'users'
});

const User = mongoose.model('User', userSchema);

module.exports = User;