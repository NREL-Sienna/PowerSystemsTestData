
using PowerSystems
using CSV
using DataFrames
using InfrastructureSystems
using TimeSeries
using Dates 



# defining DA and RT systems
# reading in bus data to a dataframe
bus_path = joinpath(@__DIR__, "Buses.csv")
bus_params = CSV.read(bus_path, DataFrame)


# defining column names as variables
BUS_NUM_COL = "Number"
MIN_VOLT_COL = "Voltage-Min (pu)"
MAX_VOLT_COL = "Voltage-Max (pu)"
BASE_VOLT_COL = "Base Voltage kV"
AREA = "Area" 

# function area118()
# # Creating regions and adding them to system
# areas = []
# for i in 1:3
#     area_name = Area("R$i")
#     push!(areas, area_name)
# end
# return areas
# end



# Defining all the buses 

function nodes118() 
buses = []
for row in eachrow(bus_params)
    num = lpad(row[BUS_NUM_COL], 3, '0')
    min_volt = row[MIN_VOLT_COL]
    max_volt = row[MAX_VOLT_COL]
    base_volt = row[BASE_VOLT_COL]
    if row[BUS_NUM_COL] == 69
        type = ACBusTypes.REF
    else 
        type = ACBusTypes.PQ
    end
    local bus = ACBus(;
      number = parse(Int64, num),
      name = "bus$num",
      bustype = type,
      angle = 0.0,
      magnitude = 1.0,
      voltage_limits = (min = min_volt, max = max_volt),
      base_voltage = base_volt,
    )
    push!(buses, bus)
end
buses = Vector{ACBus}(buses)
return buses
end   



#buses = sort!(get_buses(sys_DA, Set(1:length(bus_params[:, 1]))), by = n -> n.name);

# reading in line data to a dataframe

#Defining all the lines
#not using Min Flow (both in MW in csv)

function branches(nodes) 
line_path = joinpath(@__DIR__,"Lines.csv")
line_params = CSV.read(line_path, DataFrame)
lines = []
tlines = []
for row in eachrow(line_params) 
    num = lpad(rownumber(row), 3, '0')
    bus_from = parse(Int, row["Bus from "][4:6])
    bus_to = parse(Int, row["Bus to"][4:6])
    if bus_params[bus_to, "Base Voltage kV"] == bus_params[bus_from, "Base Voltage kV"]
        local line = Line(;
            name = "line$num",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = nodes[bus_from], to = nodes[bus_to]),
            r = row["Resistance (p.u.)"],
            x = row["Reactance (p.u.)"],
            b = (from = 0.0, to = 0.0),
            rating = row["Max Flow (MW)"]/100,
            angle_limits = (min = 0.0, max = 0.0),
        );
        push!(lines, line)
    else
        local tline = Transformer2W(;
            name = "line$num",
            available = true,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(; from = nodes[bus_from], to = nodes[bus_to]),
            r = row["Resistance (p.u.)"],
            x = row["Reactance (p.u.)"],
            primary_shunt = 0.0,
            rating = row["Max Flow (MW)"]/100,
        );
        push!(tlines, tline)
    end
end
arcs = vcat(lines, tlines)
arcs = Vector{ACBranch}(arcs)
return arcs
end



gen_path = joinpath(@__DIR__, "gen.csv")
gen_params = CSV.read(gen_path, DataFrame)


thermal_gens = DataFrame()
hydro_gens = DataFrame()
solar_gens = DataFrame()
wind_gens = DataFrame()

for row in eachrow(gen_params)
    if row["type"] == "Thermal "
        push!(thermal_gens, row, promote=true)
    elseif row["type"] == "Hydro"
        push!(hydro_gens, row, promote=true)
    elseif row["type"] == "Solar"
        push!(solar_gens, row, promote=true)
    elseif row["type"] == "Wind"
        push!(wind_gens, row, promote=true)
    end
end

bus_thermal = []

# Creating prime mover dict
thermal_prime_mover_type = Dict{String, PrimeMovers}(
"OT" => PrimeMovers.OT,
"CC" => PrimeMovers.CC,
"CT" => PrimeMovers.CT,
"HA" => PrimeMovers.HA,
"IC" => PrimeMovers.IC,
#"PVe" => PrimeMovers.Pve,
"WT" => PrimeMovers.WT,
"ST" => PrimeMovers.ST,
)

    # Fuel Prices
    ng_price = 5.4
    coal_price = 1.8
    oil_price = 21
    bm_price = 2.4
    geo_price = 0

