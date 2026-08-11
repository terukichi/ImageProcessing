#====================================================
#  AveragingFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
    width::Int = data.width
    height::Int = data.height
    img::Matrix{Float64} = data.pixels
    filter::Matrix{Float64} = [1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0]
    img = convolution(width, height, img, filter)
    data.pixels = img
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
    magic_num::String = data.magic_num
    width::Int = data.width
    height::Int = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = averagingFilter(red)
    green = averagingFilter(green)
    blue = averagingFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end
