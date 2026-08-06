#====================================================
#  Filter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
module Filter

export conv, averaging, sobelGradient, sobelLR, sobelTD


function conv(width, height, data::Matrix{Int16}, filter)::Matrix{Int16}
    img = Float64.(data)
    padded::Matrix{Float64} = zeros(Float64, height + 2, width + 2)
    padded[2:end-1, 2:end-1].=img

    for i in 1:height
        for j in 1:width
            img[i, j] = sum(padded[i:i+2, j:j+2] .* filter)
        end
    end

    return round.(Int16, img)
end

function normalize(width, height, data::Matrix{Float64})::Matrix{Int16}
    img::Matrix{Int16} = round.(Int16, data)
    for i in 1:height
        for j in 1:width
            if img[i, j] < 0
                img[i, j] = 0
            elseif img[i, j] > 255
                img[i, j] = 255
            end
        end
    end
    return img
end

function averaging(width, height, data::Matrix{Int16})::Matrix{Int16}
    filter = [1.0/9.0 1.0/9.0 1.0/9.0;
              1.0/9.0 1.0/9.0 1.0/9.0;
              1.0/9.0 1.0/9.0 1.0/9.0]
    img::Matrix{Float64} = conv(width, height, data, filter)
    result::Matrix{Int16} = normalize(width, height, img)
    return result
end

function averaging(width, height, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = averaging(width, height, r)
    g = averaging(width, height, g)
    b = averaging(width, height, b)
    return r,g,b
end

function sobelLR(width, height, data::Matrix{Int16})::Matrix{Float64}
    filterLR = [-1 0 1;
                -2 0 2;
                -1 0 1]
    imgLR::Matrix{Float64} = conv(width, height, data, filterLR)
    return imgLR
end

function sobelLR(width, height, data::Matrix{Int16})::Matrix{Int16}
    filterLR = [-1 0 1;
                -2 0 2;
                -1 0 1]
    imgLR::Matrix{Float64} = conv(width, height, data, filterLR)
    result::Matrix{Int16} = normalize(width, height, imgLR)
    return result
end

function sobelLR(width, height, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelLR(width, height, r)
    g = sobelLR(width, height, g)
    b = sobelLR(width, height, b)
    return r,g,b
end

function sobelTD(width, height, data::Matrix{Int16})::Matrix{Float64}
    filterTD = [ 1  2  1;
                 0  0  0;
                -1 -2 -1]
    imgTD::Matrix{Float64} = conv(width, height, data, filterTD)
    return imgTD
end
function sobelTD(width, height, data::Matrix{Int16})::Matrix{Int16}
    filterTD = [ 1  2  1;
                 0  0  0;
                -1 -2 -1]
    imgTD::Matrix{Float64} = conv(width, height, data, filterTD)
    result::Matrix{Int16} = normalize(width, height, imgTD)
    return result
end

function sobelTD(width, height, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelTD(width, height, r)
    g = sobelTD(width, height, g)
    b = sobelTD(width, height, b)
    return r,g,b
end

function sobelGradient(width, height, data::Matrix{Int16})::Matrix{Int16}
    imgLR::Matrix{Float64} = sobelLR(width, height, data)
    imgTD::Matrix{Float64} = sobelTD(width, height, data)
    img::Matrix{Float64} = sqrt.(imgLR.^2 + imgTD.^2)
    result::Matrix{Int16} = normalize(width, height, img)
    return result
end

function sobelGradient(width, height, r::Matrix{Int16}, g::Matrix{Int16}, b::Matrix{Int16})::Tuple{Matrix{Int16}, Matrix{Int16}, Matrix{Int16}}
    r = sobelGradient(width, height, r)
    g = sobelGradient(width, height, g)
    b = sobelGradient(width, height, b)
    return r,g,b
end


end
