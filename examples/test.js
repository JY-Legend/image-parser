var element = document.getElementById('canvas')

var context = element.getContext('2d')

var width = testImage.width
var height = testImage.height

var image = context.createImageData(width, height)

for (var i = 0; i < width; i++) {
  for (var j = 0; j < height; j++) {
    var index = (i + j * width) * 4

    var k = i + j * width

    image.data[index] = testImage.data[k][0]
    image.data[index + 1] = testImage.data[k][1]
    image.data[index + 2] = testImage.data[k][2]
    image.data[index + 3] = testImage.data[k][3]
  }
}

context.putImageData(image, 0, 0)
