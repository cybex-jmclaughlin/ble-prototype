#!/usr/bin/env coffee

SerialPort = require('serialport').SerialPort
CybexPeripheral = require('./cybex_peripheral').CybexPeripheral

puts = console.log

peripheral = new CybexPeripheral('CybexBlePeripheral')
peripheral.start()
port = new SerialPort('/dev/ttyUSB0', baudrate: 115200, parity: 'none', databits: 8)

#metrics cal=0 cph=0 met=0 units=km spd=0 dist=0 inc=0 pace=0 hrg=op bpm=0 ptime=0 watt=0 elapsed=0 last_start=0 points=0 VO2max=0 ranking=none sub_rank=none time_in_zone=0 stage=0 cooldown=false target_spm=0 avg_spm=0 avg_spd=0 avg_pace=0 avg_bpm=0 max_bpm=0 spm=0 


transform_int = (key, scale=1)->
  (metric) ->
    if metric[key]?
      parseInt(parseInt(metric[key]) * scale)

transform =
  elapsed_seconds: transform_int('elapsed')
  calories_per_hour: transform_int('cph')
  strides_per_minute: transform_int('spm')
  current_mets: transform_int('met')
  calories_burned: transform_int('cal', 0.01)
  current_heart_rate: transform_int('bpm')

pattern = /((\S+)=(\S+))/g

parse_buffer = (buffer) ->
  metric = {}

  while(match = pattern.exec(buffer))
    metric[match[2]] = match[3]

  for key in Object.keys(transform)
    val = transform[key](metric)
    if val
      peripheral.set 'workout', key, val

port.on 'open', =>
  next_metrics = =>
    port.write "metrics all\r"

  setInterval next_metrics, 333 #get next metrics 3x / second

  buffer = ''
  port.on 'data', (data) =>
    buffer += data
    if /\s+MCC> $/.test(buffer)
      parse_buffer buffer
      buffer = ''

  port.write "\r", (err, results) =>
    puts "err: #{err}, res: #{results}" if err


process.on 'SIGINT', ->
  console.log 'stopping peripheral'
  peripheral.stop()
  process.exit 0
