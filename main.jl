#====================================================
#  main.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
include("./programs/FileIO.jl")

using .FileIO


function main(ARGS)
    if length(ARGS) < 1
        println("Parameter error.")
        return
    end

    path::String = ARGS[1]
    filename::String = basename(path)
    operation::String = ""

    data = loadFile(path)

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
    max_brightness::Int = parse(Int, data[4])

    if magic_num == "P3"
        rgb = parse.(Int, data[5:end])
        red = transpose(reshape(rgb[1:3:end], width, height))
        green = transpose(reshape(rgb[2:3:end], width, height))
        blue = transpose(reshape(rgb[3:3:end], width, height))

        savePPM(filename, operation,
                magic_num,
                width, height,
                max_brightness,
                red, green, blue)
    end

    if magic_num == "P2"
        gray = transpose(reshape(parse.(Int, data[5:end]), width, height))

        savePGM(filename, operation,
                magic_num,
                width, height,
                max_brightness,
                gray)
    end

    return
end


main(ARGS)
