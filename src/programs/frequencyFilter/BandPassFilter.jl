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
                 radius_a::Real, radius_b::Real)
                 ::dataPGM
```

!!! note

    `radious_a < radious_b`

## Summary
Bandpass filter

## Arguments
- `data::dataFrequency`
- `radius_a::Real`
- `radius_b::Real`

## Return value
- `ans::dataFrequency`
"""
function bandPassFilter(data::dataFrequency, radius_a::Real, radius_b::Real)::dataFrequency
    r_a::Float64 = Float64(radius_a)
    r_b::Float64 = Float64(radius_b)
    width::UInt = data.width
    height::UInt = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) > r_a^2 && ((x-width/2)^2+(y-height/2)^2) < r_b^2 ? 1 : 0  for y in 1:height, x in 1:width]
    frequency = data.frequency .* mask
    ans = dataFrequency(width, height, data.init_width, data.init_height, frequency)
    return ans
end