# Mapping Fuel Prices and type to type of generators
fuel_prices = []
fuel = []
for i in 1:192
    if thermal_gens[i, "PrimeMoveType"] == "OT"
        push!(fuel_prices, bm_price)
        push!(fuel, ThermalFuels.AG_BIPRODUCT)
    elseif thermal_gens[i, "PrimeMoveType"] == "CC" || startswith(thermal_gens[i, "Generator Name"], "CT NG") || startswith(thermal_gens[i, "Generator Name"], "ICE NG") || startswith(thermal_gens[i, "Generator Name"], "ST NG")
        push!(fuel_prices, ng_price)
        push!(fuel, ThermalFuels.NATURAL_GAS)
    elseif startswith(thermal_gens[i, "Generator Name"], "CT Oil")
        push!(fuel_prices, oil_price)
        push!(fuel, ThermalFuels.DISTILLATE_FUEL_OIL)
    elseif startswith(thermal_gens[i, "Generator Name"], "ST Coal")
        push!(fuel_prices, coal_price)
        push!(fuel, ThermalFuels.COAL)
    elseif startswith(thermal_gens[i, "Generator Name"], "Geo")
        push!(fuel_prices, geo_price)
        push!(fuel, ThermalFuels.GEOTHERMAL)
    elseif startswith(thermal_gens[i, "Generator Name"], "ST Other 01")
        push!(fuel_prices, oil_price)
        push!(fuel, ThermalFuels.DISTILLATE_FUEL_OIL)
    elseif startswith(thermal_gens[i, "Generator Name"], "ST Other 02")
        push!(fuel_prices, ng_price)
        push!(fuel, ThermalFuels.NATURAL_GAS)
    end
end
# parsing rating from gen.csv 
ratings = []
for i in 1:192
    if ismissing(thermal_gens[i, "Rating"]) || thermal_gens[i, "Rating"] == ""
        push!(ratings, 0.0)
    else
        push!(ratings, parse(Float64, thermal_gens[i, "Rating"]))
    end
end


## Creating array of heat rate bands
heat_rate1 = thermal_gens[:, "Heat Rate Inc Band 1 (BTU/kWh)"] ./1000
heat_rate2 = thermal_gens[:, "Heat Rate Inc Band 2 (BTU/kWh)"] ./1000
heat_rate3 = thermal_gens[:, "Heat Rate Inc Band 3 (BTU/kWh)"] ./1000
heat_rate4 = thermal_gens[:, "Heat Rate Inc Band 4 (BTU/kWh)"] ./1000
heat_rate5 = thermal_gens[:, "Heat Rate Inc Band 5 (BTU/kWh)"] ./1000

heat_rates = hcat(
  heat_rate1,
  heat_rate2,
  heat_rate3,
  heat_rate4,
  heat_rate5
)
# Creating array of load points
load_points = hcat(
    thermal_gens[:, "Min Stable Level (MW)"],
    thermal_gens[:, "Load Point Band 1 (MW)"],
    thermal_gens[:, "Load Point Band 2 (MW)"],
    thermal_gens[:, "Load Point Band 3 (MW)"],
    thermal_gens[:, "Load Point Band 4 (MW)"],
    thermal_gens[:, "Load Point Band 5 (MW)"]
)
heat_rate_base = (thermal_gens[:, "Heat Rate Base (MMBTU/hr)"])/1000


thermal_cost_function = []
for i in 1:192
    max_cap = thermal_gens[i, "Max Capacity (MW)"]
    if ismissing(heat_rates[i,2])
        heat_rate = heat_rate1[i]
        heat_rate_curve = LinearCurve(heat_rate, heat_rate_base[i])
        fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[i])
        cost = ThermalGenerationCost(;
            variable = fuel_curve,
            fixed = 0.00,
            start_up = thermal_gens[i, "Start Cost (dollar)"],
            shut_down = 0.0)
    elseif !ismissing(heat_rates[i,2]) && ismissing(heat_rates[i,3])
        heat_rate = [heat_rate1[i], heat_rate2[i]]
        load_point = [load_points[i,1], load_points[i,2], max_cap]
        heat_rate_curve = PiecewiseIncrementalCurve(heat_rate_base[i], load_point, heat_rate)
        fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[i])
        cost = ThermalGenerationCost(;
            variable = fuel_curve,
            fixed = 0.0,
            start_up = thermal_gens[i, "Start Cost (dollar)"],
            shut_down = 0.0
        )
