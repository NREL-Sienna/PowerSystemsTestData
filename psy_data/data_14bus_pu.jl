using TimeSeries
using Dates
using PowerSystems

dates = collect(
    DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime(
        "1/1/2024  23:00:00",
        "d/m/y  H:M:S",
    ),
)

nodes14() = [
    ACBus(1, "Bus 1", true, "REF", 0.0, 1.06, (min = 0.94, max = 1.06), 69, nothing, nothing),
    ACBus(
        2,
        "Bus 2",
        true,
        "PV",
        -0.08691739674931762,
        1.045,
        (min = 0.94, max = 1.06),
        69,
        nothing,
        nothing,
    ),
    ACBus(
        3,
        "Bus 3",
        true,
        "PV",
        -0.22200588085367873,
        1.01,
        (min = 0.94, max = 1.06),
        69,
        nothing,
        nothing,
    ),
    ACBus(
        4,
        "Bus 4",
        true,
        "PQ",
        -0.18029251173101424,
        1.019,
        (min = 0.94, max = 1.06),
        69,
        nothing,
        nothing,
    ),
    ACBus(
        5,
        "Bus 5",
        true,
        "PQ",
        -0.15323990832510212,
        1.02,
        (min = 0.94, max = 1.06),
        69,
        nothing,
        nothing,
    ),
    ACBus(
        6,
        "Bus 6",
        true,
        "PV",
        -0.24818581963359368,
        1.07,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        7,
        "Bus 7",
        true,
        "PQ",
        -0.23335052099164186,
        1.062,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        8,
        "Bus 8",
        true,
        "PV",
        -0.2331759880664424,
        1.09,
        (min = 0.94, max = 1.06),
        18,
        nothing,
        nothing,
    ),
    ACBus(
        9,
        "Bus 9",
        true,
        "PQ",
        -0.2607521902479528,
        1.056,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        10,
        "Bus 10",
        true,
        "PQ",
        -0.26354471705114374,
        1.051,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        11,
        "Bus 11",
        true,
        "PQ",
        -0.2581341963699613,
        1.057,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        12,
        "Bus 12",
        true,
        "PQ",
        -0.2630211182755455,
        1.055,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        13,
        "Bus 13",
        true,
        "PQ",
        -0.2645919146023404,
        1.05,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
    ACBus(
        14,
        "Bus 14",
        true,
        "PQ",
        -0.27995081201989047,
        1.036,
        (min = 0.94, max = 1.06),
        13.8,
        nothing,
        nothing,
    ),
]
branches14_dc(nodes14) = [
    Line(
        "Line1",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[1], to = nodes14[2]),
        0.01938,
        0.05917,
        (from = 0.0264, to = 0.0264),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line2",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[1], to = nodes14[5]),
        0.05403,
        0.22304,
        (from = 0.0246, to = 0.0246),
        1.14, # 69kV limit
        1.04,
    ),
    TwoTerminalGenericHVDCLine(
        "DCLine3",
        true,
        0.0,
        Arc(from = nodes14[2], to = nodes14[3]),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        LinearCurve(0.001, 0.01),
    ),
    TwoTerminalGenericHVDCLine(
        "DCLine4",
        true,
        0.0,
        Arc(from = nodes14[2], to = nodes14[4]),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        (min = -600.0, max = 600),
        LinearCurve(0.001, 0.01),
    ),
    #Line("Line3",  true, 0.0, 0.0, Arc(from=nodes14[2],to=nodes14[3]),   0.04699, 0.19797, (from=0.0219, to=0.0219), 5.522, 1.04),
    #Line("Line4",  true, 0.0, 0.0, Arc(from=nodes14[2],to=nodes14[4]),   0.05811, 0.17632, (from=0.017,  to=0.017), 6.052, 1.04),
    Line(
        "Line5",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[2], to = nodes14[5]),
        0.05695,
        0.17388,
        (from = 0.0173, to = 0.0173),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line6",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[3], to = nodes14[4]),
        0.06701,
        0.17103,
        (from = 0.0064, to = 0.0064),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line7",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[4], to = nodes14[5]),
        0.01335,
        0.04211,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    TapTransformer(
        "Trans3",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[4], to = nodes14[7]),
        0.0,
        0.20912,
        0.0,
        0,
        0.978,
        20.0,
        100.0,
    ),
    TapTransformer(
        "Trans1",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[4], to = nodes14[9]),
        0.0,
        0.55618,
        0.0,
        0,
        0.969,
        20.0,
        100.0,
    ),
    TapTransformer(
        "Trans2",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[5], to = nodes14[6]),
        0.0,
        0.25202,
        0.0,
        0,
        0.932,
        20.0,
        100.0,
    ),
    Line(
        "Line8",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[11]),
        0.09498,
        0.19890,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line9",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[12]),
        0.12291,
        0.25581,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line10",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[13]),
        0.06615,
        0.13027,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Transformer2W(
        "Trans4",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[7], to = nodes14[8]),
        0.0,
        0.17615,
        0.0,
        0,
        20.0,
        100.0,
    ),
    Line(
        "Line16",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[7], to = nodes14[9]),
        0.0,
        0.11001,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line11",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[9], to = nodes14[10]),
        0.03181,
        0.08450,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line12",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[9], to = nodes14[14]),
        0.12711,
        0.27038,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line13",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[10], to = nodes14[11]),
        0.08205,
        0.19207,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line14",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[12], to = nodes14[13]),
        0.22092,
        0.19988,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line15",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[13], to = nodes14[14]),
        0.17093,
        0.34802,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
]

