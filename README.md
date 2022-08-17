# PowerParsers.jl

PowerParsers is a subset of the package [PowerModels.jl](https://github.com/lanl-ansi/PowerModels.jl),
porting the MATLAB and PSSE parsers in a standalone library.

The package is designed to keep the dependencies minimal so as
to ease long term maintenance.


## Usage

```julia
# Import PSSE file as a dictionnary
data = PowerParsers.parse_file("data/case14.raw")

# Import MATPOWER file as a dictionnary
data = PowerParsers.parse_file("data/case14.m")

```

