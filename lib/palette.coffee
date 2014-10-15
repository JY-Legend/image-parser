fs = require 'fs'
q = require 'q'

class Palette
  color: (index) ->
    r = @buffer.readUInt8(index * 3) * 4
    g = @buffer.readUInt8(index * 3 + 1) * 4
    b = @buffer.readUInt8(index * 3 + 2) * 4

    [r, g, b, 255]

  load: (path) ->
    deferred = q.defer()

    fs.readFile path + '.COL', (err, buffer) =>
      deferred.reject err if err

      @buffer = buffer

      deferred.resolve()

    deferred.promise

module.exports = Palette
