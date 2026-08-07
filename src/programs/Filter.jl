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

using ..ImageProcessing: dataPPM, dataPGM

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
function averaging(data::dataPGM)::dataPGM
    img::Matrix{Float64} = Float64.(data.gray)
    filter::Matrix{Float64} = [1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0]
    img = conv(data.width, data.height, img, filter)
    clipped::Matrix{Int16} = clipping(data.width, data.height, img)
    data.gray = clipped
    return data
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
function averaging(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = averaging(red)
    green = averaging(green)
    blue = averaging(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function gaussian(data::dataPGM)::dataPGM
    img::Matrix{Float64} = Float64.(data.gray)
    filter::Matrix{Float64} = [1.0/16.0 2.0/16.0 1.0/16.0;
                               2.0/16.0 4.0/16.0 2.0/16.0;
                               1.0/16.0 2.0/16.0 1.0/16.0]
    img = conv(data.width, data.height, img, filter)
    data.gray = clipping(data.width, data.height, img)
    return data
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
function gaussian(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = gaussian(red)
    green = gaussian(green)
    blue = gaussian(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function sobelLR(data::dataPGM)::dataPGM
    filterLR::Matrix{Int16} = [-1 0 1;
                               -2 0 2;
                               -1 0 1]
    imgLR::Matrix{Int16} = conv(data.width, data.height, data.gray, filterLR)
    img::Matrix{Int16} = clipping(data.width, data.height, imgLR)
    data.gray = img
    return data
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
function sobelLR(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelLR(red)
    green = sobelLR(green)
    blue = sobelLR(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function sobelTD(data::dataPGM)::dataPGM
    filterTD::Matrix{Int16} = [  1  2  1;
                                 0  0  0;
                                -1 -2 -1]
    imgTD::Matrix{Int16} = conv(data.width, data.height, data.gray, filterTD)
    data.gray = clipping(data.width, data.height, imgTD)
    return data
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
function sobelTD(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelTD(red)
    green = sobelTD(green)
    blue = sobelTD(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function sobelGradient(data::dataPGM)::dataPGM
    img::Matrix{Float64} = Float64.(data.gray)
    imgLR::Matrix{Float64} = sobelLR(data.width, data.height, img)
    imgTD::Matrix{Float64} = sobelTD(data.width, data.height, img)
    img = sqrt.(imgLR.^2 + imgTD.^2)
    result::Matrix{Int16} = clipping(data.width, data.height, img)
    data.gray = result
    return data
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
function sobelGradient(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelGradient(red)
    green = sobelGradient(green)
    blue = sobelGradient(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function laplacian(data::dataPGM)::dataPGM
    filter::Matrix{Int16} = [0  1 0;
                             1 -4 1;
                             0  1 0]
    img::Matrix{Int16} = conv(data.width, data.height, data.gray, filter)
    data.gray = clipping(data.width, data.height, img)
    return data
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
function laplacian(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = laplacian(red)
    green = laplacian(green)
    blue = laplacian(blue)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
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
function unsharpMask(data::dataPGM, k::Int8)::dataPGM
    img::Matrix{Float64} = Float64.(data.gray)
    filter::Matrix{Float64} = [-k/9.0 -k/9.0 -k/9.0;
                               -k/9.0 1+8.0k/9.0 -k/9.0;
                               -k/9.0 -k/9.0 -k/9.0]
    img = conv(data.width, data.height, img, filter)
    data.gray = clipping(data.width, data.height, img)
    return data
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
function unsharpMask(data::dataPPM, k::Int8)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = unsharpMask(red, k)
    green = unsharpMask(green, k)
    blue = unsharpMask(blue, k)
    data.red = red.gray
    data.green = green.gray
    data.blue = blue.gray
    return data
end


end                             # module
