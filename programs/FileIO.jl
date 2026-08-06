#====================================================
#  FileIO.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
module FileIO

export loadFile, savePPM, savePGM


function loadFile(path)
    data = String[]

    try
        buffer = read(path, String)
        data = split(buffer)
    catch e
        @error "Load error." exception=e
    end

    return data
end

function saveHeader(name, ext, operation, magic_num,
                    width, height,
                    max_brightness)
    if !isdir("output")
        mkdir("output")
    end
    try
        write("output/"*name*operation*ext, "")
        open("output/"*name*operation*ext, "a") do io
            println(io, magic_num)
            print(io, width)
            print(io, " ")
            println(io, height)
            println(io, max_brightness)
        end
    catch e
        @error "Load error." exception=e
    end
end

function savePPM(filename, operation, magic_num,
                 width, height, max_brightness,
                 red, green, blue)
    name, ext = splitext(filename)
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*operation*ext, "a") do io
            for i in 1:height
                for j in 1:width
                    print(io, red[i, j])
                    print(io, " ")
                    print(io, green[i, j])
                    print(io, " ")
                    print(io, blue[i, j])
                    print(io, " ")
                end
                print(io, "\n")
            end
        end
        println("Saved "*"output/"*name*operation*ext)
    catch e
        @error "Load error." exception=e
    end
end

function savePGM(filename, operation, magic_num,
                 width, height, max_brightness, gray)
    name, ext = splitext(filename)
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*operation*ext, "a") do io
            for i in 1:height
                for j in 1:width-1
                    print(io, gray[i, j])
                    print(io, " ")
                end
                print(io, gray[i, width])
                print(io, "\n")
            end
        end

        println("Saved "*"output/"*name*operation*ext)
    catch e
        @error "Load error." exception=e
    end
end


end                             # module
