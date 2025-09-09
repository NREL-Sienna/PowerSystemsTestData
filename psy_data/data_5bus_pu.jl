using TimeSeries
using Dates
using Random
Random.seed!(123)
using PowerSystems
const PSY = PowerSystems

DayAhead = collect(
    DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime(
        "1/1/2024  23:00:00",
        "d/m/y  H:M:S",
    ),
)
#Dispatch_11am =  collect(DateTime("1/1/2024  0:11:00", "d/m/y  H:M:S"):Minute(15):DateTime("1/1/2024  12::00", "d/m/y  H:M:S"))

nodes5() = [
    ACBus(1, "nodeA", true, "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(2, "nodeB", true, "PQ", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(3, "nodeC", true, "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(4, "nodeD", true, "REF", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
    ACBus(5, "nodeE", true, "PV", 0, 1.0, (min = 0.9, max = 1.05), 230, nothing, nothing),
];

branches5_dc(nodes5) = [
    Line(
        "1",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[2]),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    TwoTerminalGenericHVDCLine(
        "DCL2",
        true,
        0.0,
        Arc(from = nodes5[1], to = nodes5[4]),
        (min = -3000.0, max = 3000.0),
        (min = -3000, max = 3000),
        (min = -3000.0, max = 3000.0),
        (min = -3000.0, max = 3000.0),
        LinearCurve(0.01),
    ),
    Line(
        "3",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[5]),
        0.00064,
        0.0064,
        (from = 0.01563, to = 0.01563),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "4",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[2], to = nodes5[3]),
        0.00108,
        0.0108,
        (from = 0.00926, to = 0.00926),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "5",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[3], to = nodes5[4]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "6",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[4], to = nodes5[5]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 00.00337),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
];

branches5(nodes5) = [
    Line(
        "1",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[2]),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "2",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[4]),
        0.00304,
        0.0304,
        (from = 0.00329, to = 0.00329),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "3",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[5]),
        0.00064,
        0.0064,
        (from = 0.01563, to = 0.01563),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "4",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[2], to = nodes5[3]),
        0.00108,
        0.0108,
        (from = 0.00926, to = 0.00926),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "5",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[3], to = nodes5[4]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "6",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[4], to = nodes5[5]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 00.00337),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
];

branches5_ml(nodes5) = [
    MonitoredLine(
        "1",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[2]),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        (from_to = 1.0, to_from = 1.0),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "2",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[4]),
        0.00304,
        0.0304,
        (from = 0.00329, to = 0.00329),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
    Line(
        "3",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[1], to = nodes5[5]),
        0.00064,
        0.0064,
        (from = 0.01563, to = 0.01563),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "4",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[2], to = nodes5[3]),
        0.00108,
        0.0108,
        (from = 0.00926, to = 0.00926),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "5",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[3], to = nodes5[4]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 0.00337),
        7.96,
        (min = -0.7, max = 0.7),
    ),
    Line(
        "6",
        true,
        0.0,
        0.0,
        Arc(from = nodes5[4], to = nodes5[5]),
        0.00297,
        0.0297,
        (from = 0.00337, to = 00.00337),
        3.29, # min for 230kV
        (min = -0.7, max = 0.7),
    ),
];

solar_ts_DA = [
    0
    0
    0
    0
    0
    0
    0
    0
    0
    0.351105684
    0.632536266
    0.99463925
    1
    0.944237283
    0.396681234
    0.366511428
    0.155125829
    0.040872694
    0
    0
    0
    0
    0
    0
]

wind_ts_DA = [
    0.985205412
    0.991791369
    0.997654144
    1
    0.998663733
    0.995497149
    0.992414567
    0.98252418
    0.957203427
    0.927650911
    0.907181989
    0.889095913
    0.848186718
    0.766813846
    0.654052531
    0.525336131
    0.396098004
    0.281771509
    0.197790004
    0.153241012
    0.131355854
    0.113688144
    0.099302656
    0.069569628
]

