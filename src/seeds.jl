function getseedpositions(imagedata::Array{Float64, 3}, stepsize::Int64)
  channels, imagewidth, imageheight = size(imagedata)
  offset = div(stepsize, 2)
  seeds = Array{Tuple{Int64, Int64}, 1}()
  for pixely in 1:stepsize:imageheight
    seedy = pixely + offset
    for pixelx in 1:stepsize:imagewidth
      seedx = pixelx + offset
      push!(seeds, (pixelx, pixely))
    end
  end
  return seeds
end

function preturbseeds(edgemap::Array{Float64, 2},
    seeds::Array{Tuple{Int64, Int64}, 1})
  imagewidth, imageheight = size(edgemap)
  seedcount = length(seeds)
  preturbedseeds = Array{Tuple{Int64, Int64}, 1}()
  dx8 = [-1, -1,  0,  1, 1, 1, 0, -1]
  dy8 = [ 0, -1, -1, -1, 0, 1, 1,  1]
  for seed in seeds
    seedx, seedy = seed
    for index in 1:8
      neighbourx = seedx + dx8[index]
      neighboury = seedy + dy8[index]
      if ((1 <= neighbourx < imagewidth) && (1 <= neighboury < imageheight))
        if edgemap[neighbourx, neighboury] < edgemap[seedx, seedy]
          seedx = neighbourx
          seedy = neighboury
        end
      end
    end
    push!(preturbedseeds, (seedx, seedy))
  end
  return preturbedseeds
end
