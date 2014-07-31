define (require, exports, module) ->
  SeaWorker = require '../worker'
  require './image-util'
  # @nodoc
  class ImageWorker extends SeaWorker
    @worker_service 'sharpen', (img_src, img_dst) ->
      console.log "Sharpening"
      img_src.each_n4 (p, N) ->
        n_r = n_g = n_b = 0
        for n in N
          n_r += n.r
          n_g += n.g
          n_b += n.b
        d_r = p.r * 5 - n_r
        d_g = p.g * 5 - n_g
        d_b = p.b * 5 - n_b
        d_a = p.a
        #console.log "#{d_r} = #{p.r} * 5 - #{n_r}"
        img_dst.setRGBA p.i, d_r, d_g, d_b, d_a
      #img_data.data = I
      return img_dst

    @worker_service 'sepia', (src) ->
      src.each (p) ->
        r = 0.393 * p.r + 0.769 * p.g + 0.189 * p.b
        g = 0.349 * p.r + 0.686 * p.g + 0.168 * p.b
        b = 0.272 * p.r + 0.534 * p.g + 0.131 * p.b
        src.setRGBA p.i, r, g, b, p.a

      return src
  SeaWorker.register ImageWorker

  module.exports = ImageWorker
