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

export amplitudeSpectrum
export dft, DFTtoPGM, idft, lowPassFilter, highPassFilter


mutable struct amplitudeSpectrum
    width::Int
    height::Int
    spectrum::Matrix{Complex{Float64}}
end


function EVENxEVEN(data::amplitudeSpectrum)::Matrix{Complex{Float64}}
    spectrum::Matrix{Complex{Float64}} = data.spectrum
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function EVENxODD(data::amplitudeSpectrum)::Matrix{Complex{Float64}}
    spectrum::Matrix{Complex{Float64}} = data.spectrum
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)+1] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+2:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)+1] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+2:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function ODDxEVEN(data::amplitudeSpectrum)::Matrix{Complex{Float64}}
    spectrum::Matrix{Complex{Float64}} = data.spectrum
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(Int, end/2)+1, 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+2:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2)+1, floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+2:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function ODDxODD(data::amplitudeSpectrum)::Matrix{Complex{Float64}}
    spectrum::Matrix{Complex{Float64}} = data.spectrum
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(Int, end/2)+1, 1:floor(Int, end/2)+1] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2)+1, floor(Int, end/2)+2:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+2:end, 1:floor(Int, end/2)+1] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+2:end, floor(Int, end/2)+2:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function arrangeMatrix(data::amplitudeSpectrum)::amplitudeSpectrum
    height::Int = data.height
    width::Int = data.width
    spectrum::Matrix{Complex{Float64}} = data.spectrum
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

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
    return amplitudeSpectrum(width, height, arranged)
end

function EVENxEVEN(width::Int, height::Int, spectrum::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)]
    return arranged
end

function EVENxODD(width::Int, height::Int, spectrum::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+1:end, floor(Int, end/2)+2:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+1:end, 1:floor(Int, end/2)+1]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2), floor(Int, end/2)+2:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2), 1:floor(Int, end/2)+1]
    return arranged
end

function ODDxEVEN(width::Int, height::Int, spectrum::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+2:end, floor(Int, end/2)+1:end]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2)+1, floor(Int, end/2)+1:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+2:end, 1:floor(Int, end/2)]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2)+1, 1:floor(Int, end/2)]
    return arranged
end

function ODDxODD(width::Int, height::Int, spectrum::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(Int, end/2), 1:floor(Int, end/2)] = spectrum[floor(Int, end/2)+2:end, floor(Int, end/2)+2:end]
    arranged[1:floor(Int, end/2), floor(Int, end/2)+1:end] = spectrum[floor(Int, end/2)+2:end, 1:floor(Int, end/2)+1]
    arranged[floor(Int, end/2)+1:end, 1:floor(Int, end/2)] = spectrum[1:floor(Int, end/2)+1, floor(Int, end/2)+2:end]
    arranged[floor(Int, end/2)+1:end, floor(Int, end/2)+1:end] = spectrum[1:floor(Int, end/2)+1, 1:floor(Int, end/2)+1]
    return arranged
end

function arrangeMatrix(width::Int, height::Int, spectrum::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    if iseven(height)
        if iseven(width)
            arranged = EVENxEVEN(width, height, spectrum)
        else
            arranged = EVENxODD(width, height, spectrum)
        end
    else
        if iseven(width)
            arranged = ODDxEVEN(width, height, spectrum)
        else
            arranged = ODDxODD(width, height, spectrum)
        end
    end
    return arranged
end

function calcDft(data::dataPGM, u::Int, v::Int)::Complex{Float64}
    ans::Complex{Float64} = 0.0
    height::Float64 = Float64(data.height)
    width::Float64 = Float64(data.width)
    for y::Int in 0:height-1
        yp::Int = y+1
        for x::Int in 0:width-1
            xp::Int = x+1
            theta::Float64 = 2pi*(u*x/width+v*y/height)
            fxy::Float64 = data.pixels[yp, xp]/255.0
            ans += fxy * cos(theta)
            ans -= fxy * im*sin(theta)
        end
    end
    return ans
end

function dft(data::dataPGM)::amplitudeSpectrum
    height::Int = data.height
    width::Int = data.width
    F::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)
    for v::Int in 0:height-1
        vp::Int = v+1
        for u::Int in 0:width-1
            up::Int = u+1
            F[vp, up] = calcDft(data, u, v)
        end
    end

    ans = amplitudeSpectrum(width, height, F)
    return arrangeMatrix(ans)
end

function calcIdft(data::amplitudeSpectrum, x::Int, y::Int)::Float64
    cmp::Complex{Float64} = 0.0
    ams::Float64 = 0.0
    height::Float64 = Float64(data.height)
    width::Float64 = Float64(data.width)
    for v::Int in 0:height-1
        vp::Int = v+1
        for u::Int in 0:width-1
            up::Int = u+1
            theta::Float64 = 2pi*(u*x/width+v*y/height)
            Fuv::Complex{Float64} = data.spectrum[vp, up]*255.0
            cmp += Fuv * cos(theta)
            cmp += Fuv * im*sin(theta)
        end
    end
    ans = abs(cmp/height/width)
    return ans
end

function idft(data::amplitudeSpectrum)::dataPGM
    height::Int = data.height
    width::Int = data.width
    f::Matrix{Float64} = zeros(Float64, height, width)
    data.spectrum = arrangeMatrix(width, height, data.spectrum)
    for y::Int in 0:height-1
        yp::Int = y+1
        for x::Int in 0:width-1
            xp::Int = x+1
            f[yp, xp] = calcIdft(data, x, y)
        end
    end
    return dataPGM("P2", width, height, 255, f)
end

function DFTtoPGM(data::amplitudeSpectrum)::dataPGM
    F::Matrix{Float64} = [abs(x) for x in data.spectrum]
    pixels::Matrix{Int16} = round.(Int16, F)
    return dataPGM("P2", data.width, data.height, 255, pixels)
end

function lowPassFilter(data::amplitudeSpectrum, radius::Float64)::amplitudeSpectrum
    width::Int = data.width
    height::Int = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) < radius^2 ? 1 : 0  for y in 1:height, x in 1:width]
    data.spectrum = data.spectrum .* mask
    return data
end

function highPassFilter(data::amplitudeSpectrum, radius::Float64)::amplitudeSpectrum
    width::Int = data.width
    height::Int = data.height
    mask::Matrix{Int8} = [((x-width/2)^2+(y-height/2)^2) > radius^2 ? 1 : 0  for y in 1:height, x in 1:width]
    data.spectrum = data.spectrum .* mask
    return data
end

end                             # module DFT
