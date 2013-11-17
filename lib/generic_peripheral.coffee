Adapter = require('./adapter').Adapter
bleno = require('bleno')
GenericService = require('./generic_service.coffee').GenericService

class GenericPeripheral
  @SERVICES: {}
  HCI_ID = 0

  @service: (name, uuid, characteristics) ->
    @SERVICES[name] =
      uuid : uuid,
      characteristics: characteristics

  constructor: (@name = 'Generic Peripheral') ->
    @_build_services()
    bleno.on 'advertisingStart', =>
      bleno.setServices  (@services[key] for key in Object.keys(@services))

  stop: (callback) =>
    bleno.stopAdvertising()
    Adapter.find(HCI_ID).then (adapter) ->
      adapter.power(false).then ->
        callback() if callback

  start: (callback) =>
    bleno.once 'advertisingStart', callback if callback
    Adapter.find(HCI_ID).then (adapter) =>
      adapter.power_cycle().then =>
        if 'poweredOn' == bleno.state
          @_start_advertising()
        else
          bleno.on 'stateChange', (state) =>
            if 'poweredOn' == state
              @_start_advertising()
            else
              bleno.stopAdvertising()

  print: (print_function = console.log, level = 0) =>
    print_function "Peripheral #{@name}"
    for name in Object.keys(@services)
      @services[name].print print_function, level + 1

  set: (service, characteristic, value) =>
    @services[service].set characteristic, value

  _start_advertising: =>
    bleno.stopAdvertising =>
      key = Object.keys(@services)[0]
      bleno.startAdvertising @name, [@services[key].uuid]

  _build_services: ->
    @services = {}
    for name in Object.keys(@constructor.SERVICES)
      attributes = @constructor.SERVICES[name]
      @services[name] = new GenericService(name, attributes.uuid, attributes.characteristics)

exports.GenericPeripheral = GenericPeripheral
