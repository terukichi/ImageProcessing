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
    width::UInt = data.width
    height::UInt = data.height
    filter::Matrix{Float64} = [1.0/16.0 2.0/16.0 1.0/16.0;
                               2.0/16.0 4.0/16.0 2.0/16.0;
                               1.0/16.0 2.0/16.0 1.0/16.0]
    ans::dataPGM = convolution(data, filter)
    return ans
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
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = gaussianFilter(red)
    green = gaussianFilter(green)
    blue = gaussianFilter(blue)
    ans = dataPPM(data.magic_num, red.width, red.height, data.max_brightness, red.pixels, green.pixels, blue.pixels)
    return ans
end