branches14(nodes14) = [
    Line(
        "Line1",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[1], to = nodes14[2]),
        0.01938,
        0.05917,
        (from = 0.0264, to = 0.0264),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line2",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[1], to = nodes14[5]),
        0.05403,
        0.22304,
        (from = 0.0246, to = 0.0246),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line3",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[2], to = nodes14[3]),
        0.04699,
        0.19797,
        (from = 0.0219, to = 0.0219),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line4",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[2], to = nodes14[4]),
        0.05811,
        0.17632,
        (from = 0.017, to = 0.017),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line5",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[2], to = nodes14[5]),
        0.05695,
        0.17388,
        (from = 0.0173, to = 0.0173),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line6",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[3], to = nodes14[4]),
        0.06701,
        0.17103,
        (from = 0.0064, to = 0.0064),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line7",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[4], to = nodes14[5]),
        0.01335,
        0.04211,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    TapTransformer(
        "Trans3", # name
        true, # available
        0.0, # active power flow
        0.0, # reactive power flow
        Arc(from = nodes14[4], to = nodes14[7]),
        0.0, # r
        0.20912, # x
        0.0, # primary shunt
        0, # winding group number
        0.978, # tap
        20.0, # rating
        100.0, # base power
    ),
    TapTransformer(
        "Trans1",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[4], to = nodes14[9]),
        0.0,
        0.55618,
        0.0,
        0,
        0.969,
        20.0,
        100.0,
    ),
    TapTransformer(
        "Trans2",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[5], to = nodes14[6]),
        0.0,
        0.25202,
        0.0,
        0,
        0.932,
        20.0,
        100.0,
    ),
    Line(
        "Line8",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[11]),
        0.09498,
        0.19890,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line9",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[12]),
        0.12291,
        0.25581,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line10",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[6], to = nodes14[13]),
        0.06615,
        0.13027,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Transformer2W(
        "Trans4",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[7], to = nodes14[8]),
        0.0,
        0.17615,
        0.0,
        0,
        20.0,
        100.0,
    ),
    Line(
        "Line16",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[7], to = nodes14[9]),
        0.0,
        0.11001,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line11",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[9], to = nodes14[10]),
        0.03181,
        0.08450,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line12",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[9], to = nodes14[14]),
        0.12711,
        0.27038,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line13",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[10], to = nodes14[11]),
        0.08205,
        0.19207,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line14",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[12], to = nodes14[13]),
        0.22092,
        0.19988,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
    Line(
        "Line15",
        true,
        0.0,
        0.0,
        Arc(from = nodes14[13], to = nodes14[14]),
        0.17093,
        0.34802,
        (from = 0.0, to = 0.0),
        1.14, # 69kV limit
        1.04,
    ),
]

thermal_generators14(nodes14) = [
    ThermalStandard(
        name = "Bus1",
        available = true,
        status = true,
        bus = nodes14[1],
        active_power = 2.0,
        reactive_power = -0.169,
        rating = 2.324,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 3.332),
        reactive_power_limits = (min = 0.0, max = 0.1),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.0430292599, 20.0, 0.0)), 0.0, 0.0, 0.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Bus2",
        available = true,
        status = true,
        bus = nodes14[2],
        active_power = 0.40,
        reactive_power = 0.42,
        rating = 1.4,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.40),
        reactive_power_limits = (min = -0.4, max = 0.5),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.25, 20.0, 0.0)), 0.0, 0.0, 0.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Bus3",
        available = true,
        status = true,
        bus = nodes14[3],
        active_power = 0.0,
        reactive_power = 0.23,
        rating = 1.0,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.0),
        reactive_power_limits = (min = 0.0, max = 0.4),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.01, 40.0, 0.0)), 0.0, 0.0, 0.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Bus6",
        available = true,
        status = true,
        bus = nodes14[6],
        active_power = 0.0,
        reactive_power = 0.12,
        rating = 1.0,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.0),
        reactive_power_limits = (min = -0.06, max = 0.24),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.01, 40.0, 0.0)), 0.0, 0.0, 0.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Bus8",
        available = true,
        status = true,
        bus = nodes14[8],
        active_power = 0.0,
        reactive_power = 0.174,
        rating = 1.0,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.0),
        reactive_power_limits = (min = -0.06, max = 0.24),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.01, 40.0, 0.0)), 0.0, 0.0, 0.0),
        base_power = 100.0,
    ),
]

