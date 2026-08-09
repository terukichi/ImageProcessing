#====================================================
#  DFT.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
module DFT

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM

export dft, DFTtoPGM, amplitudeSpectrum

mutable struct amplitudeSpectrum
    width::Int
    height::Int
    max_spc::Float64
    spectrum::Matrix{Float64}
end

function calcDftLog(data::dataPGM, u::Int, v::Int)::Float64
    cmp::Complex{Float64} = 0.0
    ans::Float64 = 0.0
    max_brightness::Float64 = Float64(data.max_brightness)
    height::Float64 = Float64(data.height)
    width::Float64 = Float64(data.width)
    for y::Int in 0:height-1
        yp::Int = y+1
        for x::Int in 0:width-1
            xp::Int = x+1
            theta::Float64 = 2pi*(u*x/width+v*y/height)
            cmp += Float64(data.pixels[yp, xp])/max_brightness * cos(theta)
            cmp -= Float64(data.pixels[yp, xp])/max_brightness * im*sin(theta)
        end
    end
    ans = log(abs(cmp))
    return ans
end

function dft(data::dataPGM)::amplitudeSpectrum
    F::Matrix{Float64} = zeros(Float64, data.height, data.width)
    max_spc::Float64 = 0.0
    height::Int = data.height
    width::Int = data.width
    for v::Int in 0:height-1
        vp::Int = v+1
        for u::Int in 0:width-1
            up::Int = u+1
            F[vp, up] = calcDftLog(data, u, v)
        end
    end
    min_spc = minimum(F)
    if min_spc < 0
        F = [x - min_spc for x in F]
    end
    max_spc = maximum(F)

    return amplitudeSpectrum(width, height, max_spc, F)
end

function DFTtoPGM(data::amplitudeSpectrum)::dataPGM
    F_log::Matrix{Float64} = zeros(Float64, data.height, data.width)
    F_normalized::Matrix{Float64} = zeros(Float64, data.height, data.width)
    if data.max_spc > 0
        F_log = [x / data.max_spc for x in data.spectrum]
        F_normalized = [x / data.max_spc * 255 for x in data.spectrum]
    end
    pixels::Matrix{Int16} = round.(Int16, F_normalized)
    return dataPGM("P2", data.width, data.height, 255, pixels)
end


end                             # module DFT
