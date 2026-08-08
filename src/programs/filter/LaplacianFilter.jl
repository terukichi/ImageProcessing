#====================================================
#  LaplacianFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
    width::Int = data.width
    height::Int = data.height
    filter::Matrix{Int16} = [0  1 0;
                             1 -4 1;
                             0  1 0]
    img::Matrix{Int16} = convolution(width, height, data.pixels, filter)
    data.pixels = clipping(width, height, img)
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
    magic_num::String = data.magic_num
    width::Int = data.width
    height::Int = data.height
    max_brightness::Int16 = data.max_brightness
    red::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.red)
    green::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.green)
    blue::dataPGM = dataPGM(magic_num, width, height, max_brightness, data.blue)
    red = laplacianFilter(red)
    green = laplacianFilter(green)
    blue = laplacianFilter(blue)
    data.red = red.pixels
    data.green = green.pixels
    data.blue = blue.pixels
    return data
end
