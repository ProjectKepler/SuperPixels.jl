function getedgemap(imagedata::Array{Float64, 3})
  channels, imagewidth, imageheight = size(imagedata)
  edgemap = zeros(imagewidth, imageheight)
  for pixely in 2:imageheight-1
    for pixelx in 2:imagewidth-1
      dx = ((imagedata[1, pixelx-1, pixely] * imagedata[1, pixelx+1, pixely])^2
          + (imagedata[2, pixelx-1, pixely] * imagedata[2, pixelx+1, pixely])^2
          + (imagedata[3, pixelx-1, pixely] * imagedata[3, pixelx+1, pixely])^2)

      dy = ((imagedata[1, pixelx, pixely-1] * imagedata[1, pixelx, pixely+1])^2
          + (imagedata[2, pixelx, pixely-1] * imagedata[2, pixelx, pixely+1])^2
          + (imagedata[3, pixelx, pixely-1] * imagedata[3, pixelx, pixely+1])^2)
      edgemap[pixelx, pixely] = dx + dy
    end
  end
  return edgemap
end
