{Adapter,TextMessage} = require 'hubot'

io = require('socket.io-client')

class SocketIO extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit process.env.BALLYCHAT_SEND_MESSAGE, {msg:str, room:'home'}

  reply: (user, strings...) ->
    for str in strings
      @socket.emit process.env.BALLYCHAT_SEND_MESSAGE, {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    self = @
    socket = io.connect process.env.BALLYCHAT_URL
    
    socket.on 'connect', =>
      @socket = socket
      console.log 'socket.io connected'
      self.emit 'connected'


    socket.on process.env.BALLYCHAT_REC_MESSAGE, (message) =>
      @receive new TextMessage message.nickname, message.msg

exports.use = (robot) ->
  new SocketIO robot
