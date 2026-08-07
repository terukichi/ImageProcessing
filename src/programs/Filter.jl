#====================================================
#  Filter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Filter

## Functions

### Public

- `averaging`
  - `gaussian`
  - `sobelLR`
  - `sobelTD`
  - `sobelGradient`
  - `laplacian`

### Private

- `conv`
  - `clipping`
"""
module Filter

export averaging, sobelGradient, sobelLR, sobelTD, gaussian, laplacian, unsharpMask


"""
# Convolution
```julia
  conv(width::Int, height::Int,
       pixels::Matrix{Float64},
       filter::Matrix{Float64})::Matrix{Float64}
```

## Summary
Convolution function

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`
- `filter::Matrix{Float64}`

## Return value
- `pixels::Matrix{Float64}`
"""
function conv(width::Int, height::Int, pixels::Matrix{Float64}, filter::Matrix{Float64})::Matrix{Float64}
    padded::Matrix{Float64} = zeros(Float64, height + 2, width + 2)
    padded[2:end-1, 2:end-1].=pixels

    for i in 1:height
        for j in 1:width
            pixels[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end

    return pixels
end

"""
# Convolution
```julia
  conv(width::Int, height::Int,
       pixels::Matrix{Int16},
       filter::Matrix{Int16})::Matrix{Int16}
```

## Summary
Convolution function

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`
- `filter::Matrix{Int16}`

## Return value
- `pixels::Matrix{Int16}`
"""
function conv(width::Int, height::Int, pixels::Matrix{Int16}, filter::Matrix{Int16})::Matrix{Int16}
    padded::Matrix{Int16} = zeros(Int16, height + 2, width + 2)
    padded[2:end-1, 2:end-1].=pixels

    for i in 1:height
        for j in 1:width
            pixels[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end
    return pixels
end

"""
# Clipping
```julia
  clipping(width::Int, height::Int,
           pixels::Matrix{Float64})::Matrix{Int16}
```

