include("colorspace.jl")
include("edgemap.jl")
include("seeds.jl")
include("kmeans.jl")
include("postprocessing.jl")

function getsuperpixels(imagedata::Array{Float64, 3}, stepsize::Int64,
    maxiterations::Int64)
  labimage = getRGBtoLAB(imagedata)
  edgemap = getedgemap(labimage)
  seedpoints = getseedpositions(labimage, stepsize)
  preturbedseeds = preturbseeds(edgemap, seedpoints)
  labels, seedcolors, seeds = kmeans(labimage, preturbedseeds, stepsize,
    maxiterations)
  return labels
end
