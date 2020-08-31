using InverseCDFDistributions
using Documenter

makedocs(;
    modules=[InverseCDFDistributions],
    authors="John Best <jkbest@gmail.com> and contributors",
    repo="https://github.com/jkbest2/InverseCDFDistributions.jl/blob/{commit}{path}#L{line}",
    sitename="InverseCDFDistributions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jkbest2.github.io/InverseCDFDistributions.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jkbest2/InverseCDFDistributions.jl",
)
