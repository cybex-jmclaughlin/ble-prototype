class UUID
  @transform: (s) ->
    s.toLowerCase().replace(/-/g, '')

exports.UUID = UUID
