Adapter = require('./adapter').Adapter
noble = require('noble')

HCI_ID = 1

UUID =
  service: '180d'
  hr: '2a37'

class HeartRateCentral
  constructor: (@cybex_ble_peripheral)->

  stop: (callback) ->
    Adapter.find(HCI_ID).then (adapter) ->
      adapter.power(false).then ->
        callback() if callback

  start: (callback) ->
    noble.on 'stateChange', (state) ->
      if 'poweredOn' == state
        noble.startScanning [UUID.service], false
      else
        # console.log "State: #{state}"

    noble.on 'discover', (peripheral) =>
      peripheral.on 'disconnect', -> noble.startScanning [UUID.service], false

      peripheral.connect (error) =>
        # console.log "connect, error=#{error}"
        noble.stopScanning()
        peripheral.discoverServices [UUID.service], (error, services) =>
          service = services[0]
          service.discoverCharacteristics [UUID.hr], (error, characteristics) =>
            characteristic = characteristics[0]
            characteristic.on 'read', (data, is_notification) =>
              @cybex_ble_peripheral.heart_rate data
              # console.log "READ (notification:#{is_notification}):  #{data}"
            characteristic.notify true


    Adapter.find(HCI_ID).then (adapter) ->
      adapter.power_cycle().then -> callback()

exports.HeartRateCentral = HeartRateCentral
