bleno = require('bleno')

class NotifyReadWriteCharacteristic extends bleno.Characteristic
  #constructor: ->
  #  super uuid: @constructor.UUID, properties: ['notify', 'read', 'write']

  onSubscribe: (max_size, @subscribe_callback) =>
    # no-op, set subscribe_callback

  set_value: (value) =>
    @value = @transform_value(value)
    @subscribe_callback @get_buffer() if @subscribe_callback

  onReadRequest: (offset, callback) =>
    buffer = @get_buffer()

    if offset > buffer.length
      callback this.RESULT_INVALID_OFFSET, null
    else
      callback this.RESULT_SUCCESS, buffer

  onWriteRequest: (data, offset, withoutResponse, callback) =>
    @set_value @inverse_transform_value(data)
    callback this.RESULT_SUCCESS

class IntegerMetricCharacteristic extends NotifyReadWriteCharacteristic
  get_buffer: =>
    @value ||= 0
    data = new Buffer(4)
    data.writeUInt32LE @value, 0
    data

  transform_value: (value) ->
    parseInt value

  inverse_transform_value: (data) ->
    data.readUInt32LE 0, true

class FloatMetricCharacteristic extends NotifyReadWriteCharacteristic
  get_buffer: =>
    @value ||= 0.0
    data = new Buffer(4)
    data.writeFloatLE @value, 0
    data

  transform_value: (value) ->
    parseFloat value

  inverse_transform_value: (data) ->
    data.readFloatLE 0, true

class ElapsedSecondsCharacteristic extends IntegerMetricCharacteristic
  @UUID: '668e5bf0f5b846e6bca549d08edbcf8a'

class DistanceInKilometersCharacteristic extends FloatMetricCharacteristic
  @UUID: '2ad6176375f04bdb8a82a6a81b45a8af'

class WorkoutMetricsService extends bleno.PrimaryService
  @UUID: '1e0351650c69454db4f849a7dfd0b744'

  constructor: ->
    @elapsed_seconds_characteristic = new ElapsedSecondsCharacteristic()
    @distance_in_kilometers_characteristic = new DistanceInKilometersCharacteristic()

    super uuid: WorkoutMetricsService.UUID, characteristics: [
      @elapsed_seconds_characteristic,
      @distance_in_kilometers_characteristic
    ]

exports.WorkoutMetricsService = WorkoutMetricsService
exports.IntegerMetricCharacteristic = IntegerMetricCharacteristic
