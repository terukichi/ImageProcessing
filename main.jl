#====================================================
#  main.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
include("./programs/FileIO.jl")
include("./programs/Filter.jl")

using .FileIO, .Filter

const AVERAGING = 0
const SOBEL_GRADIENT = 1
const SOBEL_LR = 2
const SOBEL_TD = 3

function ppm(filename::AbstractString,
             operation::AbstractString,
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16, rgb::Vector{Int16}, cmd::UInt8)

    red::Matrix{Int16} = transpose(reshape(rgb[1:3:end], width, height))
    green::Matrix{Int16} = transpose(reshape(rgb[2:3:end], width, height))
    blue::Matrix{Int16} = transpose(reshape(rgb[3:3:end], width, height))

    if cmd == AVERAGING
        red, green, blue = averaging(width, height, red, green, blue)
    elseif cmd == SOBEL_GRADIENT
        red, green, blue = sobelGradient(width, height, red, green, blue)
    elseif cmd == SOBEL_LR
        red, green, blue = sobelLR(width, height, red, green, blue)
    elseif cmd == SOBEL_TD
        red, green, blue = sobelTD(width, height, red, green, blue)
    end
    savePPM(filename, operation, magic_num,
            width, height, max_brightness,
            red, green, blue)
end

function pgm(filename::AbstractString,
             operation::AbstractString,
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16,
             gray::Matrix{Int16}, cmd::UInt8)

    if cmd == AVERAGING
        gray = averaging(width, height, gray)
    elseif cmd == SOBEL_GRADIENT
        gray = sobelGradient(width, height, gray)
    elseif cmd == SOBEL_LR
        gray = sobelLR(width, height, gray)
    elseif cmd == SOBEL_TD
        gray = sobelTD(width, height, gray)
    end
    savePGM(filename, operation, magic_num,
            width, height, max_brightness,
            gray)
end

function main(ARGS::Vector{String})
    cmd::UInt8 = 0

    if length(ARGS) < 1
        println("Parameter error.")
        return
    elseif length(ARGS) == 1
        if ARGS[1] == "-h" || ARGS[1] == "--help"
            println("""
            Usage: julia main.jl [FILENAME] [OPTION-OR-COMMAND]

            Options:
                --help, -h       print this help and exit
                --version, -v    print version information and exit

            Commands:
                averaging        averaging filter
                sobel-gradient   sobel filter (gradient)
                sobel-LR         sobel filter (horizontal)
                sobel-TD         sobel filter (vertical)
            """)
            return
        elseif ARGS[1] == "-v" || ARGS[1] == "--version"
            println("""
            version 0.0.0
            """)
            return
        end
    elseif length(ARGS) < 2
        println("Parameter error.")
        return
    elseif ARGS[2] == "averaging"
        cmd = AVERAGING
    elseif ARGS[2] == "sobel-gradient"
        cmd = SOBEL_GRADIENT
    elseif ARGS[2] == "sobel-LR"
        cmd = SOBEL_LR
    elseif ARGS[2] == "sobel-TD"
        cmd = SOBEL_TD
    else
        println("Try other command.")
        return
    end

    path::String = ARGS[1]
    filename::String = basename(path)

    data::Vector{String} = loadFile(path)

    if length(data) < 4
        println("File parameter error.")
        return
    end

    magic_num::String = data[1]

    if magic_num != "P2" && magic_num != "P3"
        println("Format error.")
        println("Try \"P2\" or \"P3\".")
        return
    end

    width::Int = parse(Int, data[2])
    height::Int = parse(Int, data[3])
    max_brightness::Int16 = parse(Int16, data[4])

    if magic_num == "P3"
        rgb::Vector{Int16} = parse.(Int16, data[5:end])
        ppm(filename, ARGS[2], magic_num,
            width, height, max_brightness, rgb, cmd)
    end

    if magic_num == "P2"
        gray::Matrix{Int16} = transpose(reshape(parse.(Int16, data[5:end]), width, height))
        pgm(filename, ARGS[2], magic_num,
             width, height, max_brightness, gray, cmd)
    end

    return
end


@time main(ARGS)
