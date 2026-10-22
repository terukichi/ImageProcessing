#====================================================
#  Binaryzation.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Binaryzation

## Functions

- `normalBinaryzation`
- `kmeansBinaryzation`
"""
module Binaryzation

using ..ImageProcessing: dataPPM, dataPGM


include("binaryzation/NormalBinaryzation.jl")
include("binaryzation/KmeansBinaryzation.jl")

export  normalBinaryzation, kmeansBinaryzation


end                             # module Binaryzation
