#====================================================
#  Input.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Load File
```julia
  loadFile(path::AbstractString)
           ::dataLoaded
```

## Summary
Load image file

## Arguments
- `path::AbstractString`

## Return value
- `result::dataLoaded`
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
- `data::dataPGM`
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
          ::dataPPM
```

## Summary
Load RGB data

## Arguments
- `path::AbstractString`

## Return value
- `data::dataPPM`
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
