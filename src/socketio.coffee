{Adapter,TextMessage} = require 'hubot'

io = require('socket.io-client')

class SocketIO extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    for str in strings
      @socket.emit 'message:post', {msg:str, room:'home'}

  reply: (user, strings...) ->
    for str in strings
      @socket.emit 'message:post', {msg:"#{user.name}: #{str}",room:'home'}


  run: ->
    self = @
    socket = io.connect 'http://ballychat.nodejitsu.com/'
    
    socket.on 'connect', =>
      @socket = socket
      self.emit 'connected'


    socket.on 'message:get', (message) =>
      @receive new TextMessage message.nickname, message.msg unless message.nickname = self.robot.name

exports.use = (robot) ->
  new SocketIO robot