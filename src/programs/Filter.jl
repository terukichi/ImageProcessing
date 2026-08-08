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

- `averagingFilter`
- `gaussianFilter`
- `sobelFilterHorizontal`
- `sobelFilterVertical`
- `sobelFilterGradient`
- `laplacianFilter`
- `unsharpMasking`

### Private

- `conv`
- `clipping`
"""
module Filter

using ..ImageProcessing: dataPPM, dataPGM

export averagingFilter, sobelFilterGradient, sobelFilterHorizontal, sobelFilterVertical, gaussianFilter, laplacianFilter, unsharpMasking


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
  averagingFilter(data::dataPGM)::dataPGM
```

## Summary
Averaging filter

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function averagingFilter(data::dataPGM)::dataPGM
    pixels::Matrix{Int16} = data.pixels
    img::Matrix{Float64} = Float64.(data.pixels)
    filter::Matrix{Float64} = [1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0]
    img = conv(data.width, data.height, img, filter)
    clipped::Matrix{Int16} = clipping(data.width, data.height, img)
    data.pixels = clipped
    return data
end

"""
# Averaging Filter
```julia
  averagingFilter(data::dataPPM)::dataPPM
```

## Summary
Averaging filter

## Arguments
- `data::dataPPM`

## Return values
- `data::dataPPM`
"""
function averagingFilter(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = averagingFilter(red)
    green = averagingFilter(green)
    blue = averagingFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Gaussian Filter
```julia
  gaussianFilter(data::dataPGM)::dataPGM
```

## Summary
Gaussian filter

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function gaussianFilter(data::dataPGM)::dataPGM
    img::Matrix{Float64} = Float64.(data.pixels)
    filter::Matrix{Float64} = [1.0/16.0 2.0/16.0 1.0/16.0;
                               2.0/16.0 4.0/16.0 2.0/16.0;
                               1.0/16.0 2.0/16.0 1.0/16.0]
    img = conv(data.width, data.height, img, filter)
    data.pixels = clipping(data.width, data.height, img)
    return data
end

"""
# Gaussian Filter
```julia
  gaussianFilter(data::dataPPM)::dataPPM
```

## Summary
Gaussian filter

## Arguments
- `data::dataPPM`

## Return values
- `data::dataPPM`
"""
function gaussianFilter(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = gaussianFilter(red)
    green = gaussianFilter(green)
    blue = gaussianFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Horizontal Sobel Filter
```julia
  sobelFilterHorizontal(width::Int, height::Int,
                        pixels::Matrix{Float64})
                        ::Matrix{Float64}
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
function sobelFilterHorizontal(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Float64}
    filterLR::Matrix{Float64} = [-1 0 1;
                                 -2 0 2;
                                 -1 0 1]
    imgLR::Matrix{Float64} = conv(width, height, pixels, filterLR)
    return imgLR
end

"""
# Horizontal Sobel Filter
```julia
  sobelFilterHorizontal(data::dataPGM)::dataPGM
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function sobelFilterHorizontal(data::dataPGM)::dataPGM
    filterLR::Matrix{Int16} = [-1 0 1;
                               -2 0 2;
                               -1 0 1]
    imgLR::Matrix{Int16} = conv(data.width, data.height, data.pixels, filterLR)
    img::Matrix{Int16} = clipping(data.width, data.height, imgLR)
    data.pixels = img
    return data
end

"""
# Horizontal Sobel Filter
```julia
  sobelFilterHorizontal(data::dataPPM)::dataPPM
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `data::dataPPM`

## Return value
- `data::dataPPM`
"""
function sobelFilterHorizontal(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelFilterHorizontal(red)
    green = sobelFilterHorizontal(green)
    blue = sobelFilterHorizontal(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Vertical Sobel Filter
```julia
  sobelFilterVertical(width::Int, height::Int,
                      pixels::Matrix{Float64})
                      ::Matrix{Float64}
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
function sobelFilterVertical(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Float64}
    filterTD::Matrix{Float64} = [ 1  2  1;
                                  0  0  0;
                                 -1 -2 -1]
    imgTD::Matrix{Float64} = conv(width, height, pixels, filterTD)
    return imgTD
end

"""
# Vertical Sobel Filter
```julia
  sobelFilterVertical(data::dataPGM)::dataPGM
```