elseif !ismissing(heat_rates[i,2]) && !ismissing(heat_rates[i,3]) && ismissing(heat_rates[i,4])
        heat_rate = [heat_rate1[i], heat_rate2[i], heat_rate3[i]]
        load_point = [load_points[i,1], load_points[i,2], load_points[i,3], max_cap]
        heat_rate_curve = PiecewiseIncrementalCurve(heat_rate_base[i], load_point, heat_rate)
        fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[i])
        cost = ThermalGenerationCost(;
            variable = fuel_curve,
            fixed = 0.0,
            start_up = thermal_gens[i, "Start Cost (dollar)"],
            shut_down = 0.0
        )
    elseif !ismissing(heat_rates[i,2]) && !ismissing(heat_rates[i,3]) && !ismissing(heat_rates[i,4]) && ismissing(heat_rates[i,5])
        heat_rate = [heat_rate1[i], heat_rate2[i], heat_rate3[i], heat_rate4[i]]
        load_point = [load_points[i,1], load_points[i,2], load_points[i,3], load_points[i,4], max_cap]
        heat_rate_curve = PiecewiseIncrementalCurve(heat_rate_base[i], load_point, heat_rate)
        fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[i])
        cost = ThermalGenerationCost(;
            variable = fuel_curve,
            fixed = 0.0,
            start_up = thermal_gens[i, "Start Cost (dollar)"],
            shut_down = 0.0
        )
    elseif !ismissing(heat_rates[i,2]) && !ismissing(heat_rates[i,3]) && !ismissing(heat_rates[i,4]) && !ismissing(heat_rates[i,5])
        heat_rate = [heat_rate1[i], heat_rate2[i], heat_rate3[i], heat_rate4[i], heat_rate5[i]]
        load_point = [load_points[i,1], load_points[i,2], load_points[i,3], load_points[i,4], load_points[i,5], max_cap]
        heat_rate_curve = PiecewiseIncrementalCurve(heat_rate_base[i], load_point, heat_rate)
        fuel_curve = FuelCurve(; value_curve = heat_rate_curve, fuel_cost = fuel_prices[i])
        cost = ThermalGenerationCost(;
            variable = fuel_curve,
            fixed = 0.0,
            start_up = thermal_gens[i, "Start Cost (dollar)"],
            shut_down = 0.0
        )
end
        push!(thermal_cost_function, cost)
    
end

function thermal_generators118(nodes)
thermal_generators = []
for i in 1:192
    prime_mover_str = thermal_gens[i, "PrimeMoveType"]
    prime_mover = thermal_prime_mover_type[prime_mover_str]
    bus_thermal = parse(Int, thermal_gens[i, "bus of connection"][4:6])
    max_active_power = thermal_gens[i, "Max Capacity (MW)"]/100
    min_active_power = thermal_gens[i, "Min Stable Level (MW)"]/100
        thermal = ThermalStandard(;
            name = thermal_gens[i, "Generator Name"],
            available = true,
            status = true,
            bus = nodes[bus_thermal],
            active_power = 0.0,
            reactive_power = 0.0,
            rating = ratings[i],
            active_power_limits = (min = 0, max = max_active_power),
            reactive_power_limits = nothing,
            ramp_limits = (up = thermal_gens[i, "Max Ramp Up (MW/min)"]/100, down = thermal_gens[i, "Max Ramp Down (MW/min)"]/100),
            operation_cost = ThermalGenerationCost(nothing),
            base_power = 100,
            time_limits = (up = thermal_gens[i,"Min Up Time (h)" ], down = thermal_gens[i, "Min Down Time (h)"]),
            prime_mover_type = prime_mover,
            fuel = fuel[i],
        )
        set_operation_cost!(thermal, thermal_cost_function[i])
        push!(thermal_generators, thermal)
end
thermal_generators = Vector{ThermalStandard}(thermal_generators)
return thermal_generators
end

# # Defining all the loads and adding them to lists
# # adding loads and time series into system
participation_factor_path = joinpath(@__DIR__, "Load/partfact.csv")
partfact = sort!(CSV.read(participation_factor_path, DataFrame));

function power_load118(nodes)
loads = []
for row in eachrow(partfact)
    num = lpad(rownumber(row), 3, '0')
    number = parse(Int, num)
    i = parse(Int, row[2][2])
    DAdf_path = joinpath(@__DIR__, "Load/DA", "LoadR$(i)DA.csv");
    DAdf = CSV.read( DAdf_path, DataFrame);
    max = maximum(DAdf[:, 2])
    load = PowerLoad(;
        name = "load$num",
        available = true,
        bus = nodes[number],
        active_power = 0.0, #per-unitized by device base_power
        reactive_power = 0.0, #per-unitized by device base_power
        base_power = 100.0, # MVA, for loads match system
        max_active_power = (max)*(row[3])/100, #per-unitized by device base_power?
        max_reactive_power = 0.0,
    );
