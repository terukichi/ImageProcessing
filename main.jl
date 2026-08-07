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
    version 0.0.0
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
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16, rgb::Vector{Int16}, cmd::UInt8)

    red::Matrix{Int16}, green::Matrix{Int16}, blue::Matrix{Int16} = createRGBMatrix(width, height, rgb)

    if cmd == AVERAGING
        red, green, blue = averaging(width, height, red, green, blue)
    elseif cmd == SOBEL_GRADIENT
        red, green, blue = sobelGradient(width, height, red, green, blue)
    elseif cmd == SOBEL_LR
        red, green, blue = sobelLR(width, height, red, green, blue)
    elseif cmd == SOBEL_TD
        red, green, blue = sobelTD(width, height, red, green, blue)
    elseif cmd == GAUSSIAN
        red, green, blue = gaussian(width, height, red, green, blue)
    elseif cmd == LAPLACIAN
        red, green, blue = laplacian(width, height, red, green, blue)
    elseif cmd == UNSHARPMASK
        k::Int8 = parse(Int8, split(operation, "-")[end])
        red, green, blue = unsharpMask(width, height, red, green, blue, k)
    end

    savePPM(name, ext, operation, magic_num,
            width, height, max_brightness,
            red, green, blue)
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
      gray::Vector{Int16},
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
- `gray::Vector{Int16}`
- `cmd::UInt8`

## Return value
"""
function pgm(name::AbstractString, ext::AbstractString,
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
    elseif cmd == GAUSSIAN
        gray = gaussian(width, height, gray)
    elseif cmd == LAPLACIAN
        gray = laplacian(width, height, gray)
    elseif cmd == UNSHARPMASK
        k::Int8 = parse(Int8, split(operation, "-")[end])
        gray = unsharpMask(width, height, gray, k)
    end

    savePGM(name, ext, operation, magic_num,
            width, height, max_brightness,
            gray)
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

    magic_num, width, height, max_brightness, pixels = loadFile(path)

    if magic_num == "P3"
        rgb::Vector{Int16} = pixels
        ppm(name, ext, ARGS[2], magic_num,
            width, height, max_brightness, rgb, cmd)
    end

    if magic_num == "P2"
        gray::Matrix{Int16} = createGrayscaleMatrix(width, height, pixels)
        pgm(name, ext, ARGS[2], magic_num,
             width, height, max_brightness, gray, cmd)
    end

    return
end


@time main(ARGS)
