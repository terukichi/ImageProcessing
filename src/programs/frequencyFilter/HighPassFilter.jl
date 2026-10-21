#====================================================
#  HighPassFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Highpass Filter
```julia
  highPassFilter(data::dataPGM, radius::Real)::dataPGM
```

## Summary
Highpass filter

## Arguments
- `data::dataFrequency`
- `radius::Real`

## Return value
- `ans::dataFrequency`
"""
function highPassFilter(data::dataFrequency, radius::Real)::dataFrequency
    r::Float64 = Float64(radius)
    width::UInt = data.width
    height::UInt = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) > r^2 ? 1 : 0  for y in 1:height, x in 1:width]
    frequency = data.frequency .* mask
    ans = dataFrequency(width, height, data.init_width, data.init_height, frequency)
    return ans
end
