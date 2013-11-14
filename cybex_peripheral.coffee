bleno = require('bleno')

GenericPeripheral = require('./lib/generic_peripheral').GenericPeripheral

class CybexPeripheral extends GenericPeripheral
  @service 'workout', '1CA931A8-6A77-4E4D-AAD8-5CA168163BA6',
    elapsed_seconds:
      uuid: '1799649B-7C99-48B1-98CF-0B7DCDA597A7'
    meters_travelled:
      uuid: '45186DD6-06E7-44A2-A5EA-BC9C45B7E2B5'
    meters_per_hour:
      uuid: 'B7CF5C63-9C07-40C7-A6AD-6AA6D8ED031D'
    calories_burned:
      uuid: '3D00BEF9-375D-40DE-88DB-F220631BD8A4'
    calories_per_hour:
      uuid: 'AC869A9F-9754-44AB-A280-C61B7A6D15BE'
    current_power:
      uuid: '6E1EA3E8-CF5E-45C5-A61C-2F338220A77F'
    current_heart_rate:
      uuid: 'C9F0DCBF-DD99-4282-B74B-AC44BB5C013E'
    strides_per_minute:
      uuid: '065806B9-7AC6-4DCC-B42C-96BB712E0CEB'
    current_mets:
      uuid: 'E4A234EA-DC68-4B07-B435-485B9B3406FD'

  @service 'equipment', '5748216D-3C4A-491E-9138-467824E8F270',
    serial:
      type: 'string'
      uuid: '6E12ADE7-11B0-44F7-921A-0C11FB9B2BD1'
    model:
      type: 'string'
      uuid: '74371EF2-4C10-4494-BE1A-0503FC844CC9'

exports.CybexPeripheral = CybexPeripheral
