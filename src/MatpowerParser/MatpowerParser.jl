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
        id, names, basekv, ide, area, zone, owner, vm, va,
        nvhi, nvlo, evhi, evlo,
    )
end

function _load_generators(gen_dict::Dict{String, Any})
    ngens = length(gen_dict)

    id = InlineStrings.InlineString3["" for i in 1:ngens]
    bus = zeros(Int32, ngens)
    pg = zeros(Float64, ngens)
    qg = zeros(Float64, ngens)
    qt = zeros(Float64, ngens)
    qb = zeros(Float64, ngens)
    vs = zeros(Float64, ngens)
    ireg = zeros(Int32, ngens)
    mbase = zeros(Float64, ngens)
    zr = zeros(Float64, ngens)
    zx = ones(Float64, ngens)
    rt = zeros(Float64, ngens)
    xt = zeros(Float64, ngens)
    gtap = ones(Float64, ngens)
    stat = ones(Bool, ngens)
    rmpct = fill(100.0, ngens)
    pt = zeros(Float64, ngens)
    pb = zeros(Float64, ngens)
    o1 = zeros(Int16, ngens)

    for (_, gen) in gen_dict
        g = gen["index"]
        id[g] = "1"
        pg[g] = gen["pg"]
        qg[g] = gen["qg"]
        bus[g] = gen["gen_bus"]
        pt[g] = gen["pmax"]
        pb[g] = gen["pmin"]
        qt[g] = gen["qmax"]
        qb[g] = gen["qmin"]
        vs[g] = gen["vg"]
        mbase[g] = gen["mbase"]
    end

    return PowerFlowData.Generators(
        bus, id, pg, qg, qt, qb, vs, ireg, mbase,
        zr, zx, rt, xt, gtap, stat, rmpct, pt, pb, o1,
        zeros(Float64, ngens),
        zeros(Int16, ngens),
        zeros(Float64, ngens),
        zeros(Int16, ngens),
        zeros(Float64, ngens),
        zeros(Int16, ngens),
        zeros(Float64, ngens),
        zeros(Int8, ngens),
        zeros(Float64, ngens),
    )
end

function _load_demands(load_dict::Dict{String, Any})
    nloads = length(load_dict)

    id = InlineStrings.InlineString3["" for i in 1:nloads]
    bus = zeros(Int32, nloads)
    area = zeros(Int16, nloads)
    owner = zeros(Int16, nloads)
    zone = zeros(Int16, nloads)
    pl = zeros(Float64, nloads)
    ql = zeros(Float64, nloads)
    ip = zeros(Float64, nloads)
    iq = zeros(Float64, nloads)
    yp = zeros(Float64, nloads)
    yq = zeros(Float64, nloads)
    scale = ones(Bool, nloads)
    status = ones(Bool, nloads)
    intrpt = zeros(Bool, nloads)

    for (l, load) in load_dict
        i = load["index"]::Int
        id[i] = "1"
        bus[i] = load["load_bus"]
        pl[i] = load["pd"]
        ql[i] = load["qd"]
    end

    return PowerFlowData.Loads(
        bus, id, status, area, zone, pl, ql, ip, iq,
        yp, yq, owner, scale, intrpt,
    )
end

function _load_branches(branches_dict::Dict{String, Any})
    nbranches = length(branches_dict)

    ckt = InlineStrings.InlineString3["" for i in 1:nbranches]
    i = zeros(Int32, nbranches)
    j = zeros(Int32, nbranches)
    r = zeros(Float64, nbranches)
    x = zeros(Float64, nbranches)
    b = zeros(Float64, nbranches)
    rate_a = zeros(Float64, nbranches)
    rate_b = zeros(Float64, nbranches)
    rate_c = zeros(Float64, nbranches)
    gi = zeros(Float64, nbranches)
    bi = zeros(Float64, nbranches)
    gj = zeros(Float64, nbranches)
    bj = zeros(Float64, nbranches)
    st = ones(Bool, nbranches)
    met = ones(Int8, nbranches)
    len = zeros(Float64, nbranches)
    o1 = zeros(Int16, nbranches)

    for (_, branch) in branches_dict
        ℓ = branch["index"]::Int
        ckt[ℓ] = "BL"
        i[ℓ] = branch["f_bus"]
        j[ℓ] = branch["t_bus"]
        r[ℓ] = branch["br_r"]
        x[ℓ] = branch["br_x"]
        st[ℓ] = branch["br_status"]
        gi[ℓ] = branch["g_fr"]
        gj[ℓ] = branch["g_to"]
        bi[ℓ] = branch["b_fr"]
        bj[ℓ] = branch["b_to"]
        b[ℓ] = bi[ℓ] + bj[ℓ]
        rate_a[ℓ] = get(branch, "rate_a", 0.0)
        rate_b[ℓ] = get(branch, "rate_b", 0.0)
        rate_c[ℓ] = get(branch, "rate_c", 0.0)
    end

    return PowerFlowData.Branches33(
        i, j, ckt, r, x, b, rate_a, rate_b, rate_c,
        gi, bi, gj, bj, st, met, len, o1,
        zeros(Float64, nbranches),
        zeros(Int16, nbranches),
        zeros(Float64, nbranches),
        zeros(Int16, nbranches),
        zeros(Float64, nbranches),
        zeros(Int16, nbranches),
        zeros(Float64, nbranches),
    )
end

function _load_shunt(shunt_dict::Dict{String, Any})
    nshunts = length(shunt_dict)
    i = zeros(Int32, nshunts)
    id = InlineStrings.InlineString3["" for i in 1:nshunts]
    status = ones(Bool, nshunts)
    gl = zeros(Float64, nshunts)
    bl = zeros(Float64, nshunts)

    for (_, sh) in shunt_dict
        k = sh["index"]::Int
        id[k] = "1"
        i[k] = sh["shunt_bus"]
        status[k] = sh["status"]
        gl[k] = sh["gs"]
        bl[k] = sh["bs"]
    end

    return PowerFlowData.FixedShunts(
        i, id, status, gl, bl,
    )
end

function PowerFlowData.Network(data::Dict{String, Any})
    return PowerFlowData.Network(
        33,
        PowerFlowData.CaseID(),
        _load_bus(data["bus"]),
        _load_demands(data["load"]),
        _load_shunt(data["shunt"]),
        _load_generators(data["gen"]),
        _load_branches(data["branch"]),
        PowerFlowData.Transformers(),
        PowerFlowData.AreaInterchanges(),
        PowerFlowData.TwoTerminalDCLines33(),
        PowerFlowData.VSCDCLines(),
        PowerFlowData.SwitchedShunts33(),
        PowerFlowData.ImpedanceCorrections(),
        PowerFlowData.MultiTerminalDCLines(),
        PowerFlowData.MultiSectionLineGroups33(),
        PowerFlowData.Zones(),
        PowerFlowData.InterAreaTransfers(),
        PowerFlowData.Owners(),
        PowerFlowData.FACTSDevices33(),
    )
end

end
