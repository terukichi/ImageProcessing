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

include("./IO_Tests.jl")
include("./Filter_Tests.jl")
