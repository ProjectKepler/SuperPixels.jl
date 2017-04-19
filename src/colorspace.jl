function getRGBtoXYZ(R::Float64, G::Float64, B::Float64)
    if R > 0.04045
      R = ((R + 0.055) / 1.055) ^ 2.4
    else
      R = R / 12.92
    end

    if G > 0.04045
      G = ((G + 0.055) / 1.055) ^ 2.4
    else
      G = G / 12.92
    end

    if B > 0.04045
      B = ((B + 0.055) / 1.055) ^ 2.4
    else
      B = B / 12.92
    end

    X = (R * 0.4124564 + G * 0.3575761 + B * 0.1804375)
    Y = (R * 0.2126729 + G * 0.7151522 + B * 0.0721750)
    Z = (R * 0.0193339 + G * 0.1191920 + B * 0.9503041)

  return X, Y, Z
end

function getXYZtoLAB(X::Float64, Y::Float64, Z::Float64)
  epsilon = 0.008856
  kappa   = 903.3

  referenceX = 0.950456
  referenceY = 1.0
  referenceZ = 1.088754

  x = X / referenceX
  y = Y / referenceY
  z = Z / referenceZ

  fx = (x > epsilon) ? x^(1/3) : (kappa*x + 16.0)/116.0
  fy = (y > epsilon) ? y^(1/3) : (kappa*y + 16.0)/116.0
  fz = (z > epsilon) ? z^(1/3) : (kappa*z + 16.0)/116.0

  L = 116.0*fy-16.0;
	A = 500.0*(fx-fy);
	B = 200.0*(fy-fz);

  return L, A, B
end

function getRGBtoLAB(imagedata::Array{Float64, 3})
  channels, imagewidth, imageheight = size(imagedata)
  output = Array{Float64}(channels, imagewidth, imageheight)
  for pixely in 1:imageheight
    for pixelx in 1:imagewidth
      X, Y, Z = getRGBtoXYZ(imagedata[1, pixelx, pixely], imagedata[2, pixelx,
        pixely], imagedata[3, pixelx, pixely])
      L, A, B = getXYZtoLAB(X, Y, Z)
      output[1, pixelx, pixely] = L
      output[2, pixelx, pixely] = A
      output[3, pixelx, pixely] = B
    end
  end
  return output
end