loadz1_ts = [
    0.792729978
    0.723201574
    0.710952098
    0.677672816
    0.668249175
    0.67166919
    0.687608809
    0.711821241
    0.756320618
    0.7984057
    0.827836527
    0.840362459
    0.84511032
    0.834592803
    0.822949221
    0.816941743
    0.824079963
    0.905735139
    0.989967048
    1
    0.991227765
    0.960842114
    0.921465115
    0.837001437
]

loadz2_ts = [
    0.831093782
    0.689863228
    0.666058513
    0.627033103
    0.624901388
    0.62858924
    0.650734211
    0.683424321
    0.750876413
    0.828347191
    0.884248576
    0.888523615
    0.87752169
    0.847534405
    0.8227661
    0.803809323
    0.813282799
    0.907575962
    0.98679848
    1
    0.990489904
    0.952520972
    0.906611479
    0.824307054
]

loadz3_ts = [
    0.871297342
    0.670489749
    0.642812243
    0.630092987
    0.652991383
    0.671971681
    0.716278493
    0.770885833
    0.810075243
    0.85562361
    0.892440566
    0.910660449
    0.922135467
    0.898416969
    0.879816542
    0.896390855
    0.978598576
    0.96523761
    1
    0.969626503
    0.901212601
    0.81894251
    0.771004923
    0.717847996
]

loads14(nodes14) = [
    PowerLoad("Bus2", true, nodes14[2], 0.217, 0.127, 100.0, 0.217, 0.127),
    PowerLoad("Bus3", true, nodes14[3], 0.942, 0.19, 100.0, 0.942, 0.19),
    PowerLoad("Bus4", true, nodes14[4], 0.478, -0.039, 100.0, 0.478, -0.039),
    PowerLoad("Bus5", true, nodes14[5], 0.076, 0.016, 100.0, 0.076, 0.016),
    PowerLoad("Bus6", true, nodes14[6], 0.112, 0.075, 100.0, 0.112, 0.075),
    PowerLoad("Bus9", true, nodes14[9], 0.295, 0.166, 100.0, 0.295, 0.166),
    PowerLoad("Bus10", true, nodes14[10], 0.09, 0.058, 100.0, 0.09, 0.058),
    PowerLoad("Bus11", true, nodes14[11], 0.035, 0.018, 100.0, 0.035, 0.018),
    PowerLoad("Bus12", true, nodes14[12], 0.061, 0.016, 100.0, 0.061, 0.016),
    PowerLoad("Bus13", true, nodes14[13], 0.135, 0.058, 100.0, 0.135, 0.058),
    PowerLoad("Bus14", true, nodes14[14], 0.149, 0.050, 100.0, 0.149, 0.050),
]

timeseries_DA14 = [
    TimeArray(dates, loadz1_ts),
    TimeArray(dates, loadz1_ts),
    TimeArray(dates, loadz3_ts),
    TimeArray(dates, loadz1_ts),
    TimeArray(dates, loadz2_ts),
    TimeArray(dates, loadz3_ts),
    TimeArray(dates, loadz2_ts),
    TimeArray(dates, loadz2_ts),
    TimeArray(dates, loadz2_ts),
    TimeArray(dates, loadz2_ts),
    TimeArray(dates, loadz2_ts),
];

battery14(nodes14) = [
    EnergyReservoirStorage(
        name = "Bat",
        prime_mover_type = PrimeMovers.BA,
        storage_technology_type = StorageTech.OTHER_CHEM,
        available = true,
        bus = nodes14[1],
        initial_energy = 5.0,
        state_of_charge_limits = (min = 5.0, max = 100.0),
        rating = 70,
        active_power = 10.0,
        input_active_power_limits = (min = 0.0, max = 50.0),
        output_active_power_limits = (min = 0.0, max = 50.0),
        reactive_power = 0.0,
        reactive_power_limits = (min = -50.0, max = 50.0),
        efficiency = (in = 0.80, out = 0.90),
        base_power = 100.0,
    ),
]
