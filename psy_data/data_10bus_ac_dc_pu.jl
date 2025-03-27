using TimeSeries
using Dates
using PowerSystems
const PSY = PowerSystems

## Buses ##
nodes10() = [
    ACBus(1, "nodeA", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(2, "nodeB", "PQ", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(3, "nodeC", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(4, "nodeD", "REF", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(5, "nodeE", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(6, "nodeA2", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(7, "nodeB2", "PQ", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(8, "nodeC2", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(9, "nodeD2", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(10, "nodeE2", "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
];

nodes10_dc() = [
    DCBus(1, "nodeC_DC", 1.0, (min = 0.9, max = 1.05), 500, nothing, nothing)
    DCBus(2, "nodeD_DC", 1.0, (min = 0.9, max = 1.05), 500, nothing, nothing)
    DCBus(3, "nodeC2_DC", 1.0, (min = 0.9, max = 1.05), 500, nothing, nothing)
    DCBus(4, "nodeD2_DC", 1.0, (min = 0.9, max = 1.05), 500, nothing, nothing)
]

## Branches ##

branches10_ac(nodes10) = [
    Line(
        "nodeA-nodeB",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[1], to = nodes10[2]),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeA-nodeD",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[1], to = nodes10[4]),
        0.00304,
        0.0304,
        (from = 0.00329, to = 0.00329),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeA-nodeE",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[1], to = nodes10[5]),
        0.00064,
        0.0064,
        (from = 0.01563, to = 0.01563),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeB-nodeC",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[2], to = nodes10[3]),
        0.00108,
        0.0108,
        (from = 0.00926, to = 0.00926),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeC-nodeD",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[3], to = nodes10[4]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeD-nodeE",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[4], to = nodes10[5]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeA2-nodeB2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[6], to = nodes10[7]),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeA2-nodeD2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[6], to = nodes10[9]),
        0.00304,
        0.0304,
        (from = 0.00329, to = 0.00329),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeA2-nodeE2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[6], to = nodes10[10]),
        0.00064,
        0.0064,
        (from = 0.01563, to = 0.01563),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeB2-nodeC2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[7], to = nodes10[8]),
        0.00108,
        0.0108,
        (from = 0.00926, to = 0.00926),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeC2-nodeD2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[8], to = nodes10[9]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        7.96, # max for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "nodeD2-nodeE2",
        true,
        0.0,
        0.0,
        Arc(from = nodes10[9], to = nodes10[10]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
]

branches10_dc(nodes10_dc) = [
    TModelHVDCLine(
        name = "nodeC_DC-nodeC2_DC",
        available = true,
        active_power_flow = 0.0,
        arc = Arc(from = nodes10_dc[1], to = nodes10_dc[3]),
        r = 0.01,
        l = 0.01,
        c = 0.0,
        active_power_limits_from=(min=-10.0, max=10.0),
        active_power_limits_to=(min=-10.0, max=10.0),
    ),
    TModelHVDCLine(
        name = "nodeD_DC-nodeD2_DC",
        available = true,
        active_power_flow = 0.0,
        arc = Arc(from = nodes10_dc[2], to = nodes10_dc[4]),
        r = 0.01,
        l = 0.01,
        c = 0.0,
        active_power_limits_from=(min=-10.0, max=10.0),
        active_power_limits_to=(min=-10.0, max=10.0),
    ),
    TModelHVDCLine(
        name = "nodeC_DC-nodeD2_DC",
        available = true,
        active_power_flow = 0.0,
        arc = Arc(from = nodes10_dc[1], to = nodes10_dc[4]),
        r = 0.01,
        l = 0.01,
        c = 0.0,
        active_power_limits_from=(min=-10.0, max=10.0),
        active_power_limits_to=(min=-10.0, max=10.0),
    ),
]

## Gens ##

thermal_generators10(nodes10) = [
    ThermalStandard(;
        name = "Alta",
        available = true,
        status = true,
        bus = nodes10[1],
        active_power = 0.40,
        reactive_power = 0.010,
        rating = 0.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 0.40),
        reactive_power_limits = (min = -0.30, max = 0.30),
        ramp_limits = nothing,
        time_limits = nothing,
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 14.0, 0.0)),
            0.0,
            4.0,
            2.0,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Park City",
        available = true,
        status = true,
        bus = nodes10[1],
        active_power = 1.70,
        reactive_power = 0.20,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 15.0, 0.0)),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Solitude",
        available = true,
        status = true,
        bus = nodes10[3],
        active_power = 5.2,
        reactive_power = 1.00,
        rating = 5.2,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 5.20),
        reactive_power_limits = (min = -3.90, max = 3.90),
        ramp_limits = (up = 0.012 * 5.2, down = 0.012 * 5.2),
        time_limits = (up = 3.0, down = 2.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 30.0, 0.0)),
            0.0,
            3.0,
            1.5,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Sundance",
        available = true,
        status = true,
        bus = nodes10[4],
        active_power = 2.0,
        reactive_power = 0.40,
        rating = 2.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 2.0),
        reactive_power_limits = (min = -1.5, max = 1.5),
        ramp_limits = (up = 0.015 * 2.5, down = 0.015 * 2.5),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 40.0, 0.0)),
            0.0,
            4.0,
            2.0,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Brighton",
        available = true,
        status = true,
        bus = nodes10[5],
        active_power = 6.0,
        reactive_power = 1.50,
        rating = 0.75,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 6.0),
        reactive_power_limits = (min = -4.50, max = 4.50),
        ramp_limits = (up = 0.015 * 7.5, down = 0.015 * 7.5),
        time_limits = (up = 5.0, down = 3.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 10.0, 0.0)),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(;
        name = "Alta-2",
        available = true,
        status = true,
        bus = nodes10[6],
        active_power = 0.40,
        reactive_power = 0.010,
        rating = 0.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 0.40),
        reactive_power_limits = (min = -0.30, max = 0.30),
        ramp_limits = nothing,
        time_limits = nothing,
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 14.0, 0.0)),
            0.0,
            4.0,
            2.0,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Park City-2",
        available = true,
        status = true,
        bus = nodes10[6],
        active_power = 1.70,
        reactive_power = 0.20,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 15.0, 0.0)),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Solitude-2",
        available = true,
        status = true,
        bus = nodes10[8],
        active_power = 5.2,
        reactive_power = 1.00,
        rating = 5.2,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 5.20),
        reactive_power_limits = (min = -3.90, max = 3.90),
        ramp_limits = (up = 0.012 * 5.2, down = 0.012 * 5.2),
        time_limits = (up = 3.0, down = 2.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 30.0, 0.0)),
            0.0,
            3.0,
            1.5,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Sundance-2",
        available = true,
        status = true,
        bus = nodes10[9],
        active_power = 2.0,
        reactive_power = 0.40,
        rating = 2.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 2.0),
        reactive_power_limits = (min = -1.5, max = 1.5),
        ramp_limits = (up = 0.015 * 2.5, down = 0.015 * 2.5),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 40.0, 0.0)),
            0.0,
            4.0,
            2.0,
        ),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Brighton-2",
        available = true,
        status = true,
        bus = nodes10[10],
        active_power = 6.0,
        reactive_power = 1.50,
        rating = 0.75,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 6.0),
        reactive_power_limits = (min = -4.50, max = 4.50),
        ramp_limits = (up = 0.015 * 7.5, down = 0.015 * 7.5),
        time_limits = (up = 5.0, down = 3.0),
        operation_cost = ThermalGenerationCost(
            CostCurve(QuadraticCurve(0.0, 10.0, 0.0)),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
];

