module PowerParsers

import PowerFlowData


include("MatpowerParser/MatpowerParser.jl")

#=
    MATPOWER
=#

function _parse_matpower(datafile::String)
    return MatpowerParser.parse_network(datafile)
end

#=
    PSSE
=#

function _parse_psse(datafile::String)
    return PowerFlowData.parse_network(datafile)
end

function power_parse(datafile::String)
    if endswith(datafile, ".raw")
        return _parse_psse(datafile)
    elseif endswith(datafile, ".raw")
        return _parse_matpower(datafile)
    else
        error("Supported extensions are `.raw` (PSSE) and `.m` (MATPOWER)")
    end
end

end # module
