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

function kmeansBinaryzation(data::dataPPM)::dataPPM
    width::UInt = data.width
    height::UInt = data.height
    red::Matrix{Float64} = data.red
    green::Matrix{Float64} = data.green
    blue::Matrix{Float64} = data.blue
    centroid_red::Vector{Float64} = rand(2) .* 255.0
    centroid_green::Vector{Float64} = rand(2) .* 255.0
    centroid_blue::Vector{Float64} = rand(2) .* 255.0
    new_centroid_red::Vector{Float64} = zeros(Float64, 2)
    new_centroid_green::Vector{Float64} = zeros(Float64, 2)
    new_centroid_blue::Vector{Float64} = zeros(Float64, 2)
    count::Vector{Int} = zeros(Int, 2)
    sum::Vector{Float64} = zeros(Float64, 2)
    d::Vector{Float64} = zeros(Float64, 2)
    label::Matrix{Int8} = zeros(Int8, height, width)
    ans_red::Matrix{Float64} = zeros(Float64, height, width)
    ans_green::Matrix{Float64} = zeros(Float64, height, width)
    ans_blue::Matrix{Float64} = zeros(Float64, height, width)
    for n in 1:MAX_NUM
        for i in 1:height
            for j in 1:width
                for k in 1:2
                    d[k] = abs(red[i, j] - centroid_red[k]) + abs(green[i, j] - centroid_green[k]) + abs(blue[i, j] - centroid_blue[k])
                end
                label[i, j] = d[1] < d[2] ? 0 : 1
            end
        end
        for k in 1:2
            new_centroid_red[k] = 0
            new_centroid_green[k] = 0
            new_centroid_blue[k] = 0
            count[k] = 0
        end
        for i in 1:height
            for j in 1:width
                new_centroid_red[label[i, j]+1] += red[i, j]
                new_centroid_green[label[i, j]+1] += green[i, j]
                new_centroid_blue[label[i, j]+1] += blue[i, j]
                count[label[i, j]+1] += 1
            end
        end
        for k in 1:2
            if count[k] > 0
                new_centroid_red[k] /= count[k]
                new_centroid_green[k] /= count[k]
                new_centroid_blue[k] /= count[k]
            else
                new_centroid_red[k] = centroid[k]
                new_centroid_green[k] = centroid[k]
                new_centroid_blue[k] = centroid[k]
            end
        end
        if abs(new_centroid_red[1] - centroid_red[1]) < threshold && abs(new_centroid_red[2] - centroid_red[2]) < threshold && abs(new_centroid_green[1] - centroid_green[1]) < threshold && abs(new_centroid_green[2] - centroid_green[2]) < threshold && abs(new_centroid_blue[1] - centroid_blue[1]) < threshold && abs(new_centroid_blue[2] - centroid_blue[2]) < threshold
            break
        end
        for k in 1:2
            centroid_red[k] = new_centroid_red[k]
            centroid_green[k] = new_centroid_green[k]
            centroid_blue[k] = new_centroid_blue[k]
        end
    end
    for k in 1:2
        sum[k] = centroid_red[k] + centroid_green[k] + centroid_blue[k]
    end
    black = sum[1] < sum[2] ? 0 : 1
    ans_red = [x == black ? 0 : 255 for x in label]
    ans_green = [x == black ? 0 : 255 for x in label]
    ans_blue = [x == black ? 0 : 255 for x in label]
    return dataPPM("P3", width, height, 255, ans_red, ans_green, ans_blue)
end
