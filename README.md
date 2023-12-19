# ParquetStores

[![Build Status](https://github.com/femtotrader/ParquetStores.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/femtotrader/ParquetStores.jl/actions/workflows/CI.yml?query=branch%3Amaster)

A simple Julia project to store parquet files.

## Install
Open julia CLI.
type `] dev` https://github.com/femtotrader/ParquetStores.jl/

## Usage

```julia
julia> using ParquetStores
julia> ps = ParquetStore(joinpath(pwd(), "data", "parquet"))
julia> libraries(ps)
julia> lib = library(ps)["exchange.spot.klines.D"]
julia> ds = read(lib, "SYMBOL")

julia> using DataFrames, using TableOperations
julia> DataFrame(ds)
julia> ds |> TableOperations.select(:time, :open, :high, :low, :close, :volume) |> DataFrame

julia> using TimeSeries
julia> ds |> TableOperations.select(:time, :open, :high, :low, :close, :volume) |> t -> TimeArray(t, timestamp=:time)
```
