#====================================================
#  IFFT.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function calcIfft(data::Vector{Complex{Float64}})::Vector{Complex{Float64}}
    n::Integer = length(data)
    if n == 1
        return data
    end
    even::Vector{Complex{Float64}} = data[1:2:end]
    odd::Vector{Complex{Float64}} = data[2:2:end]
    E = calcIfft(even)
    O = calcIfft(odd)
    ans::Vector{Complex{Float64}} = zeros(Complex{Float64}, n)
    for k in 0:floor(Integer, n/2)-1
        W = exp(2pi*im*k/n)
        ans[k + 1] = E[k+1] + W * O[k+1]
        ans[k + floor.(Integer, n/2) + 1] = E[k+1] - W * O[k+1]
    end
    return ans
end

"""
# IFFT
```julia
  ifft(data::dataFrequency)::dataPGM
```

## Summary
IFFT

## Arguments
- `data::dataFrequency`

## Return value
- `data::dataPGM`
"""
function ifft(data::dataFrequency)::dataPGM
    width::UInt = data.width
    height::UInt = data.height
    img_width::UInt = width - data.add_width
    img_height::UInt = height - data.add_height
    frequency::Matrix{Complex{Float64}} = Complex{Float64}.(data.frequency)

    pixels::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)
    frequency = arrangeMatrix(width, height, frequency) .* 255.0
    for i in 1:height
        frequency[i, :] = calcIfft(frequency[i, :]) ./ height
    end
    for i in 1:width
        frequency[:, i] = calcIfft(frequency[:, i]) ./ width
    end
    f::Matrix{Float64} = abs.(frequency)
    ans::Matrix{Float64} = f[1:img_height, 1:img_width]
    return dataPGM("P2", img_width, img_height, 255, ans)
end
