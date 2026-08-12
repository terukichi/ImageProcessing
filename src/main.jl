#====================================================
#  main.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
# include("./programs/FileIO.jl")
# include("./programs/Filter.jl")
# include("./src/ImageProcessing.jl")
import ImageProcessing

using .ImageProcessing.IO, .ImageProcessing.Filter, .ImageProcessing

const AVERAGING = 0
const SOBEL_GRADIENT = 1
const SOBEL_LR = 2
const SOBEL_TD = 3
const GAUSSIAN = 4
const LAPLACIAN = 5
const UNSHARPMASK = 6

"""
# Show App Version
```julia
  printVersion()
```
"""
function printVersion()
    println("""
    version 0.1.0
    """)
end

"""
# Show Help
```julia
  printHelp()
```
"""
function printHelp()
    println("""
    Usage: julia main.jl [FILENAME] [OPTION-OR-COMMAND]

    Options:
        --help, -h       print this help and exit
        --version, -v    print version information and exit

    Commands:
        averaging        averaging filter
        gaussian         gaussian filter
        sobel-gradient   sobel filter (gradient)
        sobel-LR         sobel filter (horizontal)
        sobel-TD         sobel filter (vertical)
        laplacian        laplacian filter
        sharpening       unsharp masking
    """)
end

"""
# PPM File
```julia
  ppm(name::AbstractString,
      ext::AbstractString,
      operation::AbstractString,
      magic_num::AbstractString,
      width::Int, height::Int,
      max_brightness::Int16,
      rgb::Vector{Int16},
      cmd::UInt8)
```

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `rgb::Vector{Int16}`
- `cmd::UInt8`

## Return value
"""
function ppm(name::AbstractString, ext::AbstractString,
             operation::AbstractString,
             loaded, cmd::UInt8)
    width::Int = loaded.width
    height::Int = loaded.height
    rgb::Vector{Int16} = loaded.pixels
    red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16} = createRGBMatrix(width, height, rgb)

    data = dataPPM(loaded.magic_num, width, height, loaded.max_brightness, red, green, blue)

    if cmd == AVERAGING
        data = averagingFilter(data)
    elseif cmd == SOBEL_GRADIENT
        data = sobelFilterGradient(data)
    elseif cmd == SOBEL_LR
        data = sobelFilterHorizontal(data)
    elseif cmd == SOBEL_TD
        data = sobelFilterVertical(data)
    elseif cmd == GAUSSIAN
        data = gaussianFilter(data)
    elseif cmd == LAPLACIAN
        data = laplacianFilter(data)
    elseif cmd == UNSHARPMASK
        k::Int8 = parse(Int8, split(operation, "-")[end])
        data = unsharpMasking(data, k)
    end

    savePPM(name, ext, operation, data)
end

"""
# PGM File
```julia
  pgm(name::AbstractString,
      ext::AbstractString,
      operation::AbstractString,
      magic_num::AbstractString,
      width::Int, height::Int,
      max_brightness::Int16,
      pixels::Vector{Int16},
      cmd::UInt8)
```

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `magic_num::AbstractString`
- `width::Int`
- `height::Int`
- `max_brightness::Int16`
- `pixels::Vector{Int16}`
- `cmd::UInt8`

## Return value
"""
function pgm(name::AbstractString, ext::AbstractString,
             operation::AbstractString,
             loaded, cmd::UInt8)
    width::Int = loaded.width
    height::Int = loaded.height
    pixels::Matrix{Int16} = createGrayscaleMatrix(width, height, loaded.pixels)
    data = dataPGM(loaded.magic_num, width, height, loaded.max_brightness, pixels)

    if cmd == AVERAGING
        data = averagingFilter(data)
    elseif cmd == SOBEL_GRADIENT
        data = sobelFilterGradient(data)
    elseif cmd == SOBEL_LR
        data = sobelFilterHorizontal(data)
    elseif cmd == SOBEL_TD
        data = sobelFilterVertical(data)
    elseif cmd == GAUSSIAN
        data = gaussianFilter(data)
    elseif cmd == LAPLACIAN
        data = laplacianFilter(data)
    elseif cmd == UNSHARPMASK
        k::Int8 = parse(Int8, split(operation, "-")[end])
        data = unsharpMasking(data, k)
    end

    savePGM(name, ext, operation, data)
end

"""
# Main
```julia
  main(ARGS::Vector{String})
```

## Usage:
```julia
  julia main.jl [FILENAME] [OPTION-OR-COMMAND]
```

## Options:
```
   | OPTION          | Summary                            |
   |-----------------|------------------------------------|
   | --help, -h      | print this help and exit           |
   | --version, -v   | print version information and exit |
```

## Commands:
```
   | COMMAND         | Summary                   |
   |-----------------|---------------------------|
   | averaging       | averaging filter          |
   | gaussian        | gaussian filter           |
   | sobel-gradient  | sobel filter (gradient)   |
   | sobel-LR        | sobel filter (horizontal) |
   | sobel-TD        | sobel filter (vertical)   |
   | laplacian       | laplacian filter          |
   | sharpening      | unsharp masking           |
```
"""
function main(ARGS::Vector{String})
    cmd::UInt8 = 0

    if length(ARGS) < 1
        println("Parameter error.")
        return
    elseif length(ARGS) == 1
        if ARGS[1] == "-h" || ARGS[1] == "--help"
            printHelp()
            return
        elseif ARGS[1] == "-v" || ARGS[1] == "--version"
            printVersion()
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
    elseif ARGS[2] == "gaussian"
        cmd = GAUSSIAN
    elseif ARGS[2] == "laplacian"
        cmd = LAPLACIAN
    elseif occursin(r"^sharpening-[1-9][0-9]*$", ARGS[2])
        cmd = UNSHARPMASK
    else
        println("Try other command.")
        return
    end

    path::String = ARGS[1]
    filename::String = basename(path)
    name::String, ext::String = splitext(filename)
    if ext != ".ppm" && ext != ".pgm"
        println("Input \".ppm\" or \".pgm\"")
        return
    end

    magic_num::String = ""

    width::Int = 0
    height::Int = 0
    max_brightness::Int16 = 0

    pixels::Vector{Int16} = []

    loaded = loadFile(path)

    if loaded.magic_num == "P3"
        ppm(name, ext, ARGS[2], loaded, cmd)
    end

    if loaded.magic_num == "P2"
        pgm(name, ext, ARGS[2], loaded, cmd)
    end

    return
end


@time main(ARGS)
