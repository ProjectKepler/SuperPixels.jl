function kmeans(imagedata::Array{Float64, 3},
    seeds::Array{Tuple{Int64, Int64}, 1}, stepsize::Int64,
    maxiterations::Int64)
  channels, imagewidth, imageheight = size(imagedata)
  labelcount = length(seeds)
  offset = (stepsize > 10) ? stepsize : stepsize*1.5
  distancenorm = 1 / (stepsize * stepsize)

  distance = fill(typemax(Float64), imagewidth, imageheight)
  labels = fill(-1, imagewidth, imageheight)

  sigma = Array{Float64}(labelcount, 5)
  clustersize = Array{Int64}(labelcount)
  maxcolordistance = fill(10.0*10.0, labelcount)
  maxspatialdistance = fill(Float64(stepsize*stepsize), labelcount)

  seedcolors = Array{Tuple{Float64, Float64, Float64},1}()
  for seed in seeds
    seedx, seedy = seed
    seedcolor = (imagedata[1, seedx, seedy], imagedata[2, seedx, seedy],
      imagedata[3, seedx, seedy])
    push!(seedcolors, seedcolor)
  end

  currentiteration = 0
  while(currentiteration < maxiterations)
    currentiteration += 1
    fill!(sigma, 0.0)
    fill!(clustersize, 0)
    fill!(distance, typemax(Float64))

    for seedindex in 1:labelcount
      seedx, seedy = seeds[seedindex]
      seedL, seedA, seedB = seedcolors[seedindex]

      startx = max(1, seedx - offset)
      endx = min(seedx + offset, imagewidth)
      starty = max(1, seedy - offset)
      endy = min(seedy + offset, imageheight)
      for pixely in starty:endy
        for pixelx in  startx:endx
          @inbounds L = imagedata[1, pixelx, pixely]
          @inbounds A = imagedata[2, pixelx, pixely]
          @inbounds B = imagedata[3, pixelx, pixely]
          colordistance = ((L - seedL)*(L - seedL) + (A - seedA)*(A - seedA) +
            (B - seedB)*(B - seedB))
          spatialdistance = ((pixelx - seedx)*(pixelx - seedx) +
            (pixely - seedy)*(pixely - seedy))
          # totaldistance = ((colordistance / maxcolordistance[seedindex]) +
          #   (spatialdistance / maxspatialdistance[seedindex]))
          @inbounds totaldistance = ((colordistance / maxcolordistance[seedindex]) +
            (spatialdistance * distancenorm))

          @inbounds maxcolordistance[seedindex] = max(maxcolordistance[seedindex],
            colordistance)
          @inbounds maxspatialdistance[seedindex] = max(maxspatialdistance[seedindex],
            spatialdistance)

          @inbounds if distance[pixelx, pixely] > totaldistance
          @inbounds  distance[pixelx, pixely] = totaldistance
          @inbounds  labels[pixelx, pixely] = seedindex
          end
        end
      end
    end

    for pixely in 1:imageheight
      for pixelx in 1:imagewidth
        label = labels[pixelx, pixely]
        sigma[label, 1] += imagedata[1, pixelx, pixely]
        sigma[label, 2] += imagedata[2, pixelx, pixely]
        sigma[label, 3] += imagedata[3, pixelx, pixely]
        sigma[label, 4] += pixelx
        sigma[label, 5] += pixely

        clustersize[label] += 1
      end
    end

    for seedindex in 1:labelcount
      normfactor = 1.0 / clustersize[seedindex]

      seedcolors[seedindex] = (sigma[seedindex, 1] * normfactor,
      sigma[seedindex, 2] * normfactor, sigma[seedindex, 3] * normfactor)
      seeds[seedindex] = (round(Int64, sigma[seedindex, 4] * normfactor),
      round(Int64, sigma[seedindex, 5] * normfactor))
    end
  end
  return labels, seedcolors, seeds
end
