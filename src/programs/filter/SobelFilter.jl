#====================================================
#  SobelFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Horizontal Sobel Filter
```julia
  sobelFilterHorizontal(width::UInt, height::UInt,
                        pixels::Matrix{Float64})
                        ::Matrix{Float64}
```

## Summary
Sobel filter (Horizontal)

## Arguments
- `width::UInt`
- `height::UInt`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Float64}`
"""
function sobelFilterHorizontal(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
    filterLR::Matrix{Float64} = [-1 0 1;
                                 -2 0 2;
                                 -1 0 1]
    imgLR::Matrix{Float64} = convolution(width, height, pixels, filterLR)
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
    width::UInt = data.width
    height::UInt = data.height
    filterLR::Matrix{Float64} = [-1 0 1;
                                 -2 0 2;
                                 -1 0 1]
    imgLR::Matrix{Float64} = convolution(width, height, data.pixels, filterLR)
    data.pixels = imgLR
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
    magic_num::String = data.magic_num
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
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
  sobelFilterVertical(width::UInt, height::UInt,
                      pixels::Matrix{Float64})
                      ::Matrix{Float64}
```

## Summary
Sobel filter (Vertical)

## Arguments
- `width::UInt`
- `height::UInt`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Float64}`
"""
function sobelFilterVertical(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
    filterTD::Matrix{Float64} = [ 1  2  1;
                                  0  0  0;
                                 -1 -2 -1]
    imgTD::Matrix{Float64} = convolution(width, height, pixels, filterTD)
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
    width::UInt = data.width
    height::UInt = data.height
    filterTD::Matrix{Float64} = [  1  2  1;
                                   0  0  0;
                                  -1 -2 -1]
    imgTD::Matrix{Float64} = convolution(width, height, data.pixels, filterTD)
    data.pixels = imgTD
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
    magic_num::String = data.magic_num
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
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
    width::UInt = data.width
    height::UInt = data.height
    img::Matrix{Float64} = Float64.(data.pixels)
    imgLR::Matrix{Float64} = sobelFilterHorizontal(width, height, img)
    imgTD::Matrix{Float64} = sobelFilterVertical(width, height, img)
    img = sqrt.(imgLR.^2 + imgTD.^2)
    data.pixels = img
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
    magic_num::String = data.magic_num
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = sobelFilterGradient(red)
    green = sobelFilterGradient(green)
    blue = sobelFilterGradient(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end
