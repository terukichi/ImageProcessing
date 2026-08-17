#====================================================
#  BandPassFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Bandpass Filter
```julia
  bandPassFilter(data::dataPGM,
                 radius_a::Float64, radius_b::Float64)
                 ::dataPGM
```

!!! note

    `radious_a < radious_b`

## Summary
Bandpass filter

## Arguments
- `data::dataFrequency`
- `radius_a::Float64`
- `radius_b::Float64`

## Return value
- `data::dataFrequency`
"""
function bandPassFilter(data::dataFrequency, radius_a::Float64, radius_b::Float64)::dataFrequency
    width::UInt = data.width
    height::UInt = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) > radius_a^2 && ((x-width/2)^2+(y-height/2)^2) < radius_b^2 ? 1 : 0  for y in 1:height, x in 1:width]
    data.frequency = data.frequency .* mask
    return data
end
