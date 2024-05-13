################# Fixed Cost values ####################
thermal_generator_linear_cost(node) =
    ThermalStandard(
        name="Test Linear Cost",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test Linear Fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL Point",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL Point",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL Marginal",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(
                PiecewiseAverageCurve(30.0, [50.0, 80.0, 120.0, 170.0], [0.6337, 0.98155, 1.02276]),
                10.0),
            0.0,
            1.5,
            0.75,
        ),
        base_power=100.0,
    )

thermal_generator_quad_cost(node) =
    ThermalStandard(
        name="Test quad cost",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test quad fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL Nonconvex",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
    fuel_price = [[10.0, 3.0, 10.0, 1.0], [10.0, 3.0, 10.0, 1.0]]
    for (ix, date) in enumerate(range(ini_time; length=2, step=Hour(1)))
        fuel_price_forecast[date] =
            TimeSeries.TimeArray(
                range(ini_time; length=4, step=Hour(1)),
                fuel_price[ix],
            )
    end
    return PSY.Deterministic("fuel_price", fuel_price_forecast)
end

function thermal_generator_linear_fuel_ts(sys, node)
    gen = ThermalStandard(
        name="Test Linear Fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL Point",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
        name="Test PWL fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
        reactive_power_limits=(min=-1.275, max=1.275),
        ramp_limits=(up=0.02 * 2.2125, down=0.02 * 2.2125),
        time_limits=(up=2.0, down=1.0),
        operation_cost=ThermalGenerationCost(FuelCurve(
                PiecewiseAverageCurve(30.0, [50.0, 80.0, 120.0, 170.0], [0.6337, 0.98155, 1.02276]),
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
        name="Test quad fuel",
        available=true,
        status=true,
        bus=node,
        active_power=1.70,
        reactive_power=0.20,
        rating=2.2125,
        prime_mover_type=PrimeMovers.ST,
        fuel=ThermalFuels.COAL,
        active_power_limits=(min=0.0, max=1.70),
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