## Summary
Sobel filter (Vertical)

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function sobelFilterVertical(data::dataPGM)::dataPGM
    filterTD::Matrix{Int16} = [  1  2  1;
                                 0  0  0;
                                -1 -2 -1]
    imgTD::Matrix{Int16} = conv(data.width, data.height, data.pixels, filterTD)
    data.pixels = clipping(data.width, data.height, imgTD)
    return data
end

"""
# Vertical Sobel Filter
```julia
  sobelFilterVertical(data::dataPPM)::dataPPM
```

## Summary
Sobel filter (Vertical)

## Arguments
- `data::dataPPM`

## Return values
- `data::dataPPM`
"""
function sobelFilterVertical(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelFilterVertical(red)
    green = sobelFilterVertical(green)
    blue = sobelFilterVertical(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Sobel Filter (Gradient)
```julia
  sobelFilterGradient(data::dataPGM)::dataPGM
```

## Summary
Sobel filter (Gradient)

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function sobelFilterGradient(data::dataPGM)::dataPGM
    img::Matrix{Float64} = Float64.(data.pixels)
    imgLR::Matrix{Float64} = sobelFilterHorizontal(data.width, data.height, img)
    imgTD::Matrix{Float64} = sobelFilterVertical(data.width, data.height, img)
    img = sqrt.(imgLR.^2 + imgTD.^2)
    result::Matrix{Int16} = clipping(data.width, data.height, img)
    data.pixels = result
    return data
end

"""
# Sobel Filter (Gradient)
```julia
  sobelFilterGradient(data::dataPPM)::dataPPM
```

## Summary
Sobel filter (Gradient)

## Arguments
- `data::dataPPM`

## Return values
- `data::dataPPM`
"""
function sobelFilterGradient(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = sobelFilterGradient(red)
    green = sobelFilterGradient(green)
    blue = sobelFilterGradient(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Laplacian Filter
```julia
  laplacianFilter(data::dataPGM)::dataPGM
```

## Summary
Laplacian filter

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function laplacianFilter(data::dataPGM)::dataPGM
    filter::Matrix{Int16} = [0  1 0;
                             1 -4 1;
                             0  1 0]
    img::Matrix{Int16} = conv(data.width, data.height, data.pixels, filter)
    data.pixels = clipping(data.width, data.height, img)
    return data
end


"""
# Laplacian Filter
```julia
  laplacianFilter(data::dataPPM)::dataPPM
```

## Summary
Laplacian filter

## Arguments
- `data::dataPPM`

## Return values
- `data::dataPPM`
"""
function laplacianFilter(data::dataPPM)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = laplacianFilter(red)
    green = laplacianFilter(green)
    blue = laplacianFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end

"""
# Unsharp Masking
```julia
  unsharpMasking(data::dataPGM, k::Int8)::dataPGM
```

## Summary
Unsharp masking

## Arguments
- `data::dataPGM`
- `k::Int8`

## Return value
- `data::dataPGM`
"""
function unsharpMasking(data::dataPGM, k::Int8)::dataPGM
    img::Matrix{Float64} = Float64.(data.pixels)
    filter::Matrix{Float64} = [-k/9.0 -k/9.0 -k/9.0;
                               -k/9.0 1+8.0k/9.0 -k/9.0;
                               -k/9.0 -k/9.0 -k/9.0]
    img = conv(data.width, data.height, img, filter)
    data.pixels = clipping(data.width, data.height, img)
    return data
end

"""
# Unsharp Masking
```julia
  unsharpMasking(data::dataPPM, k::Int8)::dataPPM
```

## Summary
Unsharp masking

## Arguments
- `data::dataPPM`
- `k::Int8`

## Return values
- `data::dataPPM`
"""
function unsharpMasking(data::dataPPM, k::Int8)::dataPPM
    red::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.red)
    green::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(data.magic_num, data.width, data.height, data.max_brightness, data.blue)
    red = unsharpMasking(red, k)
    green = unsharpMasking(green, k)
    blue = unsharpMasking(blue, k)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end


end                             # module
