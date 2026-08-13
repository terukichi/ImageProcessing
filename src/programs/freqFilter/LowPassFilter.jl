#====================================================
#  LowPassFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function lowPassFilter(data::dataFrequency, radius::Float64)::dataFrequency
    width::UInt = data.width
    height::UInt = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) < radius^2 ? 1 : 0  for y in 1:height, x in 1:width]
    data.frequency = data.frequency .* mask
    return data
end
