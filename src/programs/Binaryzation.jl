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

- `kmeansBinaryzation`
"""
module Binaryzation

using ..ImageProcessing: dataPPM, dataPGM


include("binaryzation/KmeansBinaryzation.jl")

export kmeansBinaryzation


end                             # module Binaryzation
