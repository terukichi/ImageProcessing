#====================================================
#  IO.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# IO

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
module IO

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM

export loadFile, savePPM, savePGM, loadPGM, loadPPM, createGrayscaleMatrix, createRGBMatrix

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
function loadFile(path::AbstractString)::dataLoaded
    data::Vector{String} = []
    result = dataLoaded("", 0, 0, 0, [])

    ext = split(path, ".")[end]

    if ext == "ppm" || ext == "pgm"
        try
            buffer::String = replace(read(path, String), r"#.*" => "")
            data = split(buffer)
        catch e
            @error "Load error." exception=e
        end

        try
            result.magic_num = data[1]
            result.width = parse(Int, data[2])
            result.height = parse(Int, data[3])
            result.max_brightness = parse(Int16, data[4])
            result.pixels = parse.(Int16, data[5:end])
        catch e
            @error "File parameter error." exception=e
        end
    end

    return result
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
# Load PGM Data
```julia
  loadPGM(path::AbstractString)
                ::dataPGM
```

## Summary
Load grayscale data

## Arguments
- `path::AbstractString`

## Return value
- `dataPGM`
"""
function loadPGM(path::AbstractString)::dataPGM
    loaded::dataLoaded = loadFile(path)
    magic_num::String = loaded.magic_num
    width::Int = loaded.width
    height::Int = loaded.height
    max_brightness::Int16 = loaded.max_brightness
    pixels::Vector{Int16} = loaded.pixels
    gray::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels)
    return dataPGM(magic_num, width, height, max_brightness, gray)
end

"""
# Load PPM Data
```julia
  loadPPM(path::AbstractString)
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
function loadPPM(path::AbstractString)::dataPPM
    loaded::dataLoaded = loadFile(path)
    magic_num::String = loaded.magic_num
    width::Int = loaded.width
    height::Int = loaded.height
    max_brightness::Int16 = loaded.max_brightness
    pixels::Vector{Int16} = loaded.pixels
    red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16} = createRGBMatrix(width, height, pixels)
    return dataPPM(magic_num, width, height, max_brightness, red, green, blue)
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
                 ppm::dataPPM)
    saveHeader(name, ext, operation, ppm.magic_num, ppm.width, ppm.height, ppm.max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do io
            for i in 1:ppm.height
                for j in 1:ppm.width
                    print(io, ppm.red[i, j])
                    print(io, " ")
                    print(io, ppm.green[i, j])
                    print(io, " ")
                    print(io, ppm.blue[i, j])
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
                 ppm::dataPPM)
    saveHeader(path, ppm.magic_num, ppm.width, ppm.height, ppm.max_brightness)

    try
        open("output/"*path, "a") do io
            for i in 1:ppm.height
                for j in 1:ppm.width
                    print(io, ppm.red[i, j])
                    print(io, " ")
                    print(io, ppm.green[i, j])
                    print(io, " ")
                    print(io, ppm.blue[i, j])
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
          pixels::Matrix{Int16})
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
- `pixels::Matrix{Int16}`

## Return value
"""
function savePGM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 pgm::dataPGM)
    saveHeader(name, ext, operation, pgm.magic_num, pgm.width, pgm.height, pgm.max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do io
            for i in 1:pgm.height
                for j in 1:pgm.width-1
                    print(io, pgm.pixels[i, j])
                    print(io, " ")
                end
                print(io, pgm.pixels[i, pgm.width])
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
          pixels::Matrix{Int16})
```

## Summary
Save PGM data

## Arguments
- `path::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `pixels::Matrix{Int16}`

## Return value
"""
function savePGM(path::AbstractString,
                 pgm::dataPGM)
    saveHeader(path, pgm.magic_num, pgm.width, pgm.height, pgm.max_brightness)

    try
        open("output/"*path, "a") do io
            for i in 1:pgm.height
                for j in 1:pgm.width-1
                    print(io, pgm.pixels[i, j])
                    print(io, " ")
                end
                print(io, pgm.pixels[i, pgm.width])
                print(io, "\n")
            end
        end

        println("Saved "*"output/"*path)
    catch e
        @error "Load error." exception=e
    end
end


end                             # module
