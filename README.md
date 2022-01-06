# PowerParsers.jl

A generic package to parse power system files.

Formats supported:
- PSSE (with [PowerFlowData.jl](https://github.com/nickrobinson251/PowerFlowData.jl/))
- MATPOWER (wrap the parsers implemented in [PowerModels.jl](https://github.com/lanl-ansi/PowerModels.jl))

Usage:
```julia
using PowerParsers
data = PowerParsers.power_parse("case9.m")

```


