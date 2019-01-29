using PowerSystems
using TimeSeries

DayAhead  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("1/1/2024  23:00:00", "d/m/y  H:M:S"))
#Dispatch_11am =  collect(DateTime("1/1/2024  0:11:00", "d/m/y  H:M:S"):Minute(15):DateTime("1/1/2024  12::00", "d/m/y  H:M:S"))

nodes5    = [Bus(1,"nodeA", "PV", 0, 1.0, (min = 0.9, max=1.05), 230),
             Bus(2,"nodeB", "PQ", 0, 1.0, (min = 0.9, max=1.05), 230),
             Bus(3,"nodeC", "PV", 0, 1.0, (min = 0.9, max=1.05), 230),
             Bus(4,"nodeD", "SF", 0, 1.0, (min = 0.9, max=1.05), 230),
             Bus(5,"nodeE", "PV", 0, 1.0, (min = 0.9, max=1.05), 230),
        ];

branches5 = [Line("1", true, (from=nodes5[1],to=nodes5[2]), 0.00281, 0.0281, (from=0.00356, to=0.00356), 2.0, (min = -0.7, max = 0.7)),
             Line("2", true, (from=nodes5[1],to=nodes5[4]), 0.00304, 0.0304, (from=0.00329, to=0.00329), 2.0, (min = -0.7, max = 0.7)),
             Line("3", true, (from=nodes5[1],to=nodes5[5]), 0.00064, 0.0064, (from=0.01563, to=0.01563), 18.8120, (min = -0.7, max = 0.7)),
             Line("4", true, (from=nodes5[2],to=nodes5[3]), 0.00108, 0.0108, (from=0.00926, to=0.00926), 11.1480, (min = -0.7, max = 0.7)),
             Line("5", true, (from=nodes5[3],to=nodes5[4]), 0.00297, 0.0297, (from=0.00337, to=0.00337), 40.530, (min = -0.7, max = 0.7)),
             Line("6", true, (from=nodes5[4],to=nodes5[5]), 0.00297, 0.0297, (from=0.00337, to=00.00337), 2.00, (min = -0.7, max = 0.7))
];

solar_ts_DA = [0
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
               0]

wind_ts_DA = [0.985205412
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
           0.069569628]

generators5 = [  ThermalDispatch("Alta", true, nodes5[1],
                    TechThermal(0.40, (min=0.0, max=0.40), 0.010, (min = -0.30, max = 0.30), nothing, nothing),
                    EconThermal(0.40, x -> x*14.0, 0.0, 4.0, 2.0, nothing)
                    #EconThermal(40.0, x -> x*14.0, 4.0, 4.0, 2.0, nothing)

                ),
                ThermalDispatch("Park City", true, nodes5[1],
                    TechThermal(1.70, (min=0.0, max=1.70), 0.20, (min =-1.275, max=1.275),nothing, nothing),# (up=5.0, down=5.0), (up=2.0, down=1.0)),
                    EconThermal(1.70, x -> x*15.0, 0.0, 1.5, 0.75, nothing)
                    #EconThermal(170.0, x -> x*15.0, 1.5, 1.5, 0.75, nothing)

                ),
                ThermalDispatch("Solitude", true, nodes5[3],
                    TechThermal(5.20, (min=0.0, max=5.20), 1.00, (min =-3.90, max=3.90),nothing, nothing),# (up=52.0, down=52.0), (up=3.0, down=2.0)),
                    EconThermal(5.20, x -> x*30.0, 0.0, 3.0, 1.5, nothing)
                    #EconThermal(520.0, x -> x*30.0, 3.0, 3.0, 1.5, nothing)

                ),
                ThermalDispatch("Sundance", true, nodes5[4],
                    TechThermal(2.0, (min=0.0, max=2.0), 0.40, (min =-1.5, max=1.5),nothing, nothing),# (up=5.0, down=5.0), (up=2.0, down=1.0)),
                    EconThermal(2.0, x -> x*40.0, 0.0, 4.0, 2.0, nothing)
                    #EconThermal(200.0, x -> x*40.0, 4.0, 4.0, 2.0, nothing)

                ),
                ThermalDispatch("Brighton", true, nodes5[5],
                    TechThermal(6.0, (min=0.0, max=6.0), 1.50, (min =-4.50, max=4.50),nothing, nothing),# (up=60.0, down=60.0), (up=5.0, down=3.0)),
                    #EconThermal(600.0, [(0.0, 0.0), (450.0, 8.0), (600.0, 10.0)], 0.0, 0.0, 0.0, nothing)
                    EconThermal(6.0, x -> x*10.0, 0.0, 0.0, 0.0, nothing)
                )#=,
                RenewableFix("SolarBusC", true, nodes5[3],
                    0.60,
                    TimeSeries.TimeArray(DayAhead,solar_ts_DA)
                ),
                RenewableCurtailment("WindBusA", true, nodes5[5],
                    120.0,
                    EconRenewable(22.0, nothing),
                    TimeSeries.TimeArray(DayAhead,wind_ts_DA)
                )=#
            ];

loadbus2_ts_DA = [ 0.792729978
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
              0.837001437 ]

loadbus3_ts_DA = [ 0.831093782
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
                0.824307054]

loadbus4_ts_DA = [ 0.871297342
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
                0.717847996]

loads5_DA = [ PowerLoad("Bus2", true, nodes5[2], "P", 3.0, 0.9861, TimeArray(DayAhead, loadbus2_ts_DA)),
            PowerLoad("Bus3", true, nodes5[3], "P", 3.0, 0.9861, TimeArray(DayAhead, loadbus3_ts_DA)),
            PowerLoad("Bus4", true, nodes5[4], "P", 4.0, 1.3147, TimeArray(DayAhead, loadbus4_ts_DA))#,
            #InterruptibleLoad("IloadBus4", true, nodes5[4], "P",10.0, 0.0,  2400.0, TimeArray(DayAhead, loadbus4_ts_DA))
        ]

reserve5 = StaticReserve("test_reserve",generators5[1:5],0.6,[gen.tech for gen in generators5[1:5]])