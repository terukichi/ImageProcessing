#====================================================
#  Output.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
    red::Matrix{Int16} = ppm.red
    green::Matrix{Int16} = ppm.green
    blue::Matrix{Int16} = ppm.blue
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
          ppm::dataPPM)
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
    red::Matrix{Int16} = ppm.red
    green::Matrix{Int16} = ppm.green
    blue::Matrix{Int16} = ppm.blue
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
    magic_num::String = ppm.magic_num
    width::Int = ppm.width
    height::Int = ppm.height
    max_brightness::Int16 = ppm.max_brightness
    pixels::Matrix{Int16} = ppm.pixels
    saveHeader(name, ext, operation, magic_num, width, height, max_brightness)

    try
        open("output/"*name*"-"*operation*ext, "a") do io
            for i in 1:height
                for j in 1:width-1
                    print(io, pixels[i, j])
                    print(io, " ")
                end
                print(io, pixels[i, width])
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
          pgm::dataPGM)
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
    magic_num::String = ppm.magic_num
    width::Int = ppm.width
    height::Int = ppm.height
    max_brightness::Int16 = ppm.max_brightness
    pixels::Matrix{Int16} = ppm.pixels
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open("output/"*path, "a") do io
            for i in 1:height
                for j in 1:width-1
                    print(io, pixels[i, j])
                    print(io, " ")
                end
                print(io, pixels[i, width])
                print(io, "\n")
            end
        end

        println("Saved "*"output/"*path)
    catch e
        @error "Load error." exception=e
    end
end
