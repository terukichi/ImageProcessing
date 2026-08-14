# ImageProcessing

## Summary

- _ImageProcessing_ is an image processing package.

## Language

- **Julia**

## Image File Format

- **PPM** (P3)
- **PGM** (P2)

## Installation

1. Start julia.

   ```shell
   $ julia
   ```

2. Push `]` key.

   ```julia
   julia> ]
   ```

3. Activate your project.

   ```julia
   (@version) pkg> activate .
   ```

4. Install this package.
   ```julia
   (your project) pkg> add https://github.com/terukichi/ImageProcessing.git
   ```

## Functions

### Base

- zeroPadding

  ```julia
  zeroPadding(data::dataPGM)::dataPGM
  ```

  ```julia
  zeroPadding(data::dataPPM)::dataPPM
  ```

  ```julia
  zeroPadding(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
  ```

### IO

- Load File
  ```julia
  loadFile(path::AbstractString)::dataLoaded
  ```
  ```julia
  loadPGM(path::AbstractString)::dataPGM
  ```
  ```julia
  loadPPM(path::AbstractString)::dataPPM
  ```
- Create Matrix
  ```julia
  createGrayscaleMatrix(width::UInt, height::UInt, pixels::Vector{Int16})::Matrix{Float64}
  ```
  ```julia
  createRGBMatrix(width::UInt, height::UInt, pixels::Vector{Int16})::Tuple{Matrix{Float64}, Matrix{Float64}, Matrix{Float64}}
  ```
- Save File
  ```julia
  saveHeader(name::AbstractString, ext::AbstractString, operation::AbstractString, magic_num::AbstractString, width::UInt, height::UInt, max_brightness::Int16)
  ```
  ```julia
  saveHeader(path::AbstractString, magic_num::AbstractString, width::UInt, height::UInt, max_brightness::Int16)
  ```
  ```julia
  savePPM(name::AbstractString, ext::AbstractString, operation::AbstractString, ppm::dataPPM)
  ```
  ```julia
  savePPM(path::AbstractString, ppm::dataPPM)
  ```
  ```julia
  savePGM(name::AbstractString, ext::AbstractString, operation::AbstractString, pgm::dataPGM)
  ```
  ```julia
  savePGM(path::AbstractString, pgm::dataPGM)
  ```
  ```julia
  savePGM(path::AbstractString, freq::dataFrequency)
  ```

### Filter

- Averaging Filter
  ```julia
  averagingFilter(data::dataPGM)::dataPGM
  ```
  ```julia
  averagingFilter(data::dataPPM)::dataPPM
  ```
- Gaussian Filter
  ```julia
  gaussianFilter(data::dataPGM)::dataPGM
  ```
  ```julia
  gaussianFilter(data::dataPPM)::dataPPM
  ```
- Sobel Filter
  ```julia
  sobelFilterHorizontal(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
  ```
  ```julia
  sobelFilterHorizontal(data::dataPGM)::dataPGM
  ```
  ```julia
  sobelFilterHorizontal(data::dataPPM)::dataPPM
  ```
  ```julia
  sobelFilterVertical(width::UInt, height::UInt, pixels::Matrix{Float64})::Matrix{Float64}
  ```
  ```julia
  sobelFilterVertical(data::dataPGM)::dataPGM
  ```
  ```julia
  sobelFilterVertical(data::dataPPM)::dataPPM
  ```
  ```julia
  sobelFilterGradient(data::dataPGM)::dataPGM
  ```
  ```julia
  sobelFilterGradient(data::dataPPM)::dataPPM
  ```
- Laplacian Filter
  ```julia
  laplacianFilter(data::dataPGM)::dataPGM
  ```
  ```julia
  laplacianFilter(data::dataPPM)::dataPPM
  ```
- Unsharp Masking
  ```julia
  unsharpMasking(data::dataPGM, k::Int8)::dataPGM
  ```
  ```julia
  unsharpMasking(data::dataPPM, k::Int8)::dataPPM
  ```

### FrequencyFilter

- DFT
  ```julia
  dft(data::dataPGM)::dataFrequency
  ```
- IDFT
  ```julia
  idft(data::dataFrequency)::dataPGM
  ```
- Lowpass Filter
  ```julia
  lowPassFilter(data::dataFrequency, radius::Float64)::dataFrequency
  ```
- Highpass Filter
  ```julia
  highPassFilter(data::dataFrequency, radius::Float64)::dataFrequency
  ```
- Bandpass Filter
  ```julia
  bandPassFilter(data::dataFrequency, radius_a::Float64, radius_b::Float64)::dataFrequency
  ```
