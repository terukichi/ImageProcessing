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

- `loadFile`
- `savePPM`
- `savePGM`
- `loadGrayscale`
- `loadRGB`
- `createGrayscaleMatrix`
- `createRGBMatrix`

#### Private

- `saveHeader`

### Filter

#### Public

- `averaging`
- `gaussian`
- `sobelLR`
- `sobelTD`
- `sobelGradient`
- `laplacian`

#### Private

- `convolution`
- `clipping`

### FrequencyFilter

#### Public

- `dft`
- `idft`
- `lowPassFilter`
- `highPassFilter`

#### Private

- `EVENxEVEN`
- `EVENxODD`
- `ODDxEVEN`
- `ODDxODD`
- `arrangeMatrix`
- `calcDft`
- `calcIdft`
"""
module ImageProcessing

include("./programs/DataFormat.jl")
export dataPGM, dataPPM, dataLoaded

include("./programs/IO.jl")
include("./programs/Filter.jl")
include("./programs/FrequencyFilter.jl")
include("./programs/Binaryzation.jl")
include("./programs/ZeroPadding.jl")
export zeroPadding


end # module ImageProsessing
