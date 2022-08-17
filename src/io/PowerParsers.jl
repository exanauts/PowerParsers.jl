module PowerParsers

import PowerFlowData


include("MatpowerParser/MatpowerParser.jl")

#=
    MATPOWER
=#

function _parse_matpower(datafile::String)
    return MatpowerParser.parse_network(datafile)
end

end # module