## Summary
Clipping
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Int16}`
"""
function clipping(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Int16}
    img::Matrix{Int16} = round.(Int16, pixels)
    for i in 1:height
        for j in 1:width
            if img[i, j] < 0
                img[i, j] = 0
            elseif img[i, j] > 255
                img[i, j] = 255
            end
        end
    end
    return img
end

"""
# Clipping
```julia
  clipping(width::Int, height::Int,
           pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Clipping
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function clipping(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    for i in 1:height
        for j in 1:width
            if pixels[i, j] < 0
                pixels[i, j] = 0
            elseif pixels[i, j] > 255
                pixels[i, j] = 255
            end
        end
    end
    return pixels
end

"""
# Averaging Filter
```julia
  averaging(width::Int, height::Int,
            pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Averaging filter

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function averaging(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    img::Matrix{Float64} = pixels
    filter::Matrix{Float64} = [1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0]
    img = conv(width, height, img, filter)
    result::Matrix{Int16} = clipping(width, height, img)
    return result
end

"""
# Averaging Filter
```julia
  averaging(width::Int, height::Int,
            r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
            ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Averaging filter

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function averaging(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = averaging(width, height, r)
    g = averaging(width, height, g)
    b = averaging(width, height, b)
    return r,g,b
end

"""
# Gaussian Filter
```julia
  gaussian(width::Int, height::Int,
           pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Gaussian filter

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function gaussian(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    img::Matrix{Float64} = pixels
    filter::Matrix{Float64} = [1.0/16.0 2.0/16.0 1.0/16.0;
                               2.0/16.0 4.0/16.0 2.0/16.0;
                               1.0/16.0 2.0/16.0 1.0/16.0]
    img = conv(width, height, img, filter)
    result::Matrix{Int16} = clipping(width, height, img)
    return result
end

"""
# Gaussian Filter
```julia
  gaussian(width::Int, height::Int,
           r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
           ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Gaussian filter

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function gaussian(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = gaussian(width, height, r)
    g = gaussian(width, height, g)
    b = gaussian(width, height, b)
    return r,g,b
end

"""
# Horizontal Sobel Filter
```julia
  sobelLR(width::Int, height::Int,
          pixels::Matrix{Float64})::Matrix{Float64}
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Float64}`
"""
function sobelLR(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Float64}
    filterLR::Matrix{Float64} = [-1 0 1;
                                 -2 0 2;
                                 -1 0 1]
    imgLR::Matrix{Float64} = conv(width, height, pixels, filterLR)
    return imgLR
end

"""
# Horizontal Sobel Filter
```julia
  sobelLR(width::Int, height::Int,
          pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function sobelLR(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    filterLR::Matrix{Int16} = [-1 0 1;
                               -2 0 2;
                               -1 0 1]
    imgLR::Matrix{Int16} = conv(width, height, pixels, filterLR)
    result::Matrix{Int16} = clipping(width, height, imgLR)
    return result
end

"""
# Horizontal Sobel Filter
```julia
  sobelLR(width::Int, height::Int,
          r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
          ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function sobelLR(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelLR(width, height, r)
    g = sobelLR(width, height, g)
    b = sobelLR(width, height, b)
    return r,g,b
end

"""
# Vertical Sobel Filter
```julia
  sobelTD(width::Int, height::Int,
          pixels::Matrix{Float64})::Matrix{Float64}
```

## Summary
Sobel filter (Vertical)

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Float64}`
"""
function sobelTD(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Float64}
    filterTD::Matrix{Float64} = [ 1  2  1;
                                  0  0  0;
                                 -1 -2 -1]
    imgTD::Matrix{Float64} = conv(width, height, pixels, filterTD)
    return imgTD
end

"""
# Vertical Sobel Filter
```julia
  sobelTD(width::Int, height::Int,
          pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Sobel filter (Vertical)

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function sobelTD(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    filterTD::Matrix{Int16} = [  1  2  1;
                                 0  0  0;
                                -1 -2 -1]
    imgTD::Matrix{Int16} = conv(width, height, pixels, filterTD)
    result::Matrix{Int16} = clipping(width, height, imgTD)
    return result
end

"""
# Vertical Sobel Filter
```julia
  sobelTD(width::Int, height::Int,
          r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
          ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Sobel filter (Vertical)

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function sobelTD(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelTD(width, height, r)
    g = sobelTD(width, height, g)
    b = sobelTD(width, height, b)
    return r,g,b
end

"""
# Sobel Filter (Gradient)
```julia
  sobelGradient(width::Int, height::Int,
          pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Sobel filter (Gradient)

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function sobelGradient(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    img::Matrix{Float64} = pixels
    imgLR::Matrix{Float64} = sobelLR(width, height, img)
    imgTD::Matrix{Float64} = sobelTD(width, height, img)
    img = sqrt.(imgLR.^2 + imgTD.^2)
    result::Matrix{Int16} = clipping(width, height, img)
    return result
end

"""
# Sobel Filter (Gradient)
```julia
  sobelGradient(width::Int, height::Int,
                r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
                ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Sobel filter (Gradient)

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function sobelGradient(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelGradient(width, height, r)
    g = sobelGradient(width, height, g)
    b = sobelGradient(width, height, b)
    return r, g, b
end

"""
# Laplacian Filter
```julia
  laplacian(width::Int, height::Int,
            pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Laplacian filter

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function laplacian(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    filter::Matrix{Int16} = [0  1 0;
                             1 -4 1;
                             0  1 0]
    img::Matrix{Int16} = conv(width, height, pixels, filter)
    result::Matrix{Int16} = clipping(width, height, img)
    return result
end


"""
# Laplacian Filter
```julia
  laplacian(width::Int, height::Int,
            r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})
            ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Laplacian filter

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function laplacian(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = laplacian(width, height, r)
    g = laplacian(width, height, g)
    b = laplacian(width, height, b)
    return r,g,b
end

"""
# Unsharp Masking
```julia
  unsharpMask(width::Int, height::Int,
              pixels::Matrix{Int16},
              k::Int8)::Matrix{Int16}
```

## Summary
Unsharp masking

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`
- `k::Int8`

## Return value
- `img::Matrix{Int16}`
"""
function unsharpMask(width::Int, height::Int, pixels::Matrix{Int16}, k::Int8)::Matrix{Int16}
    img::Matrix{Float64} = pixels
    filter::Matrix{Float64} = [-k/9.0 -k/9.0 -k/9.0;
                               -k/9.0 1+8.0k/9.0 -k/9.0;
                               -k/9.0 -k/9.0 -k/9.0]
    img = conv(width, height, img, filter)
    result::Matrix{Int16} = clipping(width, height, img)
    return result
end

"""
# Unsharp Masking
```julia
  unsharpMask(width::Int, height::Int,
              r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16},
              k::Int8)
              ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Unsharp masking

## Arguments
- `width::Int`
- `height::Int`
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
- `k::Int8`

## Return values
- `r::Matrix{Int16}`
- `g::Matrix{Int16}`
- `b::Matrix{Int16}`
"""
function unsharpMask(width::Int, height::Int, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16}, k::Int8)::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = unsharpMask(width, height, r, k)
    g = unsharpMask(width, height, g, k)
    b = unsharpMask(width, height, b, k)
    return r,g,b
end


end                             # module
