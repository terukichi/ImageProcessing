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
    width::Int
    height::Int
    max_brightness::Int16
    pixels::Vector{Int16}
end

mutable struct dataPGM
    magic_num::String
    width::Int
    height::Int
    max_brightness::Int16
    pixels::Matrix{Int16}
end

mutable struct dataPPM
    magic_num::String
    width::Int
    height::Int
    max_brightness::Int16
    red::Matrix{Int16}
    green::Matrix{Int16}
    blue::Matrix{Int16}
end
