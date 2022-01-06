module MatpowerParser

import InlineStrings
import Memento
import PowerFlowData

const _LOGGER = Memento.getlogger(@__MODULE__)

include("common.jl")
include("matlab.jl")
include("matpower.jl")

parse_network = parse_matpower

function _load_bus(buses_dict::Dict{String, Any})
    nbuses = length(buses_dict)

    id = zeros(Int32, nbuses)
    names = InlineStrings.InlineString15["" for i in 1:nbuses]
    basekv = zeros(Float64, nbuses)
    ide = zeros(Int8, nbuses)
    area = zeros(Int16, nbuses)
    zone = zeros(Int16, nbuses)
    owner = zeros(Int16, nbuses)
    vm = zeros(Float64, nbuses)
    va = zeros(Float64, nbuses)
    nvhi = zeros(Float64, nbuses)
    nvlo = zeros(Float64, nbuses)
    evlo = zeros(Float64, nbuses)
    evhi = zeros(Float64, nbuses)

    for (b, bus) in buses_dict
        i = bus["bus_i"]::Int
        id[i] = i
        names[i] = bus["name"]
        basekv[i] = bus["base_kv"]::Float64
        ide[i] = bus["bus_type"]::Int
        area[i] = bus["area"]::Int
        zone[i] = bus["zone"]::Int
        owner[i] = 1
        vm[i] = bus["vm"]::Float64
        va[i] = bus["va"]::Float64
        nvhi[i] = bus["vmax"]::Float64
        nvlo[i] = bus["vmin"]::Float64
        evhi[i] = bus["vmax"]::Float64
        evlo[i] = bus["vmin"]::Float64
    end

    return PowerFlowData.Buses33(
        id,
        names,
        basekv,
        ide,
        area,
        zone,
        owner,
        vm,
        va,
        nvhi,
        nvlo,
        evhi,
        evlo,
    )
end

function _load_gen(gen_dict::Dict{String, Any})

end

function PowerFlowData.Network(data::Dict{String, Any})

end

end
