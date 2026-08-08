#====================================================
#  IO.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# IO

## Functions

### Public

- `loadFile`
- `savePPM`
- `savePGM`
- `loadGrayscale`
- `loadRGB`
- `createGrayscaleMatrix`
- `createRGBMatrix`

### Private

- `saveHeader`
"""
module IO

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM


include("io/Input.jl")
include("io/Output.jl")

export loadFile, savePPM, savePGM, loadPGM, loadPPM, createGrayscaleMatrix, createRGBMatrix


end                             # module IO
