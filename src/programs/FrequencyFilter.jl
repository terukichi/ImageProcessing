#====================================================
#  FrequencyFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
"""
# FrequencyFilter

## Functions

### Public

- `dft`
- `idft`
- `lowPassFilter`
- `highPassFilter`
- `bandPassFilter`
- `fft`
- `ifft`
"""
module FrequencyFilter

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM, dataFrequency


include("frequencyFilter/ArrangeMatrix.jl")
include("frequencyFilter/DFT.jl")
include("frequencyFilter/IDFT.jl")
include("frequencyFilter/LowPassFilter.jl")
include("frequencyFilter/HighPassFilter.jl")
include("frequencyFilter/BandPassFilter.jl")
include("frequencyFilter/FFT.jl")
include("frequencyFilter/IFFT.jl")

export amplitudeSpectrum
export dft, idft, lowPassFilter, highPassFilter, bandPassFilter, fft, ifft


end                             # module DFT