hydro_inflow_ts_DA = [
    0.314300
    0.386684
    0.228582
    0.226677
    0.222867
    0.129530
    0.144768
    0.365731
    0.207628
    0.622885
    0.670507
    0.676221
    0.668602
    0.407638
    0.321919
    0.369541
    0.287632
    0.449544
    0.630505
    0.731462
    0.777178
    0.712413
    0.780988
    0.190485
];

thermal_generators5(nodes5) = [
    ThermalStandard(;
        name = "Alta",
        available = true,
        status = true,
        bus = nodes5[1],
        active_power = 0.40,
        reactive_power = 0.010,
        rating = 0.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 0.40),
        reactive_power_limits = (min = -0.30, max = 0.30),
        ramp_limits = nothing,
        time_limits = nothing,
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(14.0)), 0.0, 4.0, 2.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Park City",
        available = true,
        status = true,
        bus = nodes5[1],
        active_power = 1.70,
        reactive_power = 0.20,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(15.0)), 0.0, 1.5, 0.75),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Solitude",
        available = true,
        status = true,
        bus = nodes5[3],
        active_power = 5.2,
        reactive_power = 1.00,
        rating = 5.2,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 5.20),
        reactive_power_limits = (min = -3.90, max = 3.90),
        ramp_limits = (up = 0.012 * 5.2, down = 0.012 * 5.2),
        time_limits = (up = 3.0, down = 2.0),
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(30.0)), 0.0, 3.0, 1.5),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Sundance",
        available = true,
        status = true,
        bus = nodes5[4],
        active_power = 2.0,
        reactive_power = 0.40,
        rating = 2.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 2.0),
        reactive_power_limits = (min = -1.5, max = 1.5),
        ramp_limits = (up = 0.015 * 2.5, down = 0.015 * 2.5),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(40.0)), 0.0, 4.0, 2.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Brighton",
        available = true,
        status = true,
        bus = nodes5[5],
        active_power = 6.0,
        reactive_power = 1.50,
        rating = 0.75,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 6.0),
        reactive_power_limits = (min = -4.50, max = 4.50),
        ramp_limits = (up = 0.015 * 7.5, down = 0.015 * 7.5),
        time_limits = (up = 5.0, down = 3.0),
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(10.0)), 0.0, 1.5, 0.75),
        base_power = 100.0,
    ),
];

