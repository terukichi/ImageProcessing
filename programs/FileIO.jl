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

- loadFile
- savePPM
- savePGM

### Private

- saveHeader
"""
module FileIO

export loadFile, savePPM, savePGM


"""
# Load File
```julia
  loadFile(path::AbstractString)::Vector{String}
```

## Summary
Load image file

## Arguments
- `path::AbstractString`

## Return value
- `data::Vector{String}`
"""
function loadFile(path::AbstractString)::Vector{String}
    data::Vector{String} = []

    try
        buffer::String = read(path, String)
        data = split(buffer)
    catch e
        @error "Load error." exception=e
    end

    return data
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
# Save PPM Data
```julia
  savePPM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16)
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
# Save PGM Data
```julia
  savePGM(name::AbstractString,
          ext::AbstractString,
          operation::AbstractString,
          magic_num::AbstractString,
          width::Int, height::Int,
          max_brightness::Int16)
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

## Return value
"""
function savePGM(name::AbstractString, ext::AbstractString,
                 operation::AbstractString,
                 magic_num::AbstractString,
                 width::Int, height::Int, max_brightness::Int16, gray::Matrix{Int16})
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


end                             # module
