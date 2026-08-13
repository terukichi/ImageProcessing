#====================================================
#  FrequencyFilter.jl
#
#  Copyright (c) 2026 terukichi
#
#  This project is licensed under the MIT License.
#  See the LICENSE file.
====================================================#
module FrequencyFilter

using ..ImageProcessing: dataLoaded, dataPPM, dataPGM, dataFrequency


include("freqFilter/ArrangeMatrix.jl")
include("freqFilter/DFT.jl")
include("freqFilter/IDFT.jl")
include("freqFilter/LowPassFilter.jl")
include("freqFilter/HighPassFilter.jl")

export amplitudeSpectrum
export dft, idft, lowPassFilter, highPassFilter


end                             # module DFT