thermal_generators5_pwl(nodes5) = [
    ThermalStandard(
        name = "Test PWL",
        available = true,
        status = true,
        bus = nodes5[1],
        active_power = 1.70,
        reactive_power = 0.20,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(CostCurve(PiecewisePointCurve([(50.0, 0.0), (80.0, 190.1), (120.0, 582.72), (170.0, 1094.1)])),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
];

thermal_generators5_pwl_nonconvex(nodes5) = [
    ThermalStandard(
        name = "Test PWL Nonconvex",
        available = true,
        status = true,
        bus = nodes5[1],
        active_power = 1.70,
        reactive_power = 0.20,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.0, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(CostCurve(PiecewisePointCurve([(50.0, 0.0), (80.0, 190.1), (120.0, 582.72), (170.0, 825.1)])),
            0.0,
            1.5,
            0.75,
        ),
        base_power = 100.0,
    ),
];

thermal_pglib_generators5(nodes5) = [
    ThermalMultiStart(
        "115_STEAM_1",
        true,
        true,
        nodes5[1],
        0.05,
        0.010,
        0.12,
        PrimeMovers.ST,
        ThermalFuels.COAL,
        (min = 0.05, max = 0.12),
        (min = -0.30, max = 0.30),
        (up = 0.002 * 0.12, down = 0.002 * 0.12),
        (startup = 0.05, shutdown = 0.05),
        (up = 4.0, down = 2.0),
        (hot = 2.0, warm = 4.0, cold = 12.0),
        3,
        ThermalGenerationCost(
            CostCurve(PiecewisePointCurve(
                [(5.0, 0.0), (7.33, 290.1), (9.67, 582.72), (12.0, 894.1)])),
            897.29,
            (hot = 393.28, warm = 455.37, cold = 703.76),
            0.0,
        ),
        100.0,
    ),
    ThermalMultiStart(
        "101_CT_1",
        true,
        true,
        nodes5[1],
        0.08,
        0.020,
        0.12,
        PrimeMovers.ST,
        ThermalFuels.COAL,
        (min = 0.08, max = 0.20),
        (min = -0.30, max = 0.30),
        (up = 0.002 * 0.2, down = 0.002 * 0.2),
        (startup = 0.08, shutdown = 0.08),
        (up = 1.0, down = 1.0),
        (hot = 1.0, warm = 999.0, cold = 999.0),
        1,
        ThermalGenerationCost(
            CostCurve(PiecewisePointCurve(
                [(8.0, 0.0), (12.0, 391.45), (16.0, 783.74), (20.0, 1212.28)])),
            1085.78,
            (hot = 51.75, warm = PSY.START_COST, cold = PSY.START_COST),
            0.0,
        ),
        100.0,
    ),
];

thermal_generators5_uc_testing(nodes) = [
    ThermalStandard(
        name = "Alta",
        available = true,
        status = false,
        bus = nodes[1],
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 0.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.2, max = 0.40),
        reactive_power_limits = (min = -0.30, max = 0.30),
        ramp_limits = (up = 0.40, down = 0.40),
        time_limits = (up = 0.0, down = 0.0),
        operation_cost = ThermalGenerationCost(CostCurve(LinearCurve(14.0)), 0.0, 4.0, 2.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Park City",
        available = true,
        status = false,
        bus = nodes[1],
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 2.2125,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 0.65, max = 1.70),
        reactive_power_limits = (min = -1.275, max = 1.275),
        ramp_limits = (up = 0.02 * 2.2125, down = 0.02 * 2.2125),
        time_limits = (up = 0.0, down = 0.0),
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.0, 15.0, 0.0)), 0.0, 1.5, 0.75),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Solitude",
        available = true,
        status = true,
        bus = nodes[3],
        active_power = 2.7,
        reactive_power = 0.00,
        rating = 5.20,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 1.0, max = 5.20),
        reactive_power_limits = (min = -3.90, max = 3.90),
        ramp_limits = (up = 0.0012 * 5.2, down = 0.0012 * 5.2),
        time_limits = (up = 5.0, down = 3.0),
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.0, 30.0, 0.0)), 0.0, 3.0, 1.5),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Sundance",
        available = true,
        status = false,
        bus = nodes[4],
        active_power = 0.0,
        reactive_power = 0.00,
        rating = 2.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 1.0, max = 2.0),
        reactive_power_limits = (min = -1.5, max = 1.5),
        ramp_limits = (up = 0.015 * 2.5, down = 0.015 * 2.5),
        time_limits = (up = 2.0, down = 1.0),
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.0, 40.0, 0.0)), 0.0, 4.0, 2.0),
        base_power = 100.0,
    ),
    ThermalStandard(
        name = "Brighton",
        available = true,
        status = true,
        bus = nodes[5],
        active_power = 6.0,
        reactive_power = 0.0,
        rating = 7.5,
        prime_mover_type = PrimeMovers.ST,
        fuel = ThermalFuels.COAL,
        active_power_limits = (min = 3.0, max = 6.0),
        reactive_power_limits = (min = -4.50, max = 4.50),
        ramp_limits = (up = 0.0015 * 7.5, down = 0.0015 * 7.5),
        time_limits = (up = 5.0, down = 3.0),
        operation_cost = ThermalGenerationCost(CostCurve(QuadraticCurve(0.0, 10.0, 0.0)), 0.0, 1.5, 0.75),
        base_power = 100.0,
    ),
];


