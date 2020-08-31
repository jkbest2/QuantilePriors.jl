module QuantilePriors

using ApproxFun
using Statistics

import Distributions: quantile
import Statistics: mean

export QuantilePrior

const S = Chebyshev(0..1)
const QP_INT = Integral(S)

struct QuantilePrior{T}
    f::T

    function QuantilePrior{T}(f::T) where T<:Fun
        domain(f) == 0..1 || throw(DomainError("Domain must be [0, 1]"))
        ismonotone(f) || throw("Not monotone; specify additional quantiles")
        new(f)
    end
end

function QuantilePrior(p, q)
    V = vandermonde(p)
    f = Fun(S, V \ q)
    QuantilePrior(f)
end

function vandermonde(p)
    n = length(p)
    V = Array{Float64}(undef, n, n)
    for k in 1:n
        V[:, k] = Fun(S, [zeros(k - 1); 1]).(p)
    end
    V
end

function ismonotone(f::Fun, x = range(0, 1, length = 1025))
    df = f'.(x)
    all(df .> 0)
end

Statistics.quantile(qp::QuantilePrior, p) = qp(p)
Statistics.mean(qp::QuantilePrior) = (QP_INT * qp.f)(1)

end
