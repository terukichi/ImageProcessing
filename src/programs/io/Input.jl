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
  loadFile(path::AbstractString)::dataLoaded
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
            result.width = parse(UInt, data[2])
            result.height = parse(UInt, data[3])
            result.max_brightness = parse(UInt16, data[4])
            result.pixels = parse.(UInt16, data[5:end])
        catch e
            @error "File parameter error." exception=e
        end
    else
        println("File format error.")
    end

    return result
end

"""
# Create Grayscale Matrix
```julia
  createGrayscaleMatrix(width::UInt, height::UInt,
                        pixels::Vector{Int16})::Matrix{Float64}
```

## Summary
Create grayscale matrix from list

## Arguments
- `width::UInt`
- `heigh::UInt`
- `pixels::Vector{Int16}`

## Return value
- `gray::Matrix{Float64}`
"""
function createGrayscaleMatrix(width::UInt, height::UInt, pixels::Vector{Int16})::Matrix{Float64}
    return transpose(reshape(Float64.(pixels), width, height))
end

"""
# Create RGB Matrix
```julia
  createRGBMatrix(width::UInt, height::UInt,
                  pixels::Vector{Int16})
                  ::Tuple{Matrix{Float64}, Matrix{Float64}, Matrix{Float64}}
```

## Summary
Create RGB matrix from list

## Arguments
- `width::UInt`
- `heigh::UInt`
- `pixels::Vector{Int16}`

## Return value
- `red::Matrix{Float64}`
- `green::Matrix{Float64}`
- `blue::Matrix{Float64}`
"""
function createRGBMatrix(width::UInt, height::UInt, pixels::Vector{Int16})::Tuple{Matrix{Float64}, Matrix{Float64}, Matrix{Float64}}
    red::Matrix{Float64} = createGrayscaleMatrix(width, height, pixels[1:3:end])
    green::Matrix{Float64} = createGrayscaleMatrix(width, height, pixels[2:3:end])
    blue::Matrix{Float64} = createGrayscaleMatrix(width, height, pixels[3:3:end])
    return red, green, blue
end

"""
# Load PGM Data
```julia
  loadPGM(path::AbstractString)::dataPGM
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
    width::UInt = loaded.width
    height::UInt = loaded.height
    max_brightness::Int16 = loaded.max_brightness
    pixels::Vector{Int16} = loaded.pixels
    gray::Matrix{Float64} = createGrayscaleMatrix(width, height, pixels)
    return dataPGM(magic_num, width, height, max_brightness, gray)
end

"""
# Load PPM Data
```julia
  loadPPM(path::AbstractString)::dataPPM
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
    width::UInt = loaded.width
    height::UInt = loaded.height
    max_brightness::Int16 = loaded.max_brightness
    pixels::Vector{Int16} = loaded.pixels
    red::Matrix{Float64}, green::Matrix{Float64}, blue::Matrix{Float64} = createRGBMatrix(width, height, pixels)
    return dataPPM(magic_num, width, height, max_brightness, red, green, blue)
end
