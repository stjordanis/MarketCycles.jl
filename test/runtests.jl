using MarketCycles
using CSV

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

######################################################################
# Validate against John Ehlers Original TradeStation Easylanguage code
######################################################################

# 3-3 SuperSmoother Test
@testset "Ehlers" begin
    @testset "3-3 SuperSmoother" begin
        filename = joinpath(dirname(@__FILE__), "test_3-3_Supersmoother.csv")
        test = CSV.read( filename)
        close = Float64.(test[:Close])
        super_smoother_benchmark = Float64.(test[:Ten_Period_Supersmoother])
        Super_Smoother = SuperSmoother(close,n=10)
        Super_Smoother = round.(Super_Smoother,2) # round same as tradestation output
        valid = ifelse.(Super_Smoother .== super_smoother_benchmark,1,0)
        valid = valid[28:length(valid)] # remove indicator lead in period
        @test sum(valid) == length(valid)
    end

    @testset "4-1 Decycler" begin
        filename = joinpath(dirname(@__FILE__), "test_4-1_Decycler.csv")
        test = CSV.read( filename)
        decycler_benchmark = Float64.(test[:Sixty_Period_Decycler])
        decycler = Decycler(close, n=60)
        decycler = round.(decycler,2) # round same as tradestation output
        valid = ifelse.(decycler .== decycler_benchmark,1,0)
        @test sum(valid) == length(valid)
    end

    #=
    @testset "4-2 - Decycle Oscillator" begin
        filename = joinpath(dirname(@__FILE__), "test_4-2_Decycle_Oscillator.csv")
        test = CSV.read( filename)
        decycler_osc_benchmark = Float64.(test[:thirty_sixty_decycle_osc])
        decycler_osc = Decycle_OSC(close, n1=30,n2=60)
        decycler_osc = round.(decycler,2) # round same as tradestation output
        valid = ifelse.(decycler_osc .== decycler_osc_benchmark,1,0)
        valid
        @test sum(valid) == length(valid)
    end
    =#
end
