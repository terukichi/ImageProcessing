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

- `loadFile`
- `savePPM`
- `savePGM`
- `loadPPM`
- `loadPGM`
- `createGrayscaleMatrix`
- `createRGBMatrix`
"""
module IO

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM, dataFrequency


include("io/Input.jl")
include("io/Output.jl")

export save, loadPGM, loadPPM, load


end                             # module IO
