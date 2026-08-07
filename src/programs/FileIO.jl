#====================================================
#  FileIO.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# FileIO

## Functions

### Public

- `loadFile`
- `savePPM`
- `savePGM`
- `loadGrayscale`
- `loadRGB`
- `createGrayscaleMatrix`
- `createRGBMatrix`

### Private

- `saveHeader`
"""
module FileIO

export loadFile, savePPM, savePGM, loadGrayscale, loadRGB, createGrayscaleMatrix, createRGBMatrix


"""
# Load File
```julia
  loadFile(path::AbstractString)
           ::Tuple{String, Int, Int, Int16, Vector{Int16}}
```

## Summary
Load image file

## Arguments
- `path::AbstractString`

## Return value
- `magic_num::String`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `pixels::Vector{Int16}`
"""
function loadFile(path::AbstractString)::Tuple{String, Int, Int, Int16, Vector{Int16}}
    magic_num::String = ""
    width::Int = 0
    height::Int = 0
    max_brightness::Int16 = 0
    data::Vector{String} = []
    pixels::Vector{Int16} = []

    ext = split(path, ".")[end]

    if ext == "ppm" || ext == "pgm"
        try
            buffer::String = replace(read(path, String), r"#.*" => "")
            data = split(buffer)
        catch e
            @error "Load error." exception=e
        end

        try
            magic_num = data[1]
            width = parse(Int, data[2])
            height = parse(Int, data[3])
            max_brightness = parse(Int16, data[4])
            pixels = parse.(Int16, data[5:end])
        catch e
            @error "File parameter error." exception=e
        end
    end

    return magic_num, width, height, max_brightness, pixels
end

"""
# Create Grayscale Matrix
```julia
  createGrayscaleMatrix(width::Int, height::Int,
                        pixels::Vector{Int16})::Matrix{Int16}
```

## Summary
Create grayscale matrix from list

## Arguments
- `width::Int`
- `heigh::Int`
- `pixels::Vector{Int16}`

## Return value
- `gray::Matrix{Int16}`
"""
function createGrayscaleMatrix(width::Int, height::Int, pixels::Vector{Int16})::Matrix{Int16}
    return transpose(reshape(pixels, width, height))
end

"""
# Create RGB Matrix
```julia
  createRGBMatrix(width::Int, height::Int,
                  pixels::Vector{Int16})
                  ::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Create RGB matrix from list

## Arguments
- `width::Int`
- `heigh::Int`
- `pixels::Vector{Int16}`

## Return value
- `red::Matrix{Int16}`
- `green::Matrix{Int16}`
- `blue::Matrix{Int16}`
"""
function createRGBMatrix(width::Int, height::Int, pixels::Vector{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    red::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels[1:3:end])
    green::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels[2:3:end])
    blue::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels[3:3:end])
    return red, green, blue
end

"""
# Load Grayscale Data
```julia
  loadGrayscale(path::AbstractString)
                ::Tuple{String, Int, Int, Int16, Matrix{Int16}}
