#====================================================
#  IDFT.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function calcIdft(data::dataFrequency, x::UInt, y::UInt)::Float64
    cmp::Complex{Float64} = 0.0
    ams::Float64 = 0.0
    height::Float64 = Float64(data.height)
    width::Float64 = Float64(data.width)
    for v::UInt in 0:height-1
        vp::UInt = v+1
        for u::UInt in 0:width-1
            up::UInt = u+1
            theta::Float64 = 2pi*(u*x/width+v*y/height)
            Fuv::Complex{Float64} = data.frequency[vp, up]*255.0
            cmp += Fuv * cos(theta)
            cmp += Fuv * im*sin(theta)
        end
    end
    ans = abs(cmp/height/width)
    return ans
end

"""
!!! warning "deprecation"

    This function has a high computational complexity.
"""
function idft(data::dataFrequency)::dataPGM
    height::UInt = data.height
    width::UInt = data.width
    f::Matrix{Float64} = zeros(Float64, height, width)
    data.frequency = arrangeMatrix(width, height, data.frequency)
    for y::UInt in 0:height-1
        yp::UInt = y+1
        for x::UInt in 0:width-1
            xp::UInt = x+1
            f[yp, xp] = calcIdft(data, x, y)
        end
    end
    return dataPGM("P2", width, height, 255, f)
end
