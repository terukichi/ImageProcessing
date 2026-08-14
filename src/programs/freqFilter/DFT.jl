#====================================================
#  DFT.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function calcDft(data::dataPGM, u::UInt, v::UInt)::Complex{Float64}
    ans::Complex{Float64} = 0.0
    height::Float64 = Float64(data.height)
    width::Float64 = Float64(data.width)
    for y::UInt in 0:height-1
        yp::UInt = y+1
        for x::UInt in 0:width-1
            xp::UInt = x+1
            theta::Float64 = 2pi*(u*x/width+v*y/height)
            fxy::Float64 = data.pixels[yp, xp]/255.0
            ans += fxy * cos(theta)
            ans -= fxy * im*sin(theta)
        end
    end
    return ans
end

"""
# DFT
```julia
  dft(data::dataPGM)::dataPGM
```

!!! warning "deprecation"

    This function has a high computational complexity.

## Summary
DFT

## Arguments
- `data::dataPGM`

## Return value
- `data::dataPGM`
"""
function dft(data::dataPGM)::dataFrequency
    height::UInt = data.height
    width::UInt = data.width
    F::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)
    for v::UInt in 0:height-1
        vp::UInt = v+1
        for u::UInt in 0:width-1
            up::UInt = u+1
            F[vp, up] = calcDft(data, u, v)
        end
    end

    ans = dataFrequency(width, height, F)
    return arrangeMatrix(ans)
end
