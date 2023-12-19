using ParquetStores
using Test
using Parquet2

@testset "ParquetStores.jl" begin
    ps = ParquetStore(joinpath(pwd(), "data"))  # running inside test directory
    #ps = ParquetStore(joinpath(homedir(), "data", "parquet"))

    @test libraries(ps) == Set(String["path.to.symbols"])

    lib = library(ps)["path.to.symbols"]

    ds = read(lib, "SYMBOL")

    @test typeof(ds) <: Parquet2.Dataset

    # using DataFrames, TableOperations
    # df = ds |> TableOperations.select(:time, :open, :high, :low, :close, :volume) |> DataFrame

    # using TimeSeries, TableOperations
    # ds |> TableOperations.select(:time, :open, :high, :low, :close, :volume) |> t -> TimeArray(t, timestamp=:time)
end
