#====================================================
#  RegionSegmentation.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# RegionSegmentation

## Functions

### Public

- `kmeansRegionSegmentation`
"""
module RegionSegmentation

using ..ImageProcessing: dataPPM, dataPGM


include("regionSegmentation/KmeansRegionSegmentation.jl")

export kmeansRegionSegmentation


end                             # module RegionSegmentation
