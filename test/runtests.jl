#====================================================
#  runtests.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
using Test
using ImageProcessing
using ImageProcessing.IO
using ImageProcessing.Filter

@testset "I/O Tests" begin
    img_pgm = dataPGM("P2", 3, 3, 255,
                      [1 2 3; 4 5 6; 7 8 9])
    img_ppm = dataPPM("P3", 3, 3, 255,
                      [1 2 3; 4 5 6; 7 8 9],
                      [10 11 12; 13 14 15; 16 17 18],
                      [19 20 21; 22 23 24; 25 26 27])

    @testset "PBM Tests" begin
        save("img.pgm", img_pgm)
        input_pgm = load("img.pgm")
        @test input_pgm.magic_num == img_pgm.magic_num
        @test input_pgm.width == img_pgm.width
        @test input_pgm.height == img_pgm.height
        @test input_pgm.max_brightness == img_pgm.max_brightness
        @test input_pgm.pixels == img_pgm.pixels
    end

    @testset "PPM Tests" begin
        save("img.ppm", img_ppm)
        input_ppm = load("img.ppm")
        @test input_ppm.magic_num == img_ppm.magic_num
        @test input_ppm.width == img_ppm.width
        @test input_ppm.height == img_ppm.height
        @test input_ppm.max_brightness == img_ppm.max_brightness
        @test input_ppm.red == img_ppm.red
        @test input_ppm.green == img_ppm.green
        @test input_ppm.blue == img_ppm.blue
    end
end

