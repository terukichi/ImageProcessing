#====================================================
#  IO_Tests.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
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
