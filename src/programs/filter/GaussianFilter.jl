#====================================================
#  GaussianFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
    width::Int = data.width
    height::Int = data.height
    img::Matrix{Float64} = Float64.(data.pixels)
    filter::Matrix{Float64} = [1.0/16.0 2.0/16.0 1.0/16.0;
                               2.0/16.0 4.0/16.0 2.0/16.0;
                               1.0/16.0 2.0/16.0 1.0/16.0]
    img = convolution(width, height, img, filter)
    data.pixels = clipping(width, height, img)
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
    magic_num::String = data.magic_num
    width::Int = data.width
    height::Int = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = gaussianFilter(red)
    green = gaussianFilter(green)
    blue = gaussianFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end
