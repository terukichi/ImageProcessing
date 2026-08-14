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
- `ans::dataPGM`
"""
function convolution(data::dataPGM, filter::Matrix{Float64})::dataPGM
    width::UInt = data.width - 2
    height::UInt = data.height - 2
    pixels::Matrix{Float64} = data.pixels
    img::Matrix{Float64} = zeros(Float64, height, width)

    for i::UInt in 1:height
        for j::UInt in 1:width
            img[i, j] = sum(pixels[i:i+2, j:j+2] .* filter)
        end
    end

    return dataPGM(data.magic_num, width, height, data.max_brightness, img)
end

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
- `ans::dataPGM`
"""
function convolution(width::UInt, height::UInt, pixels::Matrix{Float64}, filter::Matrix{Float64})::Matrix{Float64}
    img::Matrix{Float64} = zeros(Float64, height - 2, width - 2)
    for i::UInt in 1:height - 2
        for j::UInt in 1:width - 2
            img[i, j] = sum(pixels[i:i+2, j:j+2] .* filter)
        end
    end

    return img
end

function zeroPadding(data::dataPGM)::dataPGM
    width::UInt = data.width + 2
    height::UInt = data.height + 2
    pixels::Matrix{Float64} = data.pixels
    padded::Matrix{Float64} = zeros(Float64, height, width)
    padded[2:end-1, 2:end-1] .= pixels
    return dataPGM(data.magic_num, width, height, data.max_brightness, padded)
end

function zeroPadding(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
    width += 2
    height += 2
    padded::Matrix{Float64} = zeros(Float64, height, width)
    padded[2:end-1, 2:end-1] .= pixels
    return padded
end
