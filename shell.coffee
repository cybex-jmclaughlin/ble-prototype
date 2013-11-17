#!/usr/bin/env coffee

process.env['BLENO_HCI_DEVICE_ID'] = '0'
process.env['NOBLE_HCI_DEVICE_ID'] = '1'

shell = require('shell')
CybexPeripheral = require('./lib/cybex_peripheral').CybexPeripheral
HeartRateCentral = require('./lib/heart_rate_central').HeartRateCentral
MediaPlayer = require('./lib/media').MediaPlayer
MetadataListener = require('./lib/metadata').MetadataListener
Browser = require('./lib/browser').Browser

app = new shell( chdir: __dirname , prompt: 'cybex> ')
peripheral = new CybexPeripheral('CybexBlePeripheral')
heart_rate = new HeartRateCentral(peripheral)
media_player = new MediaPlayer()
metadata_listener = new MetadataListener
browser = new Browser

show_metadata = (req, res) ->
  metadata_listener.listen().then (properties) ->
    if properties.Track
      res.white("#{properties.Status}: #{properties.Track.Title} by #{properties.Track.Artist}").ln()
    else
      res.white("#{properties.Status}").ln()
    res.prompt()

list_media = (req, res) ->
  browser.listChildren().then (children) ->
    res.white('root').ln()
    i = 0
    for key, item of children
      res.white("#{i++}: #{item.Name.replace /\/Filesystem\//g, ""}").ln()
    res.prompt()

open_media = (req, res) ->
  browser.open(req.params.selection)
  res.prompt()

app.configure ->
  app.use shell.history(shell: app)
  app.use shell.completer(shell: app)
  app.use shell.router(shell: app)
  app.use shell.help(shell: app, introduction: true)

app.cmd 'start', 'Start peripheral', (req, res) =>
  # peripheral.stop()
  # heart_rate.stop()
  res.white('Starting peripheral...')

  cancel = =>
    res.red('timeout!').ln()
    res.prompt()

  timeout = setTimeout cancel, 2000

  heart_rate.start =>
    res.green('started heart rate').ln()

  peripheral.start =>
    clearTimeout timeout
    res.bold()
    # res.green('started').ln()
    res.prompt()

app.cmd 'stop', 'Stop peripheral', (req, res) =>
  res.white('Stopping peripheral...')
  # res.bold()

  cancel = =>
    res.red('timeout!').ln()
    res.prompt()

  timeout = setTimeout cancel, 2000

  heart_rate.stop =>
    res.red('stopped heart rate').ln()

  peripheral.stop =>
    clearTimeout timeout
    res.prompt()

app.cmd 'services', 'Print peripheral services', (req, res) =>
  res.bold().white()

  peripheral.print (line) =>
    res.print(line).ln()

  res.prompt()

app.cmd 'set :service :characteristic :value', 'Set characteristic value', (req, res) =>
  peripheral.set req.params.service, req.params.characteristic, req.params.value
  res.prompt()

deferred = (command, title) ->
  app.cmd command, title, (req, res) =>
    media_player[command]().then ->
      setTimeout (->show_metadata req, res), 500
  
deferred 'play', 'Play music'
deferred 'pause', 'Pause music'
deferred 'previous', 'Skip to previous track'
deferred 'next', 'Skip to next track'
app.cmd 'metadata', 'Show audio metadata', show_metadata
app.cmd 'list-media', 'List available playlists & tracks', list_media
app.cmd 'open :selection', 'Select a playlist or track', open_media

cleanup = ->
  peripheral.stop ->
    setTimeout (-> process.exit 0), 1000
    heart_rate.stop ->
      process.exit 0

app.on 'quit', cleanup
process.on 'SIGINT', cleanup
