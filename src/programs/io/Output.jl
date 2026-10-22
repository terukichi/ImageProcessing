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
  saveHeader(path::AbstractString,
             magic_num::AbstractString,
             width::UInt, height::UInt,
             max_brightness::Int16)
```

## Summary
Save header information

## Arguments
- `path::AbstractString`
- `magic_num::AbstractString`
- `width::UInt`
- `height::UInt`
- `max_brightness::Int16`

## Return value
"""
function saveHeader(path::AbstractString,
                    magic_num::AbstractString,
                    width::UInt, height::UInt,
                    max_brightness::Int16)

    try
        write(path, "")
        open(path, "a") do f
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
             width::UInt, height::UInt)
```

## Summary
Save header information

## Arguments
- `path::AbstractString`
- `magic_num::AbstractString`
- `width::UInt`
- `height::UInt`

## Return value
"""
function saveHeader(path::AbstractString,
                    magic_num::AbstractString,
                    width::UInt, height::UInt)

    try
        write(path, "")
        open(path, "a") do f
            println(f, magic_num)
            print(f, width)
            print(f, " ")
            println(f, height)
        end
    catch e
        @error "Save error." exception=e
    end
end

"""
# Save PPM Data
```julia
  save(path::AbstractString, ppm::dataPPM)
```

## Summary
Save PPM data

## Arguments
- `path::AbstractString`
- `ppm::dataPPM`

## Return value
"""
function save(path::AbstractString,
              ppm::dataPPM)
    ext::AbstractString = split(path, ".")[end]
    magic_num::String = ppm.magic_num
    width::UInt = ppm.width
    height::UInt = ppm.height
    max_brightness::Int16 = ppm.max_brightness
    red::Matrix{Int16} = round.(Int16, ppm.red)
    green::Matrix{Int16} = round.(Int16, ppm.green)
    blue::Matrix{Int16} = round.(Int16, ppm.blue)
    if ext == "pbm"
        rgb_sum::Matrix{Int16} = red + green + blue
        pixels::Matrix{Int8} = zeros(Int8, height, width)

        for i::UInt in 1:height
             for j::UInt in 1:width
                 pixels[i, j] = rgb_sum[i, j] == max_brightness*3 ? 1 : 0
             end
        end
        saveHeader(path, "P1", width, height)

        try
            open(path, "a") do f
                for i::UInt in 1:height
                    for j::UInt in 1:width
                        print(f, pixels[i, j])
                        print(f, " ")
                    end
                    print(f, "\n")
                end
            end

        catch e
            @error "Save error." exception=e
        end
    else
        red = clipping(width, height, red)
        green = clipping(width, height, green)
        blue = clipping(width, height, blue)
        saveHeader(path, magic_num, width, height, max_brightness)

        try
            open(path, "a") do f
                for i::UInt in 1:height
                    for j::UInt in 1:width
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

        catch e
            @error "Save error." exception=e
        end
    end
end

"""
# Save PGM Data
```julia
  save(path::AbstractString, pgm::dataPGM)
```

## Summary
Save PGM data

## Arguments
- `path::AbstractString`
- `pgm::dataPGM`

## Return value
"""
function save(path::AbstractString,
              pgm::dataPGM)
    ext::AbstractString = split(path, ".")[end]
    magic_num::String = pgm.magic_num
    width::UInt = pgm.width
    height::UInt = pgm.height
    max_brightness::Int16 = pgm.max_brightness
    pixels::Matrix{Int16} = round.(Int16, pgm.pixels)
    if ext == "pbm"
        for i::UInt in 1:height
             for j::UInt in 1:width
                 pixels[i, j] = pixels[i, j] == max_brightness ? 1 : 0
             end
        end
        saveHeader(path, "P1", width, height)

        try
            open(path, "a") do f
                for i::UInt in 1:height
                    for j::UInt in 1:width
                        print(f, pixels[i, j])
                        print(f, " ")
                    end
                    print(f, "\n")
                end
            end

        catch e
            @error "Save error." exception=e
        end
    else
        pixels = clipping(width, height, pixels)
        saveHeader(path, magic_num, width, height, max_brightness)

        try
            open(path, "a") do f
                for i::UInt in 1:height
                    for j::UInt in 1:width-1
                        print(f, pixels[i, j])
                        print(f, " ")
                    end
                    print(f, pixels[i, width])
                    print(f, "\n")
                end
            end

        catch e
            @error "Save error." exception=e
        end
    end
end

function FtoPGM(data::dataFrequency)::dataPGM
    F::Matrix{Float64} = [abs(x) for x in data.frequency]
    pixels::Matrix{UInt} = round.(UInt, F)
    return dataPGM("P2", data.width, data.height, 255, pixels)
end

"""
# Save PGM Data
```julia
  save(path::AbstractString, freq::dataFrequency)
```

## Summary
Save PGM data

## Arguments
- `path::AbstractString`
- `freq::dataFrequency`

## Return value
"""
function save(path::AbstractString,
              freq::dataFrequency)
    width::UInt = freq.width
    height::UInt = freq.height
    pgm::dataPGM = FtoPGM(freq)
    magic_num::String = pgm.magic_num
    max_brightness::Int16 = pgm.max_brightness
    pixels::Matrix{Float64} = pgm.pixels
    clipped::Matrix{Int16} = clipping(width, height, pixels)
    saveHeader(path, magic_num, width, height, max_brightness)

    try
        open(path, "a") do f
            for i::UInt in 1:height
                for j::UInt in 1:width-1
                    print(f, clipped[i, j])
                    print(f, " ")
                end
                print(f, clipped[i, width])
                print(f, "\n")
            end
        end

    catch e
        @error "Save error." exception=e
    end
end
