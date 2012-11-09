{Adapter,TextMessage} = require 'hubot'

io = require('socket.io-client')
sendEvent = process.env.BALLYCHAT_SEND_MESSAGE || 'me:message:send'
recEvent = process.env.BALLYCHAT_REC_MESSAGE || 'message:send'

class SocketIO extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit sendEvent, {msg:str, room:'home'}

  reply: (user, strings...) ->
    for str in strings
      @socket.emit sendEvent, {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    self = @
    socket = io.connect process.env.BALLYCHAT_URL
    
    socket.on 'connect', =>
      @socket = socket
      console.log 'socket.io connected'
      self.emit 'connected'


    socket.on recEvent, (message) =>
      @receive new TextMessage message.nickname, message.msg unless message.nickname = self.robot.name

exports.use = (robot) ->
  new SocketIO robot