## Loads ##

loads10(nodes10) = [
    PowerLoad(
        "Load-nodeB",
        true,
        nodes10[2],
        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Load-nodeC",
        true,
        nodes10[3],
        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Load-nodeD",
        true,
        nodes10[4],
        4.0,
        1.3147,
        100.0,
        4.0,
        1.3147,
    ),
    PowerLoad(
        "Load-nodeB2",
        true,
        nodes10[7],
        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Load-nodeC2",
        true,
        nodes10[8],
        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Load-nodeD2",
        true,
        nodes10[9],
        4.0,
        1.3147,
        100.0,
        4.0,
        1.3147,
    ),
];

## Load Timeseries ##

loadbusB_ts_DA = [
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

loadbusC_ts_DA = [
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

loadbusD_ts_DA = [
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

ipcs_10bus(nodes, nodesdc) = [
    InterconnectingConverter(
        name = "IPC-nodeC",
        available = true,
        bus = nodes[3],
        dc_bus = nodesdc[1],
        active_power = 0.0,
        rating = 2.0,
        active_power_limits = (min = -1.0, max = 1.0),
        dc_current = 0.0,
        dc_current_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
    ),
    InterconnectingConverter(
        name = "IPC-nodeD",
        available = true,
        bus = nodes[4],
        dc_bus = nodesdc[2],
        active_power = 0.0,
        rating = 2.0,
        active_power_limits = (min = -1.0, max = 1.0),
        dc_current = 0.0,
        dc_current_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
    ),
    InterconnectingConverter(
        name = "IPC-nodeC2",
        available = true,
        bus = nodes[8],
        dc_bus = nodesdc[3],
        active_power = 0.0,
        rating = 2.0,
        active_power_limits = (min = -1.0, max = 1.0),
        dc_current = 0.0,
        dc_current_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
    ),
    InterconnectingConverter(
        name = "IPC-nodeD2",
        available = true,
        bus = nodes[9],
        dc_bus = nodesdc[4],
        active_power = 0.0,
        rating = 2.0,
        active_power_limits = (min = -1.0, max = 1.0),
        dc_current = 0.0,
        dc_current_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
    ),
]
