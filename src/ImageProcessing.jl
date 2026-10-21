#====================================================
#  ImageProcessing.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# ImageProcessing

## Functions

### IO

#### Public

- `save`
- `load`
- `loadPPM`
- `loadPGM`

### Filter

#### Public

- `averagingFilter`
- `gaussianFilter`
- `sobelFilterHorizontal`
- `sobelFilterVertical`
- `sobelFilterGradient`
- `laplacianFilter`
- `unsharpMasking`

### FrequencyFilter

#### Public

- `dft`
- `idft`
- `fft`
- `ifft`
- `lowPassFilter`
- `highPassFilter`
- `bandPassFilter`

### Binaryzation

#### Public

- `normalBinaryzation`
- `kmeansBinaryzation`

### RegionSegmentation

#### Public

- `kmeansRegionSegmentation`
"""
module ImageProcessing

include("./programs/DataFormat.jl")
export dataPGM, dataPPM, dataLoaded

include("./programs/IO.jl")
include("./programs/Filter.jl")
include("./programs/FrequencyFilter.jl")
include("./programs/Binaryzation.jl")
include("./programs/RegionSegmentation.jl")
include("./programs/ZeroPadding.jl")
export zeroPadding


end # module ImageProsessing
