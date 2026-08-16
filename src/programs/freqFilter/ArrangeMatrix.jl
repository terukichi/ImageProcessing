#====================================================
#  ArrangeMatrix.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
function EVENxEVEN(data::dataFrequency)::Matrix{Complex{Float64}}
    frequency::Matrix{Complex{Float64}} = data.frequency
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)]
    return arranged
end

function EVENxODD(data::dataFrequency)::Matrix{Complex{Float64}}
    frequency::Matrix{Complex{Float64}} = data.frequency
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)+1] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+2:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)+1] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+2:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)]
    return arranged
end

function ODDxEVEN(data::dataFrequency)::Matrix{Complex{Float64}}
    frequency::Matrix{Complex{Float64}} = data.frequency
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(UInt, end/2)+1, 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+2:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2)+1, floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+2:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)]
    return arranged
end

function ODDxODD(data::dataFrequency)::Matrix{Complex{Float64}}
    frequency::Matrix{Complex{Float64}} = data.frequency
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, data.height, data.width)

    arranged[1:floor(UInt, end/2)+1, 1:floor(UInt, end/2)+1] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2)+1, floor(UInt, end/2)+2:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+2:end, 1:floor(UInt, end/2)+1] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+2:end, floor(UInt, end/2)+2:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)]
    return arranged
end

function arrangeMatrix(data::dataFrequency)::dataFrequency
    height::UInt = data.height
    width::UInt = data.width
    frequency::Matrix{Complex{Float64}} = data.frequency
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    if iseven(height)
        if iseven(width)
            arranged = EVENxEVEN(data)
        else
            arranged = EVENxODD(data)
        end
    else
        if iseven(width)
            arranged = ODDxEVEN(data)
        else
            arranged = ODDxODD(data)
        end
    end
    return dataFrequency(width, height, data.add_width, data.add_height, arranged)
end

function EVENxEVEN(width::UInt, height::UInt, frequency::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)]
    return arranged
end

function EVENxODD(width::UInt, height::UInt, frequency::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+1:end, floor(UInt, end/2)+2:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)+1]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2), floor(UInt, end/2)+2:end]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2), 1:floor(UInt, end/2)+1]
    return arranged
end

function ODDxEVEN(width::UInt, height::UInt, frequency::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+2:end, floor(UInt, end/2)+1:end]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2)+1, floor(UInt, end/2)+1:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+2:end, 1:floor(UInt, end/2)]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2)+1, 1:floor(UInt, end/2)]
    return arranged
end

function ODDxODD(width::UInt, height::UInt, frequency::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    arranged[1:floor(UInt, end/2), 1:floor(UInt, end/2)] = frequency[floor(UInt, end/2)+2:end, floor(UInt, end/2)+2:end]
    arranged[1:floor(UInt, end/2), floor(UInt, end/2)+1:end] = frequency[floor(UInt, end/2)+2:end, 1:floor(UInt, end/2)+1]
    arranged[floor(UInt, end/2)+1:end, 1:floor(UInt, end/2)] = frequency[1:floor(UInt, end/2)+1, floor(UInt, end/2)+2:end]
    arranged[floor(UInt, end/2)+1:end, floor(UInt, end/2)+1:end] = frequency[1:floor(UInt, end/2)+1, 1:floor(UInt, end/2)+1]
    return arranged
end

function arrangeMatrix(width::UInt, height::UInt, frequency::Matrix{Complex{Float64}})::Matrix{Complex{Float64}}
    arranged::Matrix{Complex{Float64}} = zeros(Complex{Float64}, height, width)

    if iseven(height)
        if iseven(width)
            arranged = EVENxEVEN(width, height, frequency)
        else
            arranged = EVENxODD(width, height, frequency)
        end
    else
        if iseven(width)
            arranged = ODDxEVEN(width, height, frequency)
        else
            arranged = ODDxODD(width, height, frequency)
        end
    end
    return arranged
end
