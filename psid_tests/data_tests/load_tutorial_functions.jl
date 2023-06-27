using PowerSystems
const PSY = PowerSystems

###############################################
############### Generator Data ################
###############################################

# Parameters are taken from Milano's book Power System Modelling and Scripting
# Kundur's book and typical AVR and TG system data

GENROU_ex() = RoundRotorQuadratic(
    R = 0.0,
    Td0_p = 8.0,
    Td0_pp = 0.03,
    Tq0_p = 0.4,
    Tq0_pp = 0.05,
    Xd = 1.8,
    Xq = 1.7,
    Xd_p = 0.3,
    Xq_p = 0.55,
    Xd_pp = 0.25,
    Xl = 0.2,
    Se = (0.0, 0.0),
)

Marconato_ex() = MarconatoMachine(
    0.0, # R
    1.8, #Xd
    1.7, #Xq
    0.3, #Xd_p
    0.55, #Xq_p
    0.25, #Xd_pp
    0.25, #Xq_pp
    8.00, #Td0_p
    0.4, #Tq0_p
    0.03, #Td0_pp
    0.05, #Tq0_pp
    0.0, #T_AA
) 

shaft_ex() = SingleMass(
    H = 6.175,
    D = 0.05,
)

avr_sexs() = SEXS(
    Ta_Tb = 0.4,
    Tb = 5.0,
    K = 20.0,
    Te = 1.0,
    V_lim = (-999.0, 999.0)
)
tg_tgov1() = SteamTurbineGov1(
    R = 0.05,
    T1 = 0.2,
    valve_position_limits = (-999.0, 999.0),
    T2 = 0.3,
    T3 = 0.8,
    D_T = 0.0,
    DB_h = 0.0,
    DB_l = 0.0,
    T_rate = 0.0
)
pss_none() = PSSFixed(0.0)

##### Generator Constructor #####

function dyn_genrou(gen)
    return PSY.DynamicGenerator(
        name = get_name(gen),
        ω_ref = 1.0,
        machine = GENROU_ex(), 
        shaft = shaft_ex(), 
        avr = avr_sexs(), 
        prime_mover = tg_tgov1(), 
        pss = pss_none(), 
    )
end

function dyn_marconato(gen)
    return PSY.DynamicGenerator(
        name = get_name(gen),
        ω_ref = 1.0,
        machine = Marconato_ex(), 
        shaft = shaft_ex(), 
        avr = avr_sexs(), 
        prime_mover = tg_tgov1(), 
        pss = pss_none(), 
    )
end

###############################################
################ Inverter Data ################
###############################################


# Parameter Data for Outer Control is tuned for three VSM models to have 
# 2% P-ω pu/pu and 5% Q-v pu/pu droop steady state response.
# Methodology for tuning is based on the paper: B. Johnson et al, 
# "A generic primary-control model for grid-forming inverters:
# Towards interoperable operation & control" in HICCS 2022.

# Parameter Data for Inner Controllers and Filters are taken from
# S. D'Arco, J.A. Suul and O.B. Fosso, " A virtual synchronous
# machine implementation for distributed control of power converters
# in smartgrids", Electric Power Systems Research, 2015.

######## Outer Controls #########

# Droop Controller
function outer_control_droop()
    function active_droop()
        return PSY.ActivePowerDroop(Rp = 0.02, ωz = 2 * pi * 20)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.05, ωf = 2 * pi * 20)
    end
    return OuterControl(active_droop(), reactive_droop(), Dict{String,Any}("is_not_reference" => 0.0))
end

# VSM
function outer_control_vsm()
    function virtual_inertia()
        return VirtualInertia(Ta = 0.397887, kd = 0.0, kω = 50.0)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.05, ωf = 2 * pi * 20)
    end
    return OuterControl(virtual_inertia(), reactive_droop())
end

# VOC
function outer_control_voc()
    function active_voc()
        return PSY.ActiveVirtualOscillator(k1 = 0.02*1.0, ψ = pi / 4)
    end
    function reactive_voc()
        return PSY.ReactiveVirtualOscillator(k2 = 0.4 * 1.0)
    end
    return OuterControl(active_voc(), reactive_voc(), Dict{String,Any}("is_not_reference" => 0.0))
end

######## Inner Controls #########
inner_control() = VoltageModeControl(
    kpv = 0.59,     #Voltage controller proportional gain
    kiv = 736.0,    #Voltage controller integral gain
    kffv = 0.0,     #Binary variable enabling the voltage feed-forward in output of current controllers
    rv = 0.0,       #Virtual resistance in pu
    lv = 0.2,       #Virtual inductance in pu
    kpc = 1.27,     #Current controller proportional gain
    kic = 14.3,     #Current controller integral gain
    kffi = 0.0,     #Binary variable enabling the current feed-forward in output of current controllers
    ωad = 50.0,     #Active damping low pass filter cut-off frequency
    kad = 0.2,      #Active damping gain
)

######## PLL Data ########
no_pll() = PSY.FixedFrequency()

######## Filter Data ########
filt() = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01)
filt_no_dynamics() = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01, ext = Dict{String,Any}("is_filter_differential" => 0.0))
filt_voc() = LCLFilter(lf = 0.0196, rf = 0.0139, cf = 0.1086, lg = 0.0196, rg = 0.0139)

####### DC Source Data #########
stiff_source() = FixedDCSource(voltage = 690.0)

