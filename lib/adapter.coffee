DBus = require('dbus')
dbus = new DBus()
bus = dbus.getBus('system')
q = require('q')

class Adapter
  @find: (hci)->
    defer = q.defer()
    bus.getInterface "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", (err, manager) ->
      manager.GetManagedObjects.finish = (objects) ->
        if objects["/org/bluez/hci#{hci}"]
          defer.resolve(new Adapter(hci, objects["/org/bluez/hci#{hci}"]))

      manager.GetManagedObjects()
    defer.promise

  constructor: (@hci, @dbus_object) ->

  power_cycle: ->
    @power(false).then => @power(true)

  power: (value)->
    defer = q.defer()
    @interface().then (iface) ->
      iface.setProperty 'Powered', value, (err) ->
        if err
          defer.reject err
        else
          defer.resolve(value)
    defer.promise

  interface: ->
     defer = q.defer()
     key = 'org.bluez.Adapter1'
     bus.getInterface "org.bluez", "/org/bluez/hci#{@hci}", "org.bluez.Adapter1", (err, adapter) ->
       defer.resolve adapter
     defer.promise

#Adapter.find(0).then (adapter) ->
#  adapter.power_cycle().then ->
#    console.log "done cycling power on hci 0"
exports.Adapter = Adapter
