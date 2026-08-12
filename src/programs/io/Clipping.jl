#====================================================
#  Clipping.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Clipping
```julia
  clipping(width::Int, height::Int,
           pixels::Matrix{Float64})::Matrix{Int16}
```

## Summary
Clipping
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Int16}`
"""
function clipping(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Int16}
    img::Matrix{Int16} = round.(Int16, pixels)
    for i::Int in 1:height
        for j::Int in 1:width
            if img[i, j] < 0
                img[i, j] = 0
            elseif img[i, j] > 255
                img[i, j] = 255
            end
        end
    end
    return img
end

"""
# Clipping
```julia
  clipping(width::Int, height::Int,
           pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Clipping
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function clipping(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    for i::Int in 1:height
        for j::Int in 1:width
            if pixels[i, j] < 0
                pixels[i, j] = 0
            elseif pixels[i, j] > 255
                pixels[i, j] = 255
            end
        end
    end
    return pixels
end