push!(loads, load)
end
loads = Vector{PowerLoad}(loads)
return loads
end



# Hydro RT and DA ==========================================================================

resolution = Dates.Hour(1);
timestamps = range(DateTime("2023-01-01T00:00:00"); step = resolution, length = 8784);
hydro_DA_RT_TS = []

#time series created for 16-35, 40-43
#1-15, 36-39 monthly budget modified to get hourly
#1-15 are dispatchable, rest are non-dispatchable
hydro1_15_path = joinpath(@__DIR__, "Hydro", "118-hydro.csv")
hydro1_15 = sort(CSV.read(hydro1_15_path, DataFrame), [:3])
hydro36_39_path = joinpath(@__DIR__, "Hydro", "Hydro_nondispatchable.csv")
hydro36_39 = CSV.read(hydro36_39_path, DataFrame)[21:68, 1:8]

months = []
values = []
hydro_num = []

for row in eachrow(hydro1_15)
	if row[11] !== missing && row[4] == "Max Energy Month"
		push!(months, lpad(row[11][2:end], 2, '0'))
		push!(values, parse(Float64, row[5]))
		push!(hydro_num, row[3])
	end
end

for row in eachrow(hydro36_39)
	push!(months, lpad(row[8][2:end], 2, '0')) 
	push!(values, row[3])
	push!(hydro_num, row[1])
end

hydrobg = sort(DataFrame(Hydro=hydro_num, Month=months, Value=values), [:1, :2])

#constructing time series from budgets
time_series_list = []
daysofmonth = [31,28,31,30,31,30,31,31,30,31,30,32]

for i in 1:19
	local time_series = []
	for row in eachrow(hydrobg[12i-11:12i, :])
		local month = parse(Int, row[2])
		for j in 1:daysofmonth[month]
			for k in 1:24
				push!(time_series, row[3]/(24*daysofmonth[month]))
			end
		end
	end
	push!(time_series_list, (time_series./maximum(time_series)))
end

for i in 1:43
	if i<=15
		local hydro_array = TimeArray(timestamps, time_series_list[i])
		local hydro_TS = SingleTimeSeries(;
           name = "max_active_power",
           data = hydro_array,
		   scaling_factor_multiplier = get_max_active_power, #assumption?
       	);
		push!(hydro_DA_RT_TS, hydro_TS);
	elseif 36<=i<=39
		local hydro_array = TimeArray(timestamps, time_series_list[i-20])
		local hydro_TS = SingleTimeSeries(;
           name = "max_active_power",
           data = hydro_array,
		   scaling_factor_multiplier = get_max_active_power, #assumption?
       	);
		push!(hydro_DA_RT_TS, hydro_TS);
	else
        hydrodf_path = joinpath(@__DIR__, "Hydro", "Hydro $(i).csv")
		local hydrodf = CSV.read(hydrodf_path, DataFrame)
		deleteat!(hydrodf, 1417:1440)
		local hydro_array = TimeArray(timestamps, (hydrodf[:, 2]./maximum(hydrodf[:, 2])))
		local hydro_TS = SingleTimeSeries(;
          name = "max_active_power",
          data = hydro_array,
		  scaling_factor_multiplier = get_max_active_power, #assumption?
       );
		push!(hydro_DA_RT_TS, hydro_TS);
	end
end

  


#building the solar gens
function renewable_generators118(nodes) 
renewable_gens = []
bus_solar = solar_gens[:, "bus of connection"]
for i in 1:75
    ## cost function
    cost_curve = zero(CostCurve)
    value_curve = LinearCurve(0, .275)
    curtailment_cost = CostCurve(value_curve)
    cost_ren = RenewableGenerationCost(cost_curve)
	num = lpad(i, 3, '0')
    local bus_solar = parse(Int, solar_gens[i, "bus of connection"][4:6])
    local rate = gen_params[i, "Max Capacity (MW)"]
    local solar = RenewableDispatch(;
        name = "solar$num",
        available = true,
        bus = nodes[bus_solar],
        active_power = 0.0,
        reactive_power = 0,
        rating = rate,
        prime_mover_type = PrimeMovers.PVe,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = cost_ren,
        base_power = 100
        )
	push!(renewable_gens, solar)
