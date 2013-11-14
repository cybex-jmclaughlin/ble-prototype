#!/usr/bin/env coffee

shell = require('shell')
CybexPeripheral = require('./cybex_peripheral').CybexPeripheral

app = new shell( chdir: __dirname , prompt: 'cybex> ')
peripheral = new CybexPeripheral('CybexBlePeripheral')

app.configure ->
  app.use shell.history(shell: app)
  app.use shell.completer(shell: app)
  app.use shell.router(shell: app)
  app.use shell.help(shell: app, introduction: true)

app.cmd 'start', 'Start peripheral', (req, res) =>
  peripheral.stop()
  res.white('Starting peripheral...')
  res.bold()

  cancel = =>
    res.red('timeout!').ln()
    res.prompt()

  timeout = setTimeout cancel, 2000

  peripheral.start =>
    clearTimeout timeout
    res.bold()
    res.green('started').ln()
    res.prompt()

app.cmd 'services', 'Print peripheral services', (req, res) =>
  res.bold().white()

  peripheral.print (line) =>
    res.print(line).ln()

  res.prompt()

app.cmd 'set :service :characteristic :value', 'Set characteristic value', (req, res) =>
  peripheral.set req.params.service, req.params.characteristic, req.params.value
  res.prompt()

cleanup = ->
  console.log "Stopping peripheral\n"
  peripheral.stop()
  process.exit 0

app.on 'quit', cleanup
process.on 'SIGINT', cleanup
