function marksegments(imagedata::Array{Float64, 3}, labels::Array{Int64, 2})
  channels, imagewidth, imageheight = size(imagedata)
  dx = [-1, -1,  0,  1, 1, 1, 0, -1]
  dy = [ 0, -1, -1, -1, 0, 1, 1,  1]
  taken = zeros(imagewidth, imageheight)
  output = copy(imagedata)
  for pixely in 1:imageheight
    for pixelx in 1:imagewidth
      count = 0
      for index in 1:8
        neighbourx = pixelx + dx[index]
        neighboury = pixely + dy[index]
        if (1 <= neighbourx <= imagewidth) && (1 <= neighboury <= imageheight)
          if labels[pixelx, pixely] != labels[neighbourx, neighboury]
            count += 1
          end
        end
      end

      if count > 1
        output[1, pixelx, pixely] = 1.0
        output[2, pixelx, pixely] = 0.0
        output[3, pixelx, pixely] = 0.0

        taken[pixelx, pixely] = 1.0
      end
    end
  end
  return output, taken
end
