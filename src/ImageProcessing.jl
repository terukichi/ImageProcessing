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

### FileIO

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

include("./programs/dataFormat.jl")
export dataPGM, dataPPM, dataLoaded

include("./programs/FileIO.jl")
include("./programs/Filter.jl")


end # module ImageProsessing
