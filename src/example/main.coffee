define (require, exports, module) ->
  console.log 'Yo!'
  console.log 'Whats Up!'
  Worker = require './image-worker'
  sea_opts =
    base: '../dist'
  Worker.config sea_opts
  worker = new Worker()

  $(document).ready ->
    console.log 'Page Ready'
    $canvas = $('#src')
    src_canvas = $canvas[0]
    src_ctx = src_canvas.getContext '2d'
    $canvas = $('#dst')
    dst_canvas = $canvas[0]
    dst_ctx = dst_canvas.getContext '2d'
    $status = $('#status')

    $canvas.mousedown ->
      $canvas.animate opacity: 0
    $canvas.mouseup ->
      $canvas.animate opacity: 1
    img = new Image()
    img.onload = ->
      $status.text "Image Ready"
      width = src_canvas.width = dst_canvas.width = img.width
      height = src_canvas.height = dst_canvas.height = img.height
      src_ctx.drawImage img, 0, 0, width, height
      img_src = src_ctx.getImageData 0, 0, width, height
      img_dst = dst_ctx.createImageData img_src
      $status.text  "Start Processing"
      worker.sharpen img_src, img_dst
        .then (dst) ->
          $status.text "Complete (hold mouse on canvas to see orignal version)"
          dst_ctx.putImageData dst, 0, 0#, width, height
    img.src = 'cat-break-couple.jpg'