####### Converter Model #########
average_converter() = AverageConverter(rated_voltage = 690.0, rated_current = 9999.0)


##### Inverter Constructors #####
# VSM
function inv_vsm(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_vsm(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(), # filter
    ) 
end

function inv_vsm_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_vsm(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(), # filter
    ) 
end

# Droop 
function inv_droop(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_droop(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(), # filter
    ) 
end

function inv_droop_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_droop(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(), # filter
    ) 
end

# VOC
function inv_voc(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_voc(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(),
        #filt_voc(), # filter
    ) 
end

function inv_voc_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_voc(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(),
        #filt_voc(), # filter
    ) 
end

###############################################
################## Load Data ##################
###############################################

### Induction Machine ###

# Parameters are taken from typical per-unit parameters
# of Single Cage Induction Machine Motors provided in Lecture
# Notes ELEC0047: Power System Dynamics, Control and Stability
# by professor Thierry Van Cutsem from University of Liège
# Link: https://thierryvancutsem.github.io/home/elec0047/dyn_of_ind_mac.pdf

Ind_Motor(load) = SingleCageInductionMachine(
    name = PSY.get_name(load),
    R_s = 0.013,
    R_r = 0.009,
    X_ls = 0.067,
    X_lr = 0.17,
    X_m = 3.8,
    H = 1.5,
    A = 0.0,
    B = 1.0, # Torque linearly proportional to speed.
    base_power = 100.0,
)

Ind_Motor3rd(load) = SimplifiedSingleCageInductionMachine(
    name = PSY.get_name(load),
    R_s = 0.013,
    R_r = 0.009,
    X_ls = 0.067,
    X_lr = 0.17,
    X_m = 3.8,
    H = 1.5,
    A = 0.0,
    B = 1.0,
    base_power = 100.0,
)

# Parameters taken from active load model from N. Bottrell Masters
# Thesis "Small-Signal Analysis of Active Loads and Large-signal Analysis
# of Faults in Inverter Interfaced Microgrid Applications", 2014.

# The parameters are then per-unitized to be scalable to represent an aggregation
# of multiple active loads

# Base AC Voltage: Vb = 380 V
# Base Power (AC and DC): Pb = 10000 VA
# Base AC Current: Ib = 10000 / 380 = 26.32 A
# Base AC Impedance: Zb = 380 / 26.32 =  14.44 Ω
# Base AC Inductance: Lb = Zb / Ωb = 14.44 / 377 = 0.3831 H
# Base AC Capacitance: Cb = 1 / (Zb * Ωb) = 0.000183697 F
# Base DC Voltage: Vb_dc = (√8/√3) Vb = 620.54 V
# Base DC Current: Ib_dc = Pb / V_dc = 10000/620.54 = 16.12 A
# Base DC Impedance: Zb_dc = Vb_dc / Ib_dc = 38.50 Ω
# Base DC Capacitance: Cb_dc = 1 / (Zb_dc * Ωb) = 6.8886315e-5 F

Ωb = 2*pi*60
Vb = 380
Pb = 10000
Ib = Pb / Vb
Zb = Vb / Ib
Lb = Zb / Ωb
Cb = 1 / (Zb * Ωb)
Vb_dc = sqrt(8)/sqrt(3) * Vb
Ib_dc = Pb / Vb_dc
Zb_dc = Vb_dc / Ib_dc
Cb_dc = 1/(Zb_dc * Ωb)

function active_cpl(load)
    return PSY.ActiveConstantPowerLoad(
        name = get_name(load),
        r_load = 70.0 / Zb_dc,
        c_dc = 2040e-6 / Cb_dc,
        rf = 0.1 / Zb,
        lf = 2.3e-3 / Lb,
        cf = 8.8e-6 / Cb,
        rg = 0.03 / Zb,
        lg = 0.93e-3 / Lb,
        kp_pll = 0.4,
        ki_pll = 4.69,
        kpv = 0.5 * (Vb_dc / Ib_dc),
        kiv = 150.0 * (Vb_dc / Ib_dc),
        kpc = 15.0 * (Ib / Vb),
        kic = 30000.0 * (Ib / Vb),
        base_power = 100.0,
    )
end

###############################################
############ System Constructors ##############
###############################################

function get_static_system(raw_file)
    sys_exp = System(raw_file)
    l = first(get_components(StandardLoad, sys_exp))
    exp_load = PSY.ExponentialLoad(
        name = get_name(l),
        available = get_available(l),
        bus = get_bus(l),
        active_power = get_constant_active_power(l),
        reactive_power = get_constant_reactive_power(l),
        active_power_coefficient = 0.0, # Constant Power
        reactive_power_coefficient = 0.0, # Constant Power
        base_power = get_base_power(l),
        max_active_power = get_max_constant_active_power(l),
        max_reactive_power = get_max_constant_reactive_power(l),
    )
    remove_component!(sys_exp, l)
    add_component!(sys_exp, exp_load)
    return sys_exp
end

function get_genrou_system(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = dyn_genrou(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_marconato_system(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = dyn_marconato(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_vsm_system(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_vsm(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_vsm_system_nodyn(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_vsm_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_droop_system(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_droop(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_droop_system_nodyn(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_droop_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_voc_system(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_voc(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_voc_system_nodyn(raw_file)
    sys = get_static_system(raw_file)
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_voc_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end
