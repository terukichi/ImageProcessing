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

export dft, DFTtoPGM, amplitudeSpectrum, arrangeMatrix

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
    height::Int = data.height
    width::Int = data.width
    max_spc::Float64 = 0.0
    F::Matrix{Float64} = zeros(Float64, height, width)
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

function EVENxEVEN(data::amplitudeSpectrum)::Matrix{Float64}
    spectrum::Matrix{Float64} = data.spectrum
    arranged::Matrix{Float64} = zeros(Float64, data.height, data.width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function EVENxODD(data::amplitudeSpectrum)::Matrix{Float64}
    spectrum::Matrix{Float64} = data.spectrum
    arranged::Matrix{Float64} = zeros(Float64, data.height, data.width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)+1] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+2:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)+1] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+2:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function ODDxEVEN(data::amplitudeSpectrum)::Matrix{Float64}
    spectrum::Matrix{Float64} = data.spectrum
    arranged::Matrix{Float64} = zeros(Float64, data.height, data.width)

    arranged[1:floor(Int, end/2)+1, 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+2:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2)+1, floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+2:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function ODDxODD(data::amplitudeSpectrum)::Matrix{Float64}
    spectrum::Matrix{Float64} = data.spectrum
    arranged::Matrix{Float64} = zeros(Float64, data.height, data.width)

    arranged[1:floor(Int, end/2)+1, 1:floor(Int, end/2)+1] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2)+1, floor(Int, end/2)+2:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+2:end, 1:floor(Int, end/2)+1] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+2:end, floor(Int, end/2)+2:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function arrangeMatrix(data::amplitudeSpectrum)::amplitudeSpectrum
    height::Int = data.height
    width::Int = data.width
    max_spc::Float64 = data.max_spc
    spectrum::Matrix{Float64} = data.spectrum
    arranged::Matrix{Float64} = zeros(Float64, height, width)

    if iseven(height)
        if iseven(width)
            arranged = EVENxEVEN(data)
        else
            arranged = EVENxODD(data)
        end
    else
        if iseven(width)
            arranged = ODDxEVEN(data)
        else
            arranged = ODDxODD(data)
        end
    end
    return amplitudeSpectrum(width, height, max_spc, arranged)
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
