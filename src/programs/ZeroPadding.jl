#====================================================
#  ZeroPadding.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Zero Padding
```julia
  zeroPadding(data::dataPGM)::dataPGM
```

## Summary
Zero Padding

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function zeroPadding(data::dataPGM)::dataPGM
    width::UInt = data.width + 2
    height::UInt = data.height + 2
    pixels::Matrix{Float64} = data.pixels
    padded::Matrix{Float64} = zeros(Float64, height, width)
    padded[2:end-1, 2:end-1] .= pixels
    return dataPGM(data.magic_num, width, height, data.max_brightness, padded)
end

"""
# Zero Padding
```julia
  zeroPadding(data::dataPPM)::dataPPM
```

## Summary
Zero Padding

## Arguments
- `data::dataPPM`

## Return value
- `data::dataPPM`
"""
function zeroPadding(data::dataPPM)::dataPPM
    width::UInt = data.width + 2
    height::UInt = data.height + 2
    red::Matrix{Float64} = data.red
    green::Matrix{Float64} = data.green
    blue::Matrix{Float64} = data.blue
    paddedRed::Matrix{Float64} = zeros(Float64, height, width)
    paddedGreen::Matrix{Float64} = zeros(Float64, height, width)
    paddedBlue::Matrix{Float64} = zeros(Float64, height, width)
    paddedRed[2:end-1, 2:end-1] .= red
    paddedGreen[2:end-1, 2:end-1] .= green
    paddedBlue[2:end-1, 2:end-1] .= blue
    return dataPPM(data.magic_num, width, height, data.max_brightness, paddedRed, paddedGreen, paddedBlue)
end

"""
# Zero Padding
```julia
  zeroPadding(width::UInt, height::UInt,
              pixels::Matrix{Float64})::Matrix{Float64}
```

## Summary
Zero Padding

## Arguments
- `width::UInt`
- `height::UInt`
- `pixels::Matrix{Float64}`

## Return value
- `padded::Matrix{Float64}`
"""
function zeroPadding(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
    width += 2
    height += 2
    padded::Matrix{Float64} = zeros(Float64, height, width)
    padded[2:end-1, 2:end-1] .= pixels
    return padded
end
