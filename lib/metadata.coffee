DBus = require('dbus')
dbus = new DBus()
bus = dbus.getBus('system')
q = require('q')
EventEmitter = require('events').EventEmitter

class MetadataListener
  constructor: ->
    @emitter = new EventEmitter()

  find_media_player1: ->
    defer = q.defer()
    if @media_player1
      defer.resolve(@media_player1)
    else
      bus.getInterface "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", (err, manager) =>
        console.log "ERROR: #{err}" if err

        i = 0
        manager.GetManagedObjects.finish = (objects) ->
          for key, object of objects
            if object['org.bluez.MediaPlayer1']
              bus.getInterface "org.bluez", key, "org.bluez.MediaPlayer1", (err, media_player1) =>
                if media_player1
                  @media_player1 = media_player1
                  defer.resolve @media_player1

        manager.GetManagedObjects()

    defer.promise

  find_media_player_properties: ->
    defer = q.defer()
    if @properties_interface
      defer.resolve @properties_interface
    else
      @find_media_player1().then (player)->
        bus.getInterface 'org.bluez', player.objectPath, 'org.freedesktop.DBus.Properties', (err, props) ->
          @properties_interface = props
          defer.resolve @properties_interface
    defer.promise

  on: (event, callback) -> @emitter.on event, callback
  off: (event, callback) -> @emitter.removeListener event, callback

  listen: ->
    defer = q.defer()
    @find_media_player_properties().then (properties) =>
      properties.GetAll.finish = (props) =>
        @properties = props
        @emitter.emit 'properties', props
        properties.on 'PropertiesChanged', (interface_name, changes) =>
          for key, value of changes
            @properties[key] = value
          for key, value of changes
            @emitter.emit 'propertyChanged', key, value
          @emitter.emit 'properties', props

        defer.resolve @properties
      properties.GetAll('org.bluez.MediaPlayer1')
    defer.promise

exports.MetadataListener = MetadataListener
