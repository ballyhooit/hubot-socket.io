{Adapter,TextMessage} = require 'hubot'

nconf.env().file 'config.json'
io = require('socket.io-client')
sendEvent = nconf.get 'BALLYCHAT_SEND_MESSAGE' || 'message:post'
recEvent = nconf.get 'BALLYCHAT_REC_MESSAGE' || 'message:get'
joinEvent = nconf.get 'BALLYCHAT_JOIN' || 'join:request'

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
    socket = io.connect nconf.get 'BALLYCHAT_URL' 
    
    socket.on 'connect', =>
      @socket = socket
      console.log 'socket.io connected'
      self.emit 'connected'


    socket.on recEvent, (message) =>
      @receive new TextMessage message.nickname, message.msg unless message.nickname = self.robot.name

exports.use = (robot) ->
  new SocketIO robot
