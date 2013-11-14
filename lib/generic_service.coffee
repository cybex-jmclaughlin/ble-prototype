PrimaryService =require('bleno').PrimaryService
Characteristic = require('./characteristics').Characteristic
UUID = require('./uuid').UUID
padded_print = require('./padded_print')

class GenericService extends PrimaryService
  constructor: (@name, uuid, characteristics) ->
    @uuid = UUID.transform(uuid)
    @build_characteristics(characteristics)
    super uuid: @uuid, characteristics: (@__characteristics[key] for key in Object.keys(@__characteristics))

  build_characteristics: (characteristics) ->
    @__characteristics = {}
    for name in Object.keys(characteristics)
      @__characteristics[name] = new Characteristic(
        name: name,
        type: characteristics[name].type,
        uuid: UUID.transform(characteristics[name].uuid),
        properties: ['notify', 'read', 'write']
      )

  print: (print_function, level=0) =>
    padded_print print_function, level, "Service #{@name}"
    padded_print print_function, level + 1, "UUID: #{@uuid}"
    padded_print print_function, level + 1, "Characteristics:"

    for name in Object.keys(@__characteristics)
      @__characteristics[name].print print_function, level + 2

  set: (characteristic, value) =>
    @__characteristics[characteristic].set_value value

exports.GenericService = GenericService
