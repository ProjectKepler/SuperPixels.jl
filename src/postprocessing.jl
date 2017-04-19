function enforceconnectivity(labels::Array{Int64, 2}, stepsize::Int64)
  imagewidth, imageheight = size(labels)
  idealsuperpixelsize = stepsize * stepsize
  dx = [-1,  0,  1,  0]
	dy = [ 0, -1,  0,  1]

  newlabels = fill(-1, imagewidth, imageheight)
  newlabelcount = 0
  adjacentlabel = 0

  for pixely in 1:imageheight
    for pixelx in 1:imagewidth
      if newlabels[pixelx, pixely] >= 0
        continue
      end

      segment = Array{Tuple{Int64, Int64}, 1}()
      push!(segment, (pixelx, pixely))
      newlabels[pixelx, pixely] = newlabelcount

      for index in 1:4
        neighbourx = pixelx + dx[index]
        neighboury = pixely + dy[index]
        if (1 <= neighbourx <= imagewidth) && (1 <= neighboury <= imageheight)
          if (newlabels[pixelx, pixely] >= 0)
            adjacentlabel = newlabels[pixelx, pixely]
          end
        end
      end

      count = 1
      currentindex = 1
      while currentindex <= count
        for index in 1:4
          currentx, currenty = segment[currentindex]
          neighbourx = currentx + dx[index]
          neighboury = currenty + dy[index]
          if (1 <= neighbourx <= imagewidth) && (1 <= neighboury <= imageheight)
            if ((0 > newlabels[neighbourx, neighboury]) && (labels[pixelx, pixely] ==
                  labels[neighbourx, neighboury]))
              push!(segment, (neighbourx, neighboury))
              newlabels[pixelx, pixely] = newlabelcount
              count +=1
            end
          end
        end
        currentindex += 1
      end

      if count < (idealsuperpixelsize >> 2)
        for element in segment
          elementx,elementy = element
          newlabels[pixelx, pixely] = adjacentlabel
        end
        newlabelcount -= 1
      end
      newlabelcount += 1
    end
  end
  return newlabels
end
