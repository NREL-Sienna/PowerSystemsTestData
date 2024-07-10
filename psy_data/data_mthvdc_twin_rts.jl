using PowerSystems

### Add DC Buses ###
dcbuses = Vector{DCBus}()

# 7T DC Buses
T7_numbers_150kV = [701, 702, 703]
T7_numbers_300kV = [704, 705, 706, 707]
for number in T7_numbers_150kV
    dcbus = DCBus(;
        number = number,
        name = string(number),
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 150.0,
    )
    push!(dcbuses, dcbus)
end
for number in T7_numbers_300kV
    dcbus = DCBus(;
        number = number,
        name = string(number),
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 300.0,
    )
    push!(dcbuses, dcbus)
end

T9_numbers_300kV = 901:1:909
for number in T9_numbers_300kV
    dcbus = DCBus(;
        number = number,
        name = string(number),
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 300.0,
    )
    push!(dcbuses, dcbus)
end

### Add DC Lines ###
dclines = Vector{TModelHVDCLine}()
limit = 1.0 # 100 MVA

#7T Lines
T7_bus_arcs = [
    ("701", "703"),
    ("702", "703"),
    ("704", "705"),
    ("704", "706"),
    ("704", "707"),
    ("705", "707"),
    ("706", "707"),
]
T7_r = [0.0352, 0.0352, 0.1242, 0.1242, 0.1242, 0.1242, 0.0248]

for (ix, bus_tuple) in enumerate(T7_bus_arcs)
    ix_bus_from = findfirst(x-> x.name == bus_tuple[1], dcbuses)
    ix_bus_to = findfirst(x-> x.name == bus_tuple[2], dcbuses)
    bus_from = dcbuses[ix_bus_from]
    bus_to = dcbuses[ix_bus_to]
    dcline = TModelHVDCLine(;
        name = "$(bus_from.name)_$(bus_to.name)",
        available = true,
        active_power_flow = 0.0,
        arc = Arc(bus_from, bus_to),
        r = T7_r[ix],
        l = 0.0,
        c = 0.0,
        active_power_limits_from = (min = 0.0, max = limit),
        active_power_limits_to = (min = 0.0, max = limit),
    )
    push!(dclines, dcline)
end

#9T Lines
T9_bus_arcs = [
    ("901", "903"),
    ("901", "904"),
    ("902", "903"),
    ("902", "906"),
    ("902", "909"),
    ("903", "905"),
    ("904", "905"),
    ("904", "907"),
    ("905", "907"),
    ("906", "907"),
    ("906", "908"),
    ("908", "909"),
]

T9_r = [
    0.0352,
    0.0828,
    0.0352,
    0.0828,
    0.0828,
    0.1656,
    0.1242,
    0.1242,
    0.1242,
    0.0248,
    0.0828,
    0.0828,
]

for (ix, bus_tuple) in enumerate(T9_bus_arcs)
    ix_bus_from = findfirst(x-> x.name == bus_tuple[1], dcbuses)
    ix_bus_to = findfirst(x-> x.name == bus_tuple[2], dcbuses)
    bus_from = dcbuses[ix_bus_from]
    bus_to = dcbuses[ix_bus_to]
    dcline = TModelHVDCLine(;
        name = "$(bus_from.name)_$(bus_to.name)",
        available = true,
        active_power_flow = 0.0,
        arc = Arc(bus_from, bus_to),
        r = T9_r[ix],
        l = 0.0,
        c = 0.0,
        active_power_limits_from = (min = 0.0, max = limit),
        active_power_limits_to = (min = 0.0, max = limit),
    )
    push!(dclines, dcline)
end

### Add IPCs ###

# Base Data #
S_base = 100 # MVA
V_base = [150, 150, 150, 300, 300, 300, 300] # kV
Z_base = V_base .^ 2 / S_base

# Converter Loss Data
a_pu = [1.103, 1.103, 2.206, 1.103, 2.206, 1.103, 2.206] / S_base
b_pu = [0.887, 0.887, 0.887, 1.8, 1.8, 1.8, 1.8] ./ V_base
c_pu =
    0.5 * [
        2.885 + 4.371,
        2.885 + 4.371,
        1.442 + 2.185,
        5.94 + 9.0,
        11.88 + 18.0,
        5.94 + 9.0,
        11.88 + 18.0,
    ] ./ Z_base

# P Limit in pu
P_limit_7T = [1.0, 1.0, 2.0, 2.0, 1.0, 2.0, 1.0]

# Same data for all converters in 9T: Equal to the DC6 converter
a_pu_9T = a_pu[6]
b_pu_9T = b_pu[6]
c_pu_9T = c_pu[6]
P_limit_9T = 2.0

# There are 16 IPCs to connect
# For 7T we will use:
# 701 with 107
# 702 with 10204 (Twin)
# 703 with 10301 (Twin)
# 704 with 113
# 705 with 123
# 706 with 10215 (Twin)
# 707 with 10217 (Twin)

# For 9T we will use:
# 901 with 107
# 902 with 10204 (Twin)
# 903 with 10301 (Twin)
# 904 with 104
# 905 with 118
# 906 with 10215 (Twin)
# 907 with 10217 (Twin)
# 908 with 10219 (Twin)
# 909 with 10206 (Twin)

# For 7T system
bus_arcs_7T = [
    (701, 107),
    (702, 10204),
    (703, 10301),
    (704, 113),
    (705, 123),
    (706, 10215),
    (707, 10217),
]

bus_arcs_9T = [
    (901, 107),
    (902, 10204),
    (903, 10301),
    (904, 104),
    (905, 118),
    (906, 10215),
    (907, 10217),
    (908, 10219),
    (909, 10206),
]