renewable_generators5(nodes5) = [
    RenewableDispatch(
        "WindBusA",
        true,
        nodes5[5],
        0.0,
        0.0,
        1.200,
        PrimeMovers.WT,
        (min = 0.0, max = 0.0),
        1.0,
        RenewableGenerationCost(CostCurve(LinearCurve(0.220))),
        100.0,
    ),
    RenewableDispatch(
        "WindBusB",
        true,
        nodes5[4],
        0.0,
        0.0,
        1.200,
        PrimeMovers.WT,
        (min = 0.0, max = 0.0),
        1.0,
        RenewableGenerationCost(CostCurve(LinearCurve(0.220))),
        100.0,
    ),
    RenewableDispatch(
        "WindBusC",
        true,
        nodes5[3],
        0.0,
        0.0,
        1.20,
        PrimeMovers.WT,
        (min = -0.800, max = 0.800),
        1.0,
        RenewableGenerationCost(CostCurve(LinearCurve(0.220))),
        100.0,
    ),
];

hydro_generators5(nodes5) = [
    HydroDispatch(
        name = "HydroDispatch",
        available = true,
        bus = nodes5[2],
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 6.0,
        prime_mover_type = PrimeMovers.HY,
        active_power_limits = (min = 0.0, max = 6.0),
        reactive_power_limits = (min = 0.0, max = 6.0),
        ramp_limits = nothing,
        time_limits = nothing,
        base_power = 100.0,
    ),
    HydroTurbine(;
        name = "HydroEnergyReservoirTurbine",
        available = true,
        bus = node,
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 7.0,
        active_power_limits = (min = 0.0, max = 7.0),
        reactive_power_limits = (min = 0.0, max = 7.0),
        ramp_limits = (up = 7.0, down = 7.0),
        time_limits = nothing,
        operation_cost = HydroGenerationCost(
            CostCurve(LinearCurve(0.15)), 0.0),
        base_power = 100.0,
        conversion_factor = 1.0,
        outflow_limits = nothing,
        powerhouse_elevation = 0.0
    )
];

hydro_reservoir() = PSY.HydroReservoir(;
        name = "HydroReservoir",
        available = true,
        storage_level_limits = (min = 0.0, max = 50.0),
        spillage_limits = nothing,
        inflow = 4.0,
        outflow = 0.0,
        level_targets = nothing,
        intake_elevation = 0.0,
        travel_time = 0.0,
        initial_level = 0.5,
        head_to_volume_factor = LinearCurve(0.0),
        operation_cost = HydroReservoirCost(;
                level_shortage_cost = 50.0,
                level_surplus_cost = 0.0,)
    )

# Modeling a 50 MW with 10 hours of duration.
function phes5(nodes5)
    head_reservoir = HydroReservoir(;
        name = "Head Reservoir",
        available = true,
        initial_level = 0.,
        storage_level_limits = (min = 0.0, max = 2.0),
        spillage_limits = nothing,
        inflow = 0.0,
        outflow = 0.0,
        level_targets = 0.15,
        travel_time = nothing,
        head_to_volume_factor = 1.0,
        intake_elevation = 100.0,
    )

    tail_reservoir = HydroReservoir(;
        name = "Tail Reservoir",
        available = true,
        initial_level = 0.,
        storage_level_limits = (min = 0.0, max = 2.0),
        spillage_limits = nothing,
        inflow = 0.0,
        outflow = 0.0,
        level_targets = 0.15,
        travel_time = nothing,
        head_to_volume_factor = 1.0,
        intake_elevation = 0.0,
    )

    turbine = HydroPumpTurbine(;
        name="HydroPumpTurbine",
        available=true,
        bus=nodes5[3],
        active_power=0.0,
        reactive_power=0.0,
        rating=1.0,
        active_power_limits=(min=0.0, max=1.0),
        reactive_power_limits=(min=0.0, max=1.0),
        active_power_limits_pump=(min=0.0, max=1.0),
        outflow_limits=(min=0.0, max=1.0),
        head_reservoir=head_reservoir,
        tail_reservoir=tail_reservoir,
        powerhouse_elevation=0.0,
        ramp_limits=(up = 0.1, down = 0.1),
        time_limits=nothing,
        base_power=50.0,
        operation_cost=HydroGenerationCost(nothing),
        active_power_pump=0.0,
        efficiency=(turbine = 0.9, pump = 0.8),
        transition_time=(turbine = 0.1, pump = 0.1),
        minimum_time=(turbine = 1.0, pump = 1.0),
        conversion_factor=1.0,
        must_run=false,
        prime_mover_type=PrimeMovers.PS,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )

    return [turbine, head_reservoir, tail_reservoir]
