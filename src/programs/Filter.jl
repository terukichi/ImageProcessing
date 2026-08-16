#====================================================
#  Filter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# Filter

## Functions

### Public

- `averagingFilter`
- `gaussianFilter`
- `sobelFilterHorizontal`
- `sobelFilterVertical`
- `sobelFilterGradient`
- `laplacianFilter`
- `unsharpMasking`

### Private

- `convolution`
"""
module Filter

using ..ImageProcessing: dataPPM, dataPGM


include("filter/Convolution.jl")
include("filter/AveragingFilter.jl")
include("filter/GaussianFilter.jl")
include("filter/SobelFilter.jl")
include("filter/LaplacianFilter.jl")
include("filter/UnsharpMasking.jl")

export averagingFilter, sobelFilterGradient, sobelFilterHorizontal, sobelFilterVertical, gaussianFilter, laplacianFilter, unsharpMasking


end                             # module Filter