```

## Summary
Load grayscale data

## Arguments
- `path::AbstractString`

## Return value
- `magic_num::String`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `gray::Vector{Int16}`
"""
function loadGrayscale(path::AbstractString)::Tuple{String, Int, Int, Int16, Matrix{Int16}}
    magic_num::String, width::Int, height::Int, max_brightness::Int16, pixels::Vector{Int16} = loadFile(path)
    gray::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels)
    return magic_num, width, height, max_brightness, gray
end

"""
# Load RGB Data
```julia
  loadRGB(path::AbstractString)
          ::Tuple{String, Int, Int, Int16,
                  Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
```

## Summary
Load RGB data

## Arguments
- `path::AbstractString`

## Return value
- `magic_num::String`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `red::Vector{Int16}`
- `green::Vector{Int16}`
- `blue::Vector{Int16}`
"""
function loadRGB(path::AbstractString)::Tuple{String, Int, Int, Int16, Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    magic_num::String, width::Int, height::Int, max_brightness::Int16, pixels::Vector{Int16} = loadFile(path)
    red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16} = createRGBMatrix(width, height, pixels)
    return magic_num, width, height, max_brightness, red, green, blue
end

"""
# Save PNM's Header
```julia
  saveHeader(name::AbstractString,
             ext::AbstractString,
             operation::AbstractString,
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16)
```

## Summary
Save header information

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`

## Return value
"""
function saveHeader(name::AbstractString, ext::AbstractString,
                    operation::AbstractString,
                    magic_num::AbstractString,
                    width::Int, height::Int,
                    max_brightness::Int16)
    if !isdir("output")
        mkdir("output")
    end
    try
        write("output/"*name*"-"*operation*ext, "")
        open("output/"*name*"-"*operation*ext, "a") do io
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

"""
# Save PNM's Header
```julia
  saveHeader(path::AbstractString,
             ext::AbstractString,
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16)
```

## Summary
Save header information

## Arguments
- `path::AbstractString`
- `ext::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`

## Return value
"""
function saveHeader(path::AbstractString,
                    magic_num::AbstractString,
                    width::Int, height::Int,
                    max_brightness::Int16)
    if !isdir("output")
        mkdir("output")
    end
    try
        write("output/"*path, "")
        open("output/"*path, "a") do io
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

"""
# Save PPM Data
```julia
  savePPM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16,
          red::Matrix{Int16},
          green::Matrix{Int16},
          blue::Matrix{Int16})
```

## Summary
Save PPM data

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `red::Matrix{Int16}`
- `green::Matrix{Int16}`
- `blue::Matrix{Int16}`

## Return value
"""
function savePPM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 magic_num::AbstractString,
                 width::Int, height::Int, max_brightness::Int16,
                 red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16})
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do io
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
        println("Saved "*"output/"*name*"-"*operation*ext)
    catch e
        @error "Load error." exception=e
    end
end

"""
# Save PPM Data
```julia
  savePPM(path::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16,
          red::Matrix{Int16},
          green::Matrix{Int16},
          blue::Matrix{Int16})
```

## Summary
Save PPM data

## Arguments
- `path::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `red::Matrix{Int16}`
- `green::Matrix{Int16}`
- `blue::Matrix{Int16}`

## Return value
"""
function savePPM(path::AbstractString,
                 magic_num::AbstractString,
                 width::Int, height::Int, max_brightness::Int16,
                 red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16})
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open("output/"*path, "a") do io
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
        println("Saved "*"output/"*path)
    catch e
        @error "Load error." exception=e
    end
end

"""
# Save PGM Data
```julia
  savePGM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16,
          gray::Matrix{Int16})
```

## Summary
Save PGM data

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `gray::Matrix{Int16}`

## Return value
"""
function savePGM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 magic_num::AbstractString,
                 width::Int, height::Int, max_brightness::Int16,
                 gray::Matrix{Int16})
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do io
            for i in 1:height
                for j in 1:width-1
                    print(io, gray[i, j])
                    print(io, " ")
                end
                print(io, gray[i, width])
                print(io, "\n")
            end
        end

        println("Saved "*"output/"*name*"-"*operation*ext)
    catch e
        @error "Load error." exception=e
    end
end

"""
# Save PGM Data
```julia
  savePGM(path::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16,
          gray::Matrix{Int16})
```

## Summary
Save PGM data

## Arguments
- `path::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `gray::Matrix{Int16}`

## Return value
"""
function savePGM(path::AbstractString,
                 magic_num::AbstractString,
                 width::Int, height::Int, max_brightness::Int16,
                 gray::Matrix{Int16})
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open("output/"*path, "a") do io
            for i in 1:height
                for j in 1:width-1
                    print(io, gray[i, j])
                    print(io, " ")
                end
                print(io, gray[i, width])
                print(io, "\n")
            end
        end

        println("Saved "*"output/"*path)
    catch e
        @error "Load error." exception=e
    end
end


end                             # module
