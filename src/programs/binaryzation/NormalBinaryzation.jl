#====================================================
#  NormalBinaryzation.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#

"""
# Binaryzation
```julia
  normalBinaryzation(data::dataPGM, threshold::Number)::dataPGM
```

## Summary
Binaryzation

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function normalBinaryzation(data::dataPGM, threshold::Number)::dataPGM
    width::UInt = data.width
    height::UInt = data.height
    pixels::Matrix{Float64} = data.pixels
    ans::Matrix{Float64} = zeros(Float64, height, width)

    ans = [x < threshold ? 0 : 255 for x in pixels]
    return dataPGM("P2", width, height, 255, ans)
end

"""
# Binaryzation
```julia
  normalBinaryzation(data::dataPPM, threshold::Number)::dataPPM
```

## Summary
Binaryzation

## Arguments
- `data::dataPPM`

## Return value
- `data::dataPPM`
"""
function normalBinaryzation(data::dataPPM, threshold::Number)::dataPPM
    width::UInt = data.width
    height::UInt = data.height
    red::Matrix{Float64} = data.red
    green::Matrix{Float64} = data.green
    blue::Matrix{Float64} = data.blue

    ans_red::Matrix{Float64} = zeros(Float64, height, width)
    ans_green::Matrix{Float64} = zeros(Float64, height, width)
    ans_blue::Matrix{Float64} = zeros(Float64, height, width)

    rgb::Matrix{Float64} = (red + green + blue) ./ 3.0
    label::Matrix{Int8} = [x < threshold ? 0 : 1 for x in rgb]

    ans_red = [x == 0 ? 0 : 255 for x in label]
    ans_green = [x == 0 ? 0 : 255 for x in label]
    ans_blue = [x == 0 ? 0 : 255 for x in label]
    return dataPPM("P3", width, height, 255, ans_red, ans_green, ans_blue)
end
