bleno = require('bleno')
pad = require('pad')
padded_print = require('./padded_print')

class Transformer
  @lookup: (key) ->
    switch key
      when 'float'
        @FLOAT
      when 'string'
        @STRING
      else
        @INTEGER

  @INTEGER:
    get_buffer: (value = 0) ->
      data = new Buffer(4)
      data.writeUInt32LE value, 0
      data

    transform_value: (value) ->
      parseInt value

    inverse_transform_value: (data) ->
      data.readUInt32LE 0, true

  @FLOAT:
    get_buffer: (value = 0.0) ->
      data = new Buffer(4)
      data.writeFloatLE value, 0
      data

    transform_value: (value) ->
      parseFloat value

    inverse_transform_value: (data) ->
      data.readFloatLE 0, true

  @STRING:
    get_buffer: (value = '') ->
      new Buffer(value)

    transform_value: (value) ->
      '' + value

    inverse_transform_value: (data) ->
      data.toString('utf8')


class Characteristic extends bleno.Characteristic
  constructor: (options={}) ->
    @name = options.name
    @transformer = Transformer.lookup(options.type)
    super options

  set_value: (value) =>
    new_value = @transformer.transform_value('' + value)
    return if new_value == @value

    @value = new_value
    @subscribe_callback @transformer.get_buffer(@value) if @subscribe_callback

  onSubscribe: (max_size, @subscribe_callback) =>
    # no-op, set subscribe_callback

  onReadRequest: (offset, callback) =>
    buffer = @transformer.get_buffer(@value)

    if offset > buffer.length
      callback this.RESULT_INVALID_OFFSET, null
    else
      callback this.RESULT_SUCCESS, buffer

  onWriteRequest: (data, offset, withoutResponse, callback) =>
    @set_value @transformer.inverse_transform_value(data)
    callback this.RESULT_SUCCESS

  print: (print_function, level=0) =>
    value = "#{@value}"

    padded_print print_function, level, "#{pad @name + ':', 30}#{@uuid} #{pad 20,value}"

exports.Characteristic = Characteristic
