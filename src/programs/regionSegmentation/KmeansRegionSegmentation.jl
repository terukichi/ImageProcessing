#====================================================
#  KmeansRegionSegmentation.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
using Random

import ImageProcessing
using ImageProcessing
using ImageProcessing.IO

const MAX_NUM =  100
const threshold = 0.1

function changed(new_centroid::Vector{Float64},
                 centroid::Vector{Float64},
                 k::Integer)::Bool
    for i in 1:k
        if abs(new_centroid[i] - centroid[i]) > threshold
            return true
        end
    end
    return false
end

function kmeansRegionSegmentation(data::dataPGM, k::Integer)::dataPGM
    width::UInt = data.width
    height::UInt = data.height
    pixels::Matrix{Float64} = data.pixels
    centroid::Vector{Float64} = rand(k) .* 255.0
    new_centroid::Vector{Float64} = zeros(Float64, k)
    count::Vector{Int} = zeros(Int, k)
    d::Vector{Float64} = zeros(Float64, k)
    label::Matrix{Int8} = zeros(Int8, height, width)
    ans::Matrix{Float64} = zeros(Float64, height, width)
    for n in 1:MAX_NUM
        for i in 1:height
            for j in 1:width
                for x in 1:k
                    d[x] = abs(pixels[i, j] - centroid[x])
                end
                label[i, j] = argmin(d)
            end
        end
        for x in 1:k
            new_centroid[x] = 0
            count[x] = 0
        end
        for i in 1:height
            for j in 1:width
                new_centroid[label[i, j]] += pixels[i, j]
                count[label[i, j]] += 1
            end
        end
        for x in 1:k
            if count[x] > 0
                new_centroid[x] /= count[x]
            else
                new_centroid[x] = centroid[x]
            end
        end
        if !changed(new_centroid, centroid, k)
            break
        end
        for x in 1:k
            centroid[x] = new_centroid[x]
        end
    end
    ans = [centroid[x] for x in label]
    return dataPGM("P2", width, height, 255, ans)
end

function changed(new_centroid_red::Vector{Float64},
                 centroid_red::Vector{Float64},
                 new_centroid_green::Vector{Float64},
                 centroid_green::Vector{Float64},
                 new_centroid_blue::Vector{Float64},
                 centroid_blue::Vector{Float64},
                 k::Integer)::Bool
    for i in 1:k
        if abs(new_centroid_red[i] - centroid_red[i]) > threshold
            return true
        end
    end
    for i in 1:k
        if abs(new_centroid_green[i] - centroid_green[i]) > threshold
            return true
        end
    end
    for i in 1:k
        if abs(new_centroid_blue[i] - centroid_blue[i]) > threshold
            return true
        end
    end
    return false
end

function kmeansRegionSegmentation(data::dataPPM, k::Integer)::dataPPM
    width::UInt = data.width
    height::UInt = data.height
    red::Matrix{Float64} = data.red
    green::Matrix{Float64} = data.green
    blue::Matrix{Float64} = data.blue
    centroid_red::Vector{Float64} = rand(k) .* 255.0
    centroid_green::Vector{Float64} = rand(k) .* 255.0
    centroid_blue::Vector{Float64} = rand(k) .* 255.0
    new_centroid_red::Vector{Float64} = zeros(Float64, k)
    new_centroid_green::Vector{Float64} = zeros(Float64, k)
    new_centroid_blue::Vector{Float64} = zeros(Float64, k)
    count::Vector{Int} = zeros(Int, k)
    sum::Vector{Float64} = zeros(Float64, k)
    d::Vector{Float64} = zeros(Float64, k)
    label::Matrix{Int8} = zeros(Int8, height, width)
    ans_red::Matrix{Float64} = zeros(Float64, height, width)
    ans_green::Matrix{Float64} = zeros(Float64, height, width)
    ans_blue::Matrix{Float64} = zeros(Float64, height, width)
    for n in 1:MAX_NUM
        for i in 1:height
            for j in 1:width
                for x in 1:k
                    d[x] = abs(red[i, j] - centroid_red[x]) + abs(green[i, j] - centroid_green[x]) + abs(blue[i, j] - centroid_blue[x])
                end
                label[i, j] = argmin(d)
            end
        end
        for x in 1:k
            new_centroid_red[x] = 0
            new_centroid_green[x] = 0
            new_centroid_blue[x] = 0
            count[x] = 0
        end
        for i in 1:height
            for j in 1:width
                new_centroid_red[label[i, j]] += red[i, j]
                new_centroid_green[label[i, j]] += green[i, j]
                new_centroid_blue[label[i, j]] += blue[i, j]
                count[label[i, j]] += 1
            end
        end
        for x in 1:k
            if count[x] > 0
                new_centroid_red[x] /= count[x]
                new_centroid_green[x] /= count[x]
                new_centroid_blue[x] /= count[x]
            else
                new_centroid_red[x] = centroid_red[x]
                new_centroid_green[x] = centroid_green[x]
                new_centroid_blue[x] = centroid_blue[x]
            end
        end
        if !changed(new_centroid_red, centroid_red, new_centroid_green, centroid_green, new_centroid_blue, centroid_blue, k)
            break
        end
        for x in 1:k
            centroid_red[x] = new_centroid_red[x]
            centroid_green[x] = new_centroid_green[x]
            centroid_blue[x] = new_centroid_blue[x]
        end
    end
    for x in 1:k
        sum[x] = centroid_red[x] + centroid_green[x] + centroid_blue[x]
    end
    ans_red = [centroid_red[x] for x in label]
    ans_green = [centroid_green[x] for x in label]
    ans_blue = [centroid_blue[x] for x in label]
    return dataPPM("P3", width, height, 255, ans_red, ans_green, ans_blue)
end