end

battery5(nodes5) = [EnergyReservoirStorage(
    name = "Bat",
    prime_mover_type = PrimeMovers.BA,
    storage_technology_type = StorageTech.OTHER_CHEM,
    available = true,
    bus = nodes5[1],
    storage_capacity = 4.0,
    storage_level_limits = (min = 0.05 / 4.0, max = 4.0 / 4.0),
    initial_storage_capacity_level = 2.0 / 4.0,
    rating = 4.0,
    active_power = 4.0,
    input_active_power_limits = (min = 0.0, max = 2.0),
    output_active_power_limits = (min = 0.0, max = 2.0),
    efficiency = (in = 0.80, out = 0.90),
    reactive_power = 0.0,
    reactive_power_limits = (min = -2.0, max = 2.0),
    base_power = 100.0,
)];

batteryems5(nodes5) = [
     PSY.EnergyReservoirStorage(;
         name = "Bat2",
         prime_mover_type = PrimeMovers.BA,
         storage_technology_type = StorageTech.OTHER_CHEM,
         available = true,
         bus = nodes5[1],
         storage_capacity = 7.0,
         storage_level_limits = (min = .10 / 7.0, max = 7.0 / 7.0),
         initial_storage_capacity_level = 5.0 / 7.0,
         rating = 7.0,
         active_power = 2.0,
         input_active_power_limits = (min = 0.0, max = 2.0),
         output_active_power_limits = (min = 0.0, max = 2.0),
         efficiency = (in = 0.80, out = 0.90),
         reactive_power = 0.0,
         reactive_power_limits = (min = -2.0, max = 2.0),
         base_power = 100.0,
         storage_target = 0.2,
         operation_cost = PSY.StorageCost(;
            charge_variable_cost = zero(CostCurve),
            discharge_variable_cost = zero(CostCurve),
            fixed = 0.0,
            start_up = 0.0,
            shut_down = 0.0,
            energy_shortage_cost = 50.0,
            energy_surplus_cost = 40.0,
        ),
     )
 ];

