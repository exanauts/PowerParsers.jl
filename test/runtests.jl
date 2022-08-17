
using Test
using PowerParsers

const SRC_DIRECTORY = joinpath(@__DIR__, "..", "data")

PowerParsers.silence()

@testset "Parse case14 ($file)" for file in [
    "case14.raw",
    "case14.m",
]
    datafile = joinpath(SRC_DIRECTORY, file)
    data = PowerParsers.parse_file(datafile)

    @test isa(data, Dict{String, Any})

    # Test consistency
    @test data["baseMVA"] == 100.0
    @test length(data["bus"]) == 14
    @test length(data["gen"]) == 5
    @test length(data["branch"]) == 20
    @test length(data["shunt"]) == 1
    @test length(data["load"]) == 11
end

