using QuantilePriors
using Test

@testset "QuantilePriors.jl" begin
    p = [0.1, 0.25, 0.5, 0.75, 0.9]
    q = [-1.0, -0.5, 0.1, 1.0, 2.0]
    qp1 = QuantilePrior(p, q)
    # Test interpolation of specified locations
    @test all(quantile.(Ref(qp1), p) .≈ q)
    bigp = BigFloat.(p)
    bigq = BigFloat.(q)
    bigqp = QuantilePrior(bigp, bigq)
    @test all(quantile.(Ref(bigqp), bigp) .≈ bigq)
    symq = range(0, 10, length = 5)
    symqp = QuantilePrior(p, symq)
    @test_broken mean(symqp) ≈ symq[3]
end