loadbus2_ts_DA = [
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

loadbus3_ts_DA = [
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

loadbus4_ts_DA = [
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

loads5(nodes5) = [
    PowerLoad(
        "Bus2",
        true,
        nodes5[2],

        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Bus3",
        true,
        nodes5[3],

        3.0,
        0.9861,
        100.0,
        3.0,
        0.9861,
    ),
    PowerLoad(
        "Bus4",
        true,
        nodes5[4],

        4.0,
        1.3147,
        100.0,
        4.0,
        1.3147,
    ),
];

interruptible(nodes5) = [InterruptiblePowerLoad(
    "IloadBus4",
    true,
    nodes5[4],

    1.00,
    0.0,
    1.00,
    0.0,
    100.0,
    LoadCost(CostCurve(LinearCurve(1.50)), 24.0),
)]
# Natural Units: First vector: Power in MW, Second Vector: Slopes in $/MWh
ORDC_cost = CostCurve(PiecewiseIncrementalCurve(0.0, [0.0, 20.0, 40.0, 60.0, 80.0], [150.0, 27.5, 24.5, 0.5]))

reserve5(thermal_generators5) = [
    VariableReserve{ReserveUp}(
        "Reserve1",
        true,
        0.6,
        maximum([gen.active_power_limits[:max] for gen in thermal_generators5]) .* 0.001,
    ),
    VariableReserve{ReserveDown}(
        "Reserve2",
        true,
        0.3,
        maximum([gen.active_power_limits[:max] for gen in thermal_generators5]) .* 0.005,
    ),
    VariableReserve{ReserveUp}(
        "Reserve11",
        true,
        0.8,
        maximum([gen.active_power_limits[:max] for gen in thermal_generators5]) .* 0.001,
    ),
    ReserveDemandCurve{ReserveUp}(nothing, "ORDC1", true, 0.6),
    VariableReserveNonSpinning("NonSpinningReserve", true, 0.5, maximum([gen.active_power_limits[:max] for gen in thermal_generators5]) .* 0.001),
]

reserve5_re(renewable_generators5) = [
    VariableReserve{ReserveUp}("Reserve3", true, 30, 100),
    VariableReserve{ReserveDown}("Reserve4", true, 5, 50),
    ReserveDemandCurve{ReserveUp}(nothing, "ORDC1", true, 0.6),
]
reserve5_hy(hydro_generators5) = [
    VariableReserve{ReserveUp}("Reserve5", true, 30, 100),
    VariableReserve{ReserveDown}("Reserve6", true, 5, 50),
    ReserveDemandCurve{ReserveUp}(nothing, "ORDC1", true, 0.6),
]

reserve5_il(interruptible_loads) = [
    VariableReserve{ReserveUp}("Reserve7", true, 30, 100),
    VariableReserve{ReserveDown}("Reserve8", true, 5, 50),
    ReserveDemandCurve{ReserveUp}(nothing, "ORDC1", true, 0.6),
]


reserve5_phes(phes5) = [
    VariableReserve{ReserveUp}("Reserve9", true, 30, 100),
    VariableReserve{ReserveDown}("Reserve10", true, 5, 50),
    ReserveDemandCurve{ReserveUp}(nothing, "ORDC1", true, 0.6),
]

# TODO: add a sensible cost for hybrid devices
hybrid_cost = PiecewiseStepData([0.0, 1.0], [0.0])
hybrid_cost_ts = [
    TimeSeries.TimeArray(DayAhead, repeat([hybrid_cost], 24)),
    TimeSeries.TimeArray(DayAhead + Day(1), repeat([hybrid_cost], 24)),
]

Reserve_ts = [TimeSeries.TimeArray(DayAhead, rand(24)), TimeSeries.TimeArray(DayAhead + Day(1), rand(24))]

hydro_timeseries_DA = [
    [TimeSeries.TimeArray(DayAhead, hydro_inflow_ts_DA)],
    [TimeSeries.TimeArray(DayAhead + Day(1), ones(24) * 0.1 + hydro_inflow_ts_DA)],
];

storage_target = zeros(24)
storage_target[end] = 0.1
storage_target_DA = [
   [TimeSeries.TimeArray(DayAhead, storage_target)],
   [TimeSeries.TimeArray(DayAhead + Day(1), storage_target)],
];

hydro_budget_DA = [
    [TimeSeries.TimeArray(DayAhead, hydro_inflow_ts_DA * 0.8)],
    [TimeSeries.TimeArray(DayAhead + Day(1), hydro_inflow_ts_DA * 0.8)],
];

RealTime = collect(
    DateTime("1/1/2024 0:00:00", "d/m/y H:M:S"):Minute(5):DateTime(
        "1/1/2024 23:55:00",
        "d/m/y H:M:S",
    ),
)

hydro_timeseries_RT = [
    [TimeSeries.TimeArray(RealTime, repeat(hydro_inflow_ts_DA, inner = 12))],
    [TimeSeries.TimeArray(RealTime + Day(1), ones(288) * 0.1 + repeat(hydro_inflow_ts_DA, inner = 12))],
];

storage_target_RT = [
    [TimeSeries.TimeArray(RealTime, repeat(storage_target, inner = 12))],
    [TimeSeries.TimeArray(RealTime + Day(1), repeat(storage_target, inner = 12))],
];

hydro_budget_RT = [
    [TimeSeries.TimeArray(RealTime, repeat(hydro_inflow_ts_DA  * 0.8, inner = 12))],
    [TimeSeries.TimeArray(RealTime + Day(1), repeat(hydro_inflow_ts_DA  * 0.8, inner = 12))],
];

hybrid_cost_RT = hybrid_cost = PiecewiseStepData([0.0, 1.0], [0.0])
hybrid_cost_ts_RT = [
    [TimeSeries.TimeArray(RealTime, repeat([hybrid_cost], 288))],
    [TimeSeries.TimeArray(RealTime + Day(1), repeat([hybrid_cost_RT], 288))],
];

load_timeseries_RT = [
    [
        TimeSeries.TimeArray(RealTime, repeat(loadbus2_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime, repeat(loadbus3_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime, repeat(loadbus4_ts_DA, inner = 12)),
    ],
    [
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.01 + repeat(loadbus2_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.01 + repeat(loadbus3_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.01 + repeat(loadbus4_ts_DA, inner = 12)),
    ],
]

ren_timeseries_RT = [
    [
        TimeSeries.TimeArray(RealTime, repeat(solar_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime, repeat(wind_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime, repeat(wind_ts_DA, inner = 12)),
    ],
    [
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.1 + repeat(solar_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.1 + repeat(wind_ts_DA, inner = 12)),
        TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.1 + repeat(wind_ts_DA, inner = 12)),
    ],
]

Iload_timeseries_RT = [
    [TimeSeries.TimeArray(RealTime, repeat(loadbus4_ts_DA, inner = 12))],
    [TimeSeries.TimeArray(RealTime + Day(1), rand(288) * 0.1 + repeat(loadbus4_ts_DA, inner = 12))],
]

load_timeseries_DA = [
    [
        TimeSeries.TimeArray(DayAhead, loadbus2_ts_DA),
        TimeSeries.TimeArray(DayAhead, loadbus3_ts_DA),
        TimeSeries.TimeArray(DayAhead, loadbus4_ts_DA),
    ],
    [
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + loadbus2_ts_DA),
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + loadbus3_ts_DA),
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + loadbus4_ts_DA),
    ],
];

ren_timeseries_DA = [
    [
        TimeSeries.TimeArray(DayAhead, solar_ts_DA),
        TimeSeries.TimeArray(DayAhead, wind_ts_DA),
        TimeSeries.TimeArray(DayAhead, wind_ts_DA),
    ],
    [
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + solar_ts_DA),
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + wind_ts_DA),
        TimeSeries.TimeArray(DayAhead + Day(1), rand(24) * 0.1 + wind_ts_DA),
    ],
];

Iload_timeseries_DA = [
    [TimeSeries.TimeArray(DayAhead, loadbus4_ts_DA)],
    [TimeSeries.TimeArray(DayAhead + Day(1), loadbus4_ts_DA + 0.1 * rand(24))],
]


### New Hydro Data ###

weekly_hydro_reservoir_inflow_water_m3_s = [
    10.53, #2020-01-01
    8.44, #2020-01-08
    7.78, #2020-01-15
    6.84, #2020-01-22
    27.79, #2020-01-25    
    6.09, #2020-02-05
    3.94, #2020-02-12   
] # Jiguey data in m³/s

# Convert to MW by multiplying by 220 (typical water height drop for Jiguey dam) 9.81 (gravity) * 1000 (density of water) * 0.9 (efficiency) and divide by 1e8 to transform to MW and per-unit (100MW base power)
weekly_hydro_reservoir_inflow_energy_pu =
    weekly_hydro_reservoir_inflow_water_m3_s * 220 * 9.81 * 1000.0 * 0.9 / 1e8

day_hydro_reservoir_inflow_energy_pu = ones(24) * weekly_hydro_reservoir_inflow_energy_pu[1]
day_hydro_reservoir_inflow_water_m3_s = ones(24) * weekly_hydro_reservoir_inflow_water_m3_s[1]

inflow_ts_DA_energy = [
    [TimeSeries.TimeArray(DayAhead, day_hydro_reservoir_inflow_energy_pu)],
    [TimeSeries.TimeArray(DayAhead + Day(1), day_hydro_reservoir_inflow_energy_pu + 0.1 * rand(24))],
]

inflow_ts_DA_water = [
    [TimeSeries.TimeArray(DayAhead, day_hydro_reservoir_inflow_water_m3_s)],
    [TimeSeries.TimeArray(DayAhead + Day(1), day_hydro_reservoir_inflow_water_m3_s + 0.05 * rand(24))],
]

outflow_ts_DA_water = [
    [TimeSeries.TimeArray(DayAhead, zeros(24))], # No outflow in the first day
    [TimeSeries.TimeArray(DayAhead + Day(1), zeros(24))], # No outflow in the second day
]

hydro_turbines5_energy(nodes5) = [
    HydroTurbine(;
        name = "HydroEnergyReservoir_turbine",
        available = true,
        bus = nodes5[3],
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 7.0,
        active_power_limits = (min = 0.0, max = 7.0),
        reactive_power_limits = (min = 0.0, max = 7.0),
        outflow_limits = nothing,
        ramp_limits = nothing,
        time_limits = nothing,
        base_power = 100.0,
        powerhouse_elevation = 0.0,
        operation_cost = HydroGenerationCost(CostCurve(LinearCurve(0.15)), 0.0),
    )
]

hydro_reservoir5_energy() = [
    HydroReservoir(;
        name = "HydroEnergyReservoir__reservoir",
        available = true,
        initial_level = 0.5,
        storage_level_limits = (min = 0.0, max = 5000.0), # in MWh 
        spillage_limits = nothing,
        inflow = 4.0, # in MW
        outflow = 0.0, # in MW
        level_targets = 1.0,
        travel_time = nothing,
        intake_elevation = 0.0,
        head_to_volume_factor = 0.0,
        level_data_type = PowerSystems.ReservoirDataType.ENERGY,
    )
]


hydro_turbines5_head(nodes5) = [
    HydroTurbine(;
        name = "Water_Turbine",
        available = true,
        bus = nodes5[3],
        active_power = 0.0,
        reactive_power = 0.0,
        rating = 5.2,
        active_power_limits = (min = 0.0, max = 5.2),
        reactive_power_limits = (min = -3.9, max = 3.9),
        outflow_limits = (min = 0.0, max = 30.0), # in m³/s
        ramp_limits = nothing,
        time_limits = nothing,
        base_power = 100.0,
        powerhouse_elevation = 317.12, # elevation in meters for Jiguey dam
        operation_cost = HydroGenerationCost(nothing),
    )
]

hydro_reservoir5_head() = [
    HydroReservoir(;
        name = "Water_Reservoir",
        available = true,
        initial_level = 0.9, # 500 m
        storage_level_limits = (min = 463.5, max = 555.5), # in meters 
        spillage_limits = nothing,
        inflow = 0.0, # added in time series
        outflow = 0.0, # no outflow time series
        level_targets = 1.0,
        travel_time = nothing,
        intake_elevation = 463.3,
        head_to_volume_factor = 302376.2, # conversion factor from meters to m³ based on 167.97 million m³ capacity at 555.5 m
        level_data_type = PowerSystems.ReservoirDataType.HEAD,
    )
]