end

#building the wind gens
bus_wind = wind_gens[:, "bus of connection"]
for i in 1:17
    ## cost curve 
    cost_curve = zero(CostCurve)
    value_curve = LinearCurve(0, .275)
    curtailment_cost = CostCurve(value_curve)
    cost_ren = RenewableGenerationCost(cost_curve)
	num = lpad(i, 3, '0')
    local bus_wind = parse(Int, wind_gens[i, "bus of connection"][4:6])
    rate = gen_params[i, "Max Capacity (MW)"]
    local wind = RenewableDispatch(;
        name = "wind$num",
        available = true,
        bus = nodes[bus_wind],
        active_power = 0.0,
        reactive_power = 0,
        rating = rate,
        prime_mover_type = PrimeMovers.WT,
        reactive_power_limits = (min = 0.0, max = 0.0),
        power_factor = 1.0,
        operation_cost = cost_ren,
        base_power = 100
        )
	push!(renewable_gens, wind)
end
renewable_gens = Vector{RenewableDispatch}(renewable_gens)
return renewable_gens

end



# building hydro
function hydro_generators118(nodes)
hydro_generators = []
for i in 1:43
    ## cost functions 
    cost_curve = LinearCurve(0.0)
    value_curve = CostCurve(cost_curve)
    fixed = 0.0
    cost_hydro = HydroGenerationCost(;variable = value_curve, fixed)
	local num = lpad(i, 3, '0')
    local bus_hydro = parse(Int, hydro_gens[i, "bus of connection"][4:6])
    local hydro = HydroDispatch(;
        name = "hydro$num",
        available = true,
        bus = nodes[bus_hydro],
        active_power = 0.0,
        reactive_power = 0,
        rating = 0,
        prime_mover_type = PrimeMovers.HA,
        active_power_limits = (min = hydro_gens[i, "Min Stable Level (MW)"]/100, max = hydro_gens[i, "Max Capacity (MW)"]/100),
        reactive_power_limits = (min = 0.0, max = 0.0),
        ramp_limits = (up = hydro_gens[i, "Max Ramp Up (MW/min)"], down = hydro_gens[i, "Max Ramp Down (MW/min)"]),
        time_limits = (up = hydro_gens[i,"Min Up Time (h)" ], down = hydro_gens[i, "Min Down Time (h)"]),
        base_power = 100,
        operation_cost = cost_hydro
        )
	push!(hydro_generators, hydro)
end
return hydro_generators
end


solar_DA_TS = []
gendata_path = joinpath(@__DIR__, "Generators.csv")
gendata = CSV.read(gendata_path, DataFrame)
for i in 1:75
	solardf_path = joinpath(@__DIR__, "Solar/DA", "Solar$(i)DA.csv")
    solardf = CSV.read(solardf_path, DataFrame)
	local max = maximum(solar_gens[i, "Max Capacity (MW)"])
	solar_array = TimeArray(timestamps, (solardf[:, 2]./max)/100)
	local solar_TS = SingleTimeSeries(;
           name = "max_active_power",
           data = solar_array,
		   scaling_factor_multiplier = get_max_active_power, #assumption?
       );
	push!(solar_DA_TS, solar_TS);
end

# wind: --------------------------
wind_DA_TS = []

for i in 1:17
    winddf_path = joinpath(@__DIR__, "Wind/DA", "Wind$(i)DA.csv")
    winddf = CSV.read(winddf_path, DataFrame)
	local max = maximum(wind_gens[i, "Max Capacity (MW)"])
	local wind_array = TimeArray(timestamps, (winddf[:, 2]./max)/100)
	local wind_TS = SingleTimeSeries(;
           name = "max_active_power",
           data = wind_array,
		   scaling_factor_multiplier = get_max_active_power, #assumption?
       );
	push!(wind_DA_TS, wind_TS);
end

load_TS = []

for i in 1:3
    loaddf_path = joinpath(@__DIR__, "Load/DA", "LoadR$(i)DA.csv")
    loaddf = CSV.read(loaddf_path, DataFrame)
	local load_array = TimeArray(timestamps, (loaddf[:, 2]./maximum(loaddf[:, 2])))
	local load_time_series = SingleTimeSeries(;
           name = "max_active_power",
           data = load_array,
		   scaling_factor_multiplier = get_max_active_power, #assumption?
       );
	push!(load_TS, load_time_series);
end






























