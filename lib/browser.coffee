DBus = require('dbus')
dbus = new DBus()
bus = dbus.getBus('system')
q = require('q')

class Browser
  find_media_folder1: ->
    defer = q.defer()
    if @media_folder1
      defer.resolve(@media_folder1)
    else
      bus.getInterface "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", (err, manager) =>
        console.log "ERROR: #{err}" if err

        manager.GetManagedObjects.finish = (objects) ->
          for key, object of objects
            if object['org.bluez.MediaFolder1']
              bus.getInterface "org.bluez", key, "org.bluez.MediaFolder1", (err, media_folder1) =>
                if media_folder1
                  @media_folder1 = media_folder1
                  defer.resolve @media_folder1
        manager.GetManagedObjects()

    defer.promise

  listChildren: ->
    defer = q.defer()
    @find_media_folder1().then (media_folder) =>

      media_folder.ListItems.error = console.log
      media_folder.ListItems.finish = (children) =>
         @children = children
         defer.resolve @children
      media_folder.ListItems({})

    defer.promise

  open: (selection) ->
    @listChildren().then (children) =>
      keys = (key for key, value of children)
      items = (value for key, value of children)
      if selection is 'root'
        root_path = (items[0]).Player
        @changeFolder("#{root_path}/Filesystem")
      else
        media_selection = items[selection]
        media_path = keys[selection]
        @play(media_selection, media_path)

  play: (media_selection, media_path) ->
    root = "#{media_selection.Player}/Filesystem"
    if media_selection.Playable
      bus.getInterface "org.bluez", media_path, "org.bluez.MediaItem1", (err, media) =>
        console.log "ERROR: #{err}" if err
        media.Play()
    else
      @find_media_folder1().then (media_folder) =>
        media_folder.ChangeFolder(media_path)

  changeFolder: (path) =>
    @find_media_folder1().then (media_folder) =>
      media_folder.ChangeFolder(path)

exports.Browser = Browser
