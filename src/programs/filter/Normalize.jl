#====================================================
#  Normalize.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Normalize
```julia
  normalize(width::Int, height::Int,
           pixels::Matrix{Float64})::Matrix{Int16}
```

## Summary
Normalize
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`

## Return value
- `img::Matrix{Int16}`
"""
function normalize(width::Int, height::Int, pixels::Matrix{Float64})::Matrix{Int16}
    min_val::Float64 = minimum(pixels)
    if min_val < 0
        pixels = [x - min_val for x in pixels]
    end
    max_val::Float64 = maximum(pixels)
    img::Matrix{Int16} = [round(Int16, x / max_val * 255) for x in pixels]
    return img
end

"""
# Normalize
```julia
  normalize(width::Int, height::Int,
           pixels::Matrix{Int16})::Matrix{Int16}
```

## Summary
Normalize
- 0-255

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`

## Return value
- `img::Matrix{Int16}`
"""
function normalize(width::Int, height::Int, pixels::Matrix{Int16})::Matrix{Int16}
    min_val::Int16 = minimum(pixels)
    println(min_val)
    if min_val < 0
        pixels = [x - min_val for x in pixels]
    end
    max_val::Float64 = maximum(pixels)
    println(max_val)
    img::Matrix{Int16} = [round(Int16, x / max_val * 255) for x in pixels]
    return img
end
