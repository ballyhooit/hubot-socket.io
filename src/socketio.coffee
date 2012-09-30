{Adapter,TextMessage} = require 'hubot'

port = parseInt process.env.HUBOT_SOCKETIO_PORT or 9090

io = require('socket.io-client').connet process.env.BALLYCHAT_URL

if process.env.HEROKU_URL 
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling-duration", 10

class SocketIO extends Adapter

  constructor: (@robot) ->
    @sockets = {}
    super @robot

  send: (user, strings...) ->
    socket = @sockets[user.id]
    for str in strings
      socket.emit 'me:message:send', {msg:str, room:'home'}

  reply: (user, strings...) ->
    socket = @sockets[user.id]
    for str in strings
      socket.emit 'me:message:send', {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    io.sockets.on 'connection', (socket) =>
      @sockets[socket.id] = socket

      socket.on 'message:send', (message) =>
        user = @userForId socket.id, name: 'Try Hubot', room: socket.id
        @receive new TextMessage message.nickname, message.msg

      socket.on 'disconnect', =>
        delete @sockets[socket.id]

    @emit 'connected'

exports.use = (robot) ->
  new SocketIO robot
