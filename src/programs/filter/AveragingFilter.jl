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
    width::UInt = data.width
    height::UInt = data.height
    filter::Matrix{Float64} = [1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0;
                               1.0/9.0 1.0/9.0 1.0/9.0]
    ans::dataPGM = convolution(data, filter)
    return ans
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
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, data.max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = averagingFilter(red)
    green = averagingFilter(green)
    blue = averagingFilter(blue)
    ans = dataPPM(data.magic_num, red.width, red.height, data.max_brightness, red.pixels, green.pixels, blue.pixels)
    return ans
end
