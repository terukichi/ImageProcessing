#====================================================
#  Convolution.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Convolution
```julia
  convolution(width::Int, height::Int,
       pixels::Matrix{Float64},
       filter::Matrix{Float64})::Matrix{Float64}
```

## Summary
Convolution function

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Float64}`
- `filter::Matrix{Float64}`

## Return value
- `pixels::Matrix{Float64}`
"""
function convolution(width::Int, height::Int, pixels::Matrix{Float64}, filter::Matrix{Float64})::Matrix{Float64}
    padded::Matrix{Float64} = zeros(Float64, height + 2, width + 2)
    padded[2:end-1, 2:end-1] .= pixels

    for i::Int in 1:height
        for j::Int in 1:width
            pixels[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end

    return pixels
end

"""
# Convolution
```julia
  convolution(width::Int, height::Int,
       pixels::Matrix{Int16},
       filter::Matrix{Int16})::Matrix{Int16}
```

## Summary
Convolution function

## Arguments
- `width::Int`
- `height::Int`
- `pixels::Matrix{Int16}`
- `filter::Matrix{Int16}`

## Return value
- `pixels::Matrix{Int16}`
"""
function convolution(width::Int, height::Int, pixels::Matrix{Int16}, filter::Matrix{Int16})::Matrix{Int16}
    padded::Matrix{Int16} = zeros(Int16, height + 2, width + 2)
    padded[2:end-1, 2:end-1] .= pixels

    for i::Int in 1:height
        for j::Int in 1:width
            pixels[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end
    return pixels
end
