DBus = require('dbus')
dbus = new DBus()
bus = dbus.getBus('system')
q = require('q')

class MediaPlayer
  find_media_player: ->
    defer = q.defer()
    if @media_player
      defer.resolve(@media_player)
    else
      bus.getInterface "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", (err, manager) =>
        console.log "ERROR: #{err}" if err

        manager.GetManagedObjects.finish = (objects) ->
          for key, object of objects
            media_player = object['org.bluez.MediaPlayer1']
            if media_player
              bus.getInterface "org.bluez", key, "org.bluez.MediaPlayer1", (err, media_player) =>
                if media_player
                  @media_player = media_player
                  defer.resolve @media_player

        manager.GetManagedObjects()

    defer.promise

  promised: (method) ->
    defer = q.defer()
    @find_media_player().then (media_player) ->
      media_player[method].finish = defer.resolve
      media_player[method]()
    defer.promise

  play: -> @promised 'Play'
  pause: -> @promised 'Pause'
  previous: -> @promised 'Previous'
  next: -> @promised 'Next'

exports.MediaPlayer = MediaPlayer
