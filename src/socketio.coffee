{Adapter,TextMessage} = require 'hubot'

io = require('socket.io-client')

class SocketIO extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit 'me:message:send', {msg:str, room:'home'}

  reply: (user, strings...) ->
    for str in strings
      @socket.emit 'me:message:send', {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    @conCount = 0
    self = @
    socket = io.connect process.env.BALLYCHAT_URL
    
    socket.on 'connect', =>
      @socket = socket
      if self.conCount = 0
        console.log 'socket.io connected'
        self.emit 'connected'
        self.conCount++


    socket.on 'message:send', (message) =>
      @receive new TextMessage message.nickname, message.msg

    socket.on 'bot:join', (message) =>
      console.log message


exports.use = (robot) ->
  new SocketIO robot
