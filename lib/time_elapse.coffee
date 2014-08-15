bleno = require('bleno')
CybexPeripheral = require('./cybex_peripheral').CybexPeripheral

peripheral = new CybexPeripheral('CybexBlePeripheral')

TIME_INT = 1000
i = 0

class Timestamp
  constructor: ->
    @startTime = 0
    @elapsed = 0
    @firstRun = true

  start: ->
    if @firstRun
      @startTime = @elapsed = new Date().getTime()
      @firstRun = false
      @startTime
    else
      @elapsed = new Date() - @startTime - (i * TIME_INT)

t = new Timestamp

char = ['elapsed_seconds', 'meters_travelled', 'meters_per_hour', 'calories_burned', 'calories_per_hour', 'current_power', 'current_heart_rate', 'strides_per_minute', 'current_mets']

set_time_attribute = ->
  peripheral.set('workout', char[i], t.start())
  i++
  if i == char.length
    clearInterval(set_attr)

peripheral.start()
set_attr = setInterval ( -> set_time_attribute() ), TIME_INT


# Prints out peripheral characteristics after 10 seconds to show final output
setTimeout ( -> peripheral.print() ), 10000

