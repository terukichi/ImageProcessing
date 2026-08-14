#====================================================
#  UnsharpMasking.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
    width::UInt = data.width
    height::UInt = data.height
    filter::Matrix{Float64} = [-k/9.0 -k/9.0 -k/9.0;
                               -k/9.0 1+8.0k/9.0 -k/9.0;
                               -k/9.0 -k/9.0 -k/9.0]
    ans::dataPGM = convolution(data, filter)
    return ans
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
    magic_num::String = data.magic_num
    width::UInt = data.width
    height::UInt = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = unsharpMasking(red, k)
    green = unsharpMasking(green, k)
    blue = unsharpMasking(blue, k)
    ans = dataPPM(data.magic_num, red.width, red.height, data.max_brightness, red.pixels, green.pixels, blue.pixels)
    return ans
end
