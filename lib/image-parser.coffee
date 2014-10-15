fs = require 'fs'
q = require 'q'

TRANSPARENT_PIXEL = [0, 0, 0, 0]

class ImageParser
  constructor: (palette) ->
    @palette = palette

  _colorOf: (index) ->
    @palette.color index

  parse: (group, index) ->
    deferred = q.defer()

    image = {}

    fs.readFile group + '.IDX', (err, buffer) =>
      deferred.reject err if err

      if index is 0
        start = 0
      else
        start = buffer.readUInt32LE((index - 1) * 4)

      fs.readFile group + '.GRP', (err, buffer) =>
        image.width = buffer.readUInt16LE(start)
        image.height = buffer.readUInt16LE(start + 2)

        image.offset = {}
        image.offset.x = buffer.readUInt16LE(start + 4)
        image.offset.y = buffer.readUInt16LE(start + 6)

        image.data = []

        cursor = start + 8

        for i in [1..image.height]
          count = buffer.readUInt8(cursor)

          transparent = yes
          j = cursor

          while j isnt cursor + count
            j++

            if transparent
              num = buffer.readUInt8(j)

              if num > 0
                image.data.push(TRANSPARENT_PIXEL) for k in [1..num]

              transparent = no
            else
              num = buffer.readUInt8(j)

              if num > 0
                image.data.push(@_colorOf(buffer.readUInt8(j + k))) for k in [1..num]

              transparent = yes
              j += num

          # fill rest of the pixels with tranparent dots
          if image.data.length % image.width isnt 0
            num = image.width - (image.data.length % image.width)

            if num > 0
              image.data.push(TRANSPARENT_PIXEL) for k in [1..num]

          cursor = j + 1

        deferred.resolve(image)

    deferred.promise

module.exports = ImageParser
