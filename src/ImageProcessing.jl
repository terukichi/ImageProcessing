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

- `conv`
- `clipping`
"""
module ImageProcessing

include("./programs/DataFormat.jl")
export dataPGM, dataPPM, dataLoaded

include("./programs/IO.jl")
include("./programs/Filter.jl")


end # module ImageProsessing
