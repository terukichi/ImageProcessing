#====================================================
#  FFT.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function calcFft(data::Vector{Complex{Float64}})::Vector{Complex{Float64}}
    n::Integer = length(data)
    if n == 1
        return data
    end
    even::Vector{Complex{Float64}} = data[1:2:end]
    odd::Vector{Complex{Float64}} = data[2:2:end]
    E = calcFft(even)
    O = calcFft(odd)
    ans::Vector{Complex{Float64}} = zeros(Complex{Float64}, n)
    for k in 0:floor(Integer, n/2)-1
        W = exp(-2pi*im*k/n)
        ans[k + 1] = E[k+1] + W * O[k+1]
        ans[k + floor.(Integer, n/2) + 1] = E[k+1] - W * O[k+1]
    end
    return ans
end

"""
# DFT
```julia
  fft(data::dataPGM)::dataFrequency
```

## Summary
FFT

## Arguments
- `data::dataPGM`

## Return value
- `data::dataFrequency`
"""
function fft(data::dataPGM)::dataFrequency
    width::UInt = data.width
    height::UInt = data.height
    pixels::Matrix{Complex{Float64}} = Complex{Float64}.(data.pixels)
    fft_w::UInt = 0
    fft_h::UInt = 0
    while 2^fft_w < width
        fft_w += 1
    end
    while 2^fft_h < height
        fft_h += 1
    end
    new_width::UInt = 2^fft_w
    new_height::UInt = 2^fft_h
    frequency::Matrix{Complex{Float64}} = zeros(Complex{Float64}, new_height, new_width)
    padded::Matrix{Complex{Float64}} = zeros(Complex{Float64}, new_height, new_width)
    padded[1:height, 1:width] = pixels ./ 255.0
    for i in 1:2^fft_h
        frequency[i, :] = calcFft(padded[i, :])
    end
    for i in 1:2^fft_w
        frequency[:, i] = calcFft(frequency[:, i])
    end
    ans = dataFrequency(new_width, new_height, new_width - width, new_height - height,frequency)
    return arrangeMatrix(ans)
end
