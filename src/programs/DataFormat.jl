#====================================================
#  DataFormat.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
mutable struct dataLoaded
    magic_num::String
    width::UInt
    height::UInt
    max_brightness::Int16
    pixels::Vector{Int16}
end

mutable struct dataPGM
    magic_num::String
    width::UInt
    height::UInt
    max_brightness::Int16
    pixels::Matrix{Float64}
end

mutable struct dataPPM
    magic_num::String
    width::UInt
    height::UInt
    max_brightness::Int16
    red::Matrix{Float64}
    green::Matrix{Float64}
    blue::Matrix{Float64}
end

mutable struct dataFrequency
    width::UInt
    height::UInt
    frequency::Matrix{Complex{Float64}}
end
