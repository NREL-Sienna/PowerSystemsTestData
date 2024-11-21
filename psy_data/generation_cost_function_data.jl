################# Fixed Cost values ####################
thermal_generator_linear_cost(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(CostCurve(LinearCurve(10.23)),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_linear_fuel(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(LinearCurve(1.023), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_pwl_io_fuel(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(PiecewisePointCurve([(50.0, 30.0), (80.0, 48.91), (120.0, 88.181), (170.0, 139.319)]), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_pwl_io_cost(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(CostCurve(PiecewisePointCurve([(50.0, 300.0), (80.0, 489.1), (120.0, 881.81), (170.0, 1393.19)])),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_pwl_incremental_cost(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(CostCurve(
                PiecewiseIncrementalCurve(300.0, [50.0, 80.0, 120.0, 170.0], [6.337, 9.8155, 10.2276]),
            ),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_pwl_incremental_fuel(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(
                PiecewiseIncrementalCurve(30.0, [50.0, 80.0, 120.0, 170.0], [0.6337, 0.98155, 1.02276]),
                10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_quad_cost(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(CostCurve(QuadraticCurve(0.0205, 4.708, 3.5509)),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_quad_fuel(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(QuadraticCurve(0.0021, 0.4708, 0.35509), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_pwl_io_cost_nonconvex(node) =
    ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(CostCurve(PiecewisePointCurve([(50.0, 300.0), (80.0, 489.1), (120.0, 871.81), (170.0, 1093.19)])),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    );

################# Time Variable Fuel Costs ####################
function _get_fuel_cost_time_series()
    fuel_price_forecast = SortedDict{Dates.DateTime,TimeSeries.TimeArray}()
    ini_time = DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S")
    fuel_price = [[10.0, 3.0, 10.0, 1.0, 1000.0], [10.0, 3.0, 10.0, 1.0, 1000.0]]
    for (ix, date) in enumerate(range(ini_time; length=2, step=Hour(1)))
        fuel_price_forecast[date] =
            TimeSeries.TimeArray(
                range(ini_time; length=5, step=Hour(1)),
                fuel_price[ix],
            )
    end
    return PSY.Deterministic("fuel_price", fuel_price_forecast)
end

function thermal_generator_linear_fuel_ts(sys, node)
    gen = ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(LinearCurve(1.023), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )
    add_component!(sys, gen)
    set_fuel_cost!(sys, gen, _get_fuel_cost_time_series())
    return gen
end

function thermal_generator_pwl_io_fuel_ts(sys, node)
    gen = ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(PiecewisePointCurve([(50.0, 30.0), (80.0, 48.91), (120.0, 88.181), (170.0, 139.319)]), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )
    add_component!(sys, gen)
    set_fuel_cost!(sys, gen, _get_fuel_cost_time_series())
    return gen
end

function thermal_generator_pwl_incremental_fuel_ts(sys, node)
    gen = ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(
                PiecewiseIncrementalCurve(30.0, [50.0, 80.0, 120.0, 170.0], [0.6337, 0.98155, 1.02276]),
                10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )
    add_component!(sys, gen)
    set_fuel_cost!(sys, gen, _get_fuel_cost_time_series())
    return gen
end

function thermal_generator_quad_fuel_ts(sys, node)
    gen = ThermalStandard(
        name="Test Unit",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(QuadraticCurve(0.0021, 0.4708, 0.35509), 10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )
    add_component!(sys, gen)
    set_fuel_cost!(sys, gen, _get_fuel_cost_time_series())
    return gen
end

## Single Bid MarketBid Cost Function

function thermal_generators_market_bid(node)
    market_bid1 = MarketBidCost(
        30.0,
        (hot = 1.5, warm = 1.5, cold = 1.5),
        0.75,
        CostCurve(PiecewiseIncrementalCurve(0.0, [10.0, 30.0, 50.0, 100.0], [63.37, 98.155, 102.276])),
        nothing,
        Vector{Service}(),
    )

    gen1 = ThermalStandard(
        name="Test Unit1",
        available=true,
        status=true,
        bus=node,
        active_power=0.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.0),
        reactive_power_limits=(min=-0.275, max=0.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=market_bid1,
        base_power=100.0,
    )

    market_bid2 = MarketBidCost(
        50.0,
        (hot = 1.5, warm = 1.5, cold = 1.5),
        0.75,
        CostCurve(PiecewiseIncrementalCurve(0.0, [10.0, 30.0, 50.0, 100.0], [66.37, 88.155, 109.276])),
        nothing,
        Vector{Service}(),
    )

    gen2 = ThermalStandard(
        name="Test Unit2",
        available=true,
        status=true,
        bus=node,
        active_power=0.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.0),
        reactive_power_limits=(min=-0.275, max=0.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=market_bid2,
        base_power=100.0,
    )

    return [gen1, gen2]
end

function thermal_generators_market_bid_ts(sys, node)
    ini_time = DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S")
    market_bid_gen1_data = Dict(
        ini_time => [
            PiecewiseStepData([10.0, 30.0, 50.0, 100.0], [66.37, 89.155, 100.276]),
            PiecewiseStepData([10.0, 25.0, 75.0, 100.0], [67.37, 84.155, 110.276]),
            PiecewiseStepData([10.0, 33.0, 77.0, 100.0], [64.37, 83.155, 111.276]),
            PiecewiseStepData([10.0, 23.0, 89.0, 100.0], [65.37, 90.155, 121.276]),
            PiecewiseStepData([10.0, 23.0, 89.0, 100.0], [65.37, 90.155, 121.276]),
        ],
        ini_time + Hour(1) => [
            PiecewiseStepData([10.0, 30.0, 65.0, 100.0], [66.37, 88.155, 104.276]),
            PiecewiseStepData([10.0, 20.0, 50.0, 100.0], [68.37, 87.155, 107.276]),
            PiecewiseStepData([10.0, 40.0, 60.0, 100.0], [60.37, 86.155, 100.276]),
            PiecewiseStepData([10.0, 30.0, 70.0, 100.0], [61.37, 88.155, 119.276]),
            PiecewiseStepData([10.0, 30.0, 70.0, 100.0], [61.37, 88.155, 119.276]),
        ],
    )
    market_bid_gen1 = PSY.Deterministic(;
        name = "variable_cost",
        data = market_bid_gen1_data,
        resolution = Hour(1),
    )
    market_bid_gen2_data = Dict(
        ini_time => [
            PiecewiseStepData([10.0, 30.0, 50.0, 100.0], [66.37, 89.155, 100.276]),
            PiecewiseStepData([10.0, 25.0, 75.0, 100.0], [67.37, 84.155, 110.276]),
            PiecewiseStepData([10.0, 33.0, 77.0, 100.0], [64.37, 83.155, 111.276]),
            PiecewiseStepData([10.0, 23.0, 89.0, 100.0], [65.37, 90.155, 121.276]),
            PiecewiseStepData([10.0, 23.0, 89.0, 100.0], [65.37, 90.155, 121.276]),
        ],
        ini_time + Hour(1) => [
            PiecewiseStepData([10.0, 32.0, 65.0, 100.0], [66.37, 89.155, 104.276]),
            PiecewiseStepData([10.0, 22.0, 50.0, 100.0], [68.37, 90.155, 107.276]),
            PiecewiseStepData([10.0, 44.0, 60.0, 100.0], [60.37, 91.155, 100.276]),
            PiecewiseStepData([10.0, 35.0, 70.0, 100.0], [61.37, 90.155, 119.276]),
            PiecewiseStepData([10.0, 35.0, 70.0, 100.0], [61.37, 90.155, 119.276]),
        ],
    )

    market_bid_gen2 = PSY.Deterministic(;
        name = "variable_cost",
        data = market_bid_gen2_data,
        resolution = Hour(1),
    )

    market_bid1 = MarketBidCost(
        30.0,
        (hot = 1.5, warm = 1.5, cold = 1.5),
        0.75,
        nothing,
        nothing,
        Vector{Service}(),
    )

    gen1 = ThermalStandard(
        name="Test Unit1",
        available=true,
        status=true,
        bus=node,
        active_power=0.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.0),
        reactive_power_limits=(min=-0.275, max=0.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=market_bid1,
        base_power=100.0,
    )

    market_bid2 = MarketBidCost(
        50.0,
        (hot = 1.5, warm = 1.5, cold = 1.5),
        0.75,
        nothing,
        nothing,
        Vector{Service}(),
    )

    gen2 = ThermalStandard(
        name="Test Unit2",
        available=true,
        status=true,
        bus=node,
        active_power=0.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.5, max=1.0),
        reactive_power_limits=(min=-0.275, max=0.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=market_bid2,
        base_power=100.0,
    )


    PSY.add_component!(sys, gen1)
    PSY.add_component!(sys, gen2)
    PSY.set_variable_cost!(sys, gen1, market_bid_gen1, PSY.UnitSystem.NATURAL_UNITS)
    PSY.set_variable_cost!(sys, gen2, market_bid_gen2, PSY.UnitSystem.NATURAL_UNITS)

    return [gen1, gen2]
end
