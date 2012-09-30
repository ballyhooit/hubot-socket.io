{Adapter,TextMessage} = require 'hubot'

port = parseInt process.env.HUBOT_SOCKETIO_PORT or 9090

io = require('socket.io-client').connect process.env.BALLYCHAT_URL

if process.env.HEROKU_URL 
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling-duration", 10

class SocketIO extends Adapter

  constructor: (@robot) ->
    @sockets = {}
    super @robot

  send: (user, strings...) ->
    for str in strings
      socket.emit 'me:message:send', {msg:str, room:'home'}

  reply: (user, strings...) ->
    for str in strings
      socket.emit 'me:message:send', {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    socket = io.connect process.env.BALLYCHAT_URL
    
    socket.on 'message:send', (message) =>
      @receive new TextMessage message.nickname, message.msg

exports.use = (robot) ->
  new SocketIO robot
