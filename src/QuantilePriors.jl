module QuantilePriors

using ApproxFun
using Statistics

export QuantilePrior,
    mean,
    quantile

"""
    const S = Chebyshev(0..1)

All functions in this package use a Chebyshev basis on the [0, 1] interval.
"""
const S = Chebyshev(0..1)
"""
    const QP_INT = Integral(S)

The integral operator for the Chebyshev basis on the [0, 1] interval. Used for
calculating the mean of a prior.
"""
const QP_INT = Integral(S)

"""
    QuantilePrior{T} where T<:Fun
    QuantilePrior(p, q)

A quantile (inverse CDF) function that can be used as a prior, inspired by [Ben
Goodrich's StanCon 2020 talk](https://youtu.be/_wfZSvasLFk).

Usually specified via a vector of probabilities `p` and corresponding quantiles
`q`. These are interpolated using Chebyshev polynomials from the ApproxFun
package. This must result in a monotone function to represent a valid
distribution (this is tested when the function is constructed).

This would be used in e.g. MCMC settings by sampling from [0, 1] and then using
`quantile` to recover a parameter value that can be used. In this case the
density function of the prior is not needed; it is included implicitly in the
posterior density due to the change of variables.

Note that the resulting prior has a compact support, which may or may not be a
problem.
"""
struct QuantilePrior{T}
    f::T

    function QuantilePrior(f::T) where T <: Fun
        domain(f) == 0..1 || throw(DomainError("Domain must be [0, 1]"))
        ismonotoneinc(f) || throw("Not monotone; specify additional quantiles")
        new{T}(f)
    end
end

function QuantilePrior(p, q)
    all(0 .≤ p .≤ 1) || throw(DomainError("All `p` must be in [0, 1]"))
    V = vandermonde(p)
    f = Fun(S, V \ q)
    QuantilePrior(f)
end

"""
    vandermonde(p)

Construct a Vandermonde matrix at grid locations `p`, as described in ApproxFun
FAQ.
"""
function vandermonde(p)
    T = eltype(p)
    # Following ApproxFun FAQ
    n = length(p)
    V = Array{T}(undef, n, n)
    for k in 1:n
        V[:, k] = Fun(S, [zeros(T, k - 1); 1]).(p)
    end
    V
end

"""
    ismonotoneinc(f::Fun, x)

Test that the derivatives of `f` at `x` are all positive.
"""
function ismonotoneinc(f::Fun, x=range(0, 1, length=1025))
    df = f'.(x)
    all(df .> 0)
end

# Needed for broadcasting
Statistics.quantile(qp::QuantilePrior, p) = qp.f(p)
# Statistics.mean(qp::QuantilePrior) = (QP_INT * qp.f)(1)
Statistics.mean(qp::QuantilePrior) = stop("Not implemented (correctly)")

end
