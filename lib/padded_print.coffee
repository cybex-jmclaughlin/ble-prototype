module.exports = (fn, pad, string) ->
  prefix = ''
  for i in [0 ... pad]
    prefix += '  '
  fn "#{prefix}#{string}"
