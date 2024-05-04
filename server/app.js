const express = require('express')
const app = express();
const http = require('http')
const server = http.createServer(app)
const {Server} = require('socket.io')
const io = new Server(server);
const messanges = []

io.on('connection', (socket) => {
    const username = socket.handshake.query.username;
    socket.on('message', data => {
        const message={
            message:data.message,
            username: username,
            // sendAt: Date.now()
        } 
        messanges.push(message)
        io.emit('message',message)
    })
})
server.listen(3000, () => {
    console.log('Listening on port 3000')
})
