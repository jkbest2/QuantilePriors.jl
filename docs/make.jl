using QuantilePriors
using Documenter

makedocs(;
    modules=[QuantilePriors],
    authors="John Best <jkbest@gmail.com> and contributors",
    repo="https://github.com/jkbest2/QuantilePriors.jl/blob/{commit}{path}#L{line}",
    sitename="QuantilePriors.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jkbest2.github.io/QuantilePriors.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jkbest2/QuantilePriors.jl",
)
