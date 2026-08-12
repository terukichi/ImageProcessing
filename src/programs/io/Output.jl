#====================================================
#  Output.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
include("Clipping.jl")

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
        open("output/"*name*"-"*operation*ext, "a") do f
            println(f, magic_num)
            print(f, width)
            print(f, " ")
            println(f, height)
            println(f, max_brightness)
        end
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PNM's Header
```julia
  saveHeader(path::AbstractString,
             magic_num::AbstractString,
             width::Int, height::Int,
             max_brightness::Int16)
```

## Summary
Save header information

## Arguments
- `path::AbstractString`
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
        open("output/"*path, "a") do f
            println(f, magic_num)
            print(f, width)
            print(f, " ")
            println(f, height)
            println(f, max_brightness)
        end
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PPM Data
```julia
  savePPM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          ppm::dataPPM)
```

## Summary
Save PPM data

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `ppm::dataPPM`

## Return value
"""
function savePPM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 ppm::dataPPM)
    magic_num::String = ppm.magic_num
    width::Int = ppm.width
    height::Int = ppm.height
    max_brightness::Int16 = ppm.max_brightness
    red::Matrix{Int16} = round.(Int16, ppm.red)
    green::Matrix{Int16} = round.(Int16, ppm.green)
    blue::Matrix{Int16} = round.(Int16, ppm.blue)
    red = clipping(width, height, red)
    green = clipping(width, height, green)
    blue = clipping(width, height, blue)
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do f
            for i::Int in 1:height
                for j::Int in 1:width
                    print(f, red[i, j])
                    print(f, " ")
                    print(f, green[i, j])
                    print(f, " ")
                    print(f, blue[i, j])
                    print(f, " ")
                end
                print(f, "\n")
            end
        end
        println("Saved "*"output/"*name*"-"*operation*ext)
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PPM Data
```julia
  savePPM(path::AbstractString, ppm::dataPPM)
```

## Summary
Save PPM data

## Arguments
- `path::AbstractString`
- `ppm::dataPPM`

## Return value
"""
function savePPM(path::AbstractString,
                 ppm::dataPPM)
    magic_num::String = ppm.magic_num
    width::Int = ppm.width
    height::Int = ppm.height
    max_brightness::Int16 = ppm.max_brightness
    red::Matrix{Int16} = round.(Int16, ppm.red)
    green::Matrix{Int16} = round.(Int16, ppm.green)
    blue::Matrix{Int16} = round.(Int16, ppm.blue)
    red = clipping(width, height, red)
    green = clipping(width, height, green)
    blue = clipping(width, height, blue)
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open("output/"*path, "a") do f
            for i::Int in 1:height
                for j::Int in 1:width
                    print(f, red[i, j])
                    print(f, " ")
                    print(f, green[i, j])
                    print(f, " ")
                    print(f, blue[i, j])
                    print(f, " ")
                end
                print(f, "\n")
            end
        end
        println("Saved "*"output/"*path)
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PGM Data
```julia
  savePGM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          pgm::dataPGM)
```

## Summary
Save PGM data

## Arguments
- `name::AbstractString`
- `ext::AbstractString`
- `operation::AbstractString`
- `pgm::dataPGM`

## Return value
"""
function savePGM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 pgm::dataPGM)
    magic_num::String = pgm.magic_num
    width::Int = pgm.width
    height::Int = pgm.height
    max_brightness::Int16 = pgm.max_brightness
    pixels::Matrix{Int16} = round.(Int16, pgm.pixels)
    pixels = clipping(width, height, pixels)
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do f
            for i::Int in 1:height
                for j::Int in 1:width-1
                    print(f, pixels[i, j])
                    print(f, " ")
                end
                print(f, pixels[i, width])
                print(f, "\n")
            end
        end

        println("Saved "*"output/"*name*"-"*operation*ext)
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PGM Data
```julia
  savePGM(path::AbstractString, pgm::dataPGM)
```

## Summary
Save PGM data

## Arguments
- `path::AbstractString`
- `pgm::dataPGM`

## Return value
"""
function savePGM(path::AbstractString,
                 pgm::dataPGM)
    magic_num::String = pgm.magic_num
    width::Int = pgm.width
    height::Int = pgm.height
    max_brightness::Int16 = pgm.max_brightness
    pixels::Matrix{Int16} = round.(Int16, pgm.pixels)
    pixels = clipping(width, height, pixels)
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open("output/"*path, "a") do f
            for i::Int in 1:height
                for j::Int in 1:width-1
                    print(f, pixels[i, j])
                    print(f, " ")
                end
                print(f, pixels[i, width])
                print(f, "\n")
            end
        end

        println("Saved "*"output/"*path)
    catch e
        @error "Save error." exception=e
    end
end
