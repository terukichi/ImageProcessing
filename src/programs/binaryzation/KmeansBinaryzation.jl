#====================================================
#  Kmeans.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
using Random

const MAX_NUM =  100
const threshold = 0.1

function kmeansBinaryzation(data::dataPGM)::dataPGM
    width::UInt = data.width
    height::UInt = data.height
    pixels::Matrix{Float64} = data.pixels
    centroid::Vector{Float64} = rand(2) .* 255.0
    new_centroid::Vector{Float64} = zeros(Float64, 2)
    count::Vector{Int} = zeros(Int, 2)
    d::Vector{Float64} = zeros(Float64, 2)
    label::Matrix{Int8} = zeros(Int8, height, width)
    ans::Matrix{Float64} = zeros(Float64, height, width)
    for n in 1:MAX_NUM
        for i in 1:height
            for j in 1:width
                for k in 1:2
                    d[k] = abs(pixels[i, j] - centroid[k])
                end
                label[i, j] = d[1] < d[2] ? 0 : 1
            end
        end
        for k in 1:2
            new_centroid[k] = 0
            count[k] = 0
        end
        for i in 1:height
            for j in 1:width
                new_centroid[label[i, j]+1] += pixels[i, j]
                count[label[i, j]+1] += 1
            end
        end
        for k in 1:2
            if count[k] > 0
                new_centroid[k] /= count[k]
            else
                new_centroid[k] = centroid[k]
            end
        end
        if abs(new_centroid[1] - centroid[1]) < threshold && abs(new_centroid[2] - centroid[2]) < threshold
            break
        end
        for k in 1:2
            centroid[k] = new_centroid[k]
        end
    end
    black = centroid[1] < centroid[2] ? 0 : 1
    ans = [x == black ? 0 : 255 for x in label]
    return dataPGM("P2", width, height, 255, ans)
end
