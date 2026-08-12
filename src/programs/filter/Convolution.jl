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
  convolution(width::UInt, height::UInt,
       pixels::Matrix{Float64},
       filter::Matrix{Float64})::Matrix{Float64}
```

## Summary
Convolution function

## Arguments
- `width::UInt`
- `height::UInt`
- `pixels::Matrix{Float64}`
- `filter::Matrix{Float64}`

## Return value
- `pixels::Matrix{Float64}`
"""
function convolution(width::UInt, height::UInt, pixels::Matrix{Float64}, filter::Matrix{Float64})::Matrix{Float64}
    ans::Matrix{Float64} = zeros(Float64, height, width)
    padded::Matrix{Float64} = zeros(Float64, height + 2, width + 2)
    padded[2:end-1, 2:end-1] .= pixels

    for i::UInt in 1:height
        for j::UInt in 1:width
            ans[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end

    return ans
end