@testset "Filter Tests" begin
    @testset "Averaging Filter" begin
        img_pgm = dataPGM("P2", 3, 3, 255,
                          [0 0 0; 0 9 0; 0 0 0])
        img_ppm = dataPPM("P3", 3, 3, 255,
                          [0 0 0; 0 9 0; 0 0 0],
                          [0 0 0; 0 18 0; 0 0 0],
                          [0 0 0; 0 27 0; 0 0 0])

        @testset "PGM Test" begin
            ave_pgm = averagingFilter(img_pgm)
            @test ave_pgm.magic_num == "P2"
            @test ave_pgm.width == 1
            @test ave_pgm.height == 1
            @test ave_pgm.max_brightness == 255
            @test ave_pgm.pixels == [1.0;;]
        end

        @testset "PPM Test" begin
            ave_ppm = averagingFilter(img_ppm)
            @test ave_ppm.magic_num == "P3"
            @test ave_ppm.width == 1
            @test ave_ppm.height == 1
            @test ave_ppm.max_brightness == 255
            @test ave_ppm.red == [1.0;;]
            @test ave_ppm.green == [2.0;;]
            @test ave_ppm.blue == [3.0;;]
        end
    end

    @testset "Gaussian Filter" begin
        img_pgm = dataPGM("P2", 3, 3, 255,
                          [1 1 1; 1 1 1; 1 1 1])
        img_ppm = dataPPM("P3", 3, 3, 255,
                          [1 1 1; 1 1 1; 1 1 1],
                          [2 2 2; 2 2 2; 2 2 2],
                          [3 3 3; 3 3 3; 3 3 3])

        @testset "PGM Test" begin
            gauss_pgm = gaussianFilter(img_pgm)
            @test gauss_pgm.magic_num == "P2"
            @test gauss_pgm.width == 1
            @test gauss_pgm.height == 1
            @test gauss_pgm.max_brightness == 255
            @test gauss_pgm.pixels == [1.0;;]
        end

        @testset "PPM Test" begin
            gauss_ppm = gaussianFilter(img_ppm)
            @test gauss_ppm.magic_num == "P3"
            @test gauss_ppm.width == 1
            @test gauss_ppm.height == 1
            @test gauss_ppm.max_brightness == 255
            @test gauss_ppm.red == [1.0;;]
            @test gauss_ppm.green == [2.0;;]
            @test gauss_ppm.blue == [3.0;;]
        end
    end

    @testset "Laplacian Filter" begin
        img_pgm = dataPGM("P2", 3, 3, 255,
                          [1 1 1; 1 1 1; 1 1 1])
        img_ppm = dataPPM("P3", 3, 3, 255,
                          [1 1 1; 1 1 1; 1 1 1],
                          [2 2 2; 2 2 2; 2 2 2],
                          [3 3 3; 3 3 3; 3 3 3])

        @testset "PGM Test" begin
            laplace_pgm = laplacianFilter(img_pgm)
            @test laplace_pgm.magic_num == "P2"
            @test laplace_pgm.width == 1
            @test laplace_pgm.height == 1
            @test laplace_pgm.max_brightness == 255
            @test laplace_pgm.pixels == [0.0;;]
        end

        @testset "PPM Test" begin
            laplace_ppm = laplacianFilter(img_ppm)
            @test laplace_ppm.magic_num == "P3"
            @test laplace_ppm.width == 1
            @test laplace_ppm.height == 1
            @test laplace_ppm.max_brightness == 255
            @test laplace_ppm.red == [0.0;;]
            @test laplace_ppm.green == [0.0;;]
            @test laplace_ppm.blue == [0.0;;]
        end
    end

    @testset "Sobel Filter" begin
        @testset "Sobel Filter Horizontal" begin
            img_pgm = dataPGM("P2", 3, 3, 255,
                              [0 0 1; 0 0 1; 0 0 1])
            img_ppm = dataPPM("P3", 3, 3, 255,
                              [0 0 1; 0 0 1; 0 0 1],
                              [0 0 2; 0 0 2; 0 0 2],
                              [0 0 3; 0 0 3; 0 0 3])

            @testset "PGM Test" begin
                sobel_pgm = sobelFilterHorizontal(img_pgm)
                @test sobel_pgm.magic_num == "P2"
                @test sobel_pgm.width == 1
                @test sobel_pgm.height == 1
                @test sobel_pgm.max_brightness == 255
                @test sobel_pgm.pixels == [4.0;;]
            end

            @testset "PPM Test" begin
                sobel_ppm = sobelFilterHorizontal(img_ppm)
                @test sobel_ppm.magic_num == "P3"
                @test sobel_ppm.width == 1
                @test sobel_ppm.height == 1
                @test sobel_ppm.max_brightness == 255
                @test sobel_ppm.red == [4.0;;]
                @test sobel_ppm.green == [8.0;;]
                @test sobel_ppm.blue == [12.0;;]
            end
        end

        @testset "Sobel Filter Vertical" begin
            img_pgm = dataPGM("P2", 3, 3, 255,
                              [1 1 1; 0 0 0; 0 0 0])
            img_ppm = dataPPM("P3", 3, 3, 255,
                              [1 1 1; 0 0 0; 0 0 0],
                              [2 2 2; 0 0 0; 0 0 0],
                              [3 3 3; 0 0 0; 0 0 0])

            @testset "PGM Test" begin
                sobel_pgm = sobelFilterVertical(img_pgm)
                @test sobel_pgm.magic_num == "P2"
                @test sobel_pgm.width == 1
                @test sobel_pgm.height == 1
                @test sobel_pgm.max_brightness == 255
                @test sobel_pgm.pixels == [4.0;;]
            end

            @testset "PPM Test" begin
                sobel_ppm = sobelFilterVertical(img_ppm)
                @test sobel_ppm.magic_num == "P3"
                @test sobel_ppm.width == 1
                @test sobel_ppm.height == 1
                @test sobel_ppm.max_brightness == 255
                @test sobel_ppm.red == [4.0;;]
                @test sobel_ppm.green == [8.0;;]
                @test sobel_ppm.blue == [12.0;;]
            end
        end

        @testset "Sobel Filter Gradient" begin
            img_pgm = dataPGM("P2", 3, 3, 255,
                              [1 1 1; 1 1 1; 0 0 0])
            img_ppm = dataPPM("P3", 3, 3, 255,
                              [1 1 1; 1 1 1; 0 0 0],
                              [2 2 2; 2 2 2; 0 0 0],
                              [3 3 3; 3 3 3; 0 0 0])

            @testset "PGM Test" begin
                sobel_pgm = sobelFilterGradient(img_pgm)
                @test sobel_pgm.magic_num == "P2"
                @test sobel_pgm.width == 1
                @test sobel_pgm.height == 1
                @test sobel_pgm.max_brightness == 255
                @test sobel_pgm.pixels == [4.0;;]
            end

            @testset "PPM Test" begin
                sobel_ppm = sobelFilterGradient(img_ppm)
                @test sobel_ppm.magic_num == "P3"
                @test sobel_ppm.width == 1
                @test sobel_ppm.height == 1
                @test sobel_ppm.max_brightness == 255
                @test sobel_ppm.red == [4.0;;]
                @test sobel_ppm.green == [8.0;;]
                @test sobel_ppm.blue == [12.0;;]
            end
        end
    end

    @testset "Unsharp Masking" begin
        img_pgm = dataPGM("P2", 3, 3, 255,
                          [0 0 0; 0 1 0; 0 0 0])
        img_ppm = dataPPM("P3", 3, 3, 255,
                          [0 0 0; 0 1 0; 0 0 0],
                          [0 0 0; 0 2 0; 0 0 0],
                          [0 0 0; 0 3 0; 0 0 0])

        @testset "PGM Test" begin
            unsharp_pgm = unsharpMasking(img_pgm, 9)
            @test unsharp_pgm.magic_num == "P2"
            @test unsharp_pgm.width == 1
            @test unsharp_pgm.height == 1
            @test unsharp_pgm.max_brightness == 255
            @test unsharp_pgm.pixels == [9.0;;]
        end

        @testset "PPM Test" begin
            unsharp_ppm = unsharpMasking(img_ppm, 9)
            @test unsharp_ppm.magic_num == "P3"
            @test unsharp_ppm.width == 1
            @test unsharp_ppm.height == 1
            @test unsharp_ppm.max_brightness == 255
            @test unsharp_ppm.red == [9.0;;]
            @test unsharp_ppm.green == [18.0;;]
            @test unsharp_ppm.blue == [27.0;;]
        end
    end

end
