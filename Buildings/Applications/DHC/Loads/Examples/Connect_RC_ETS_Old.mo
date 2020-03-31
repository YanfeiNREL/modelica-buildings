within Buildings.Applications.DHC.Loads.Examples;
model Connect_RC_ETS_Old
extends Modelica.Icons.Example;
    package Medium1 = Buildings.Media.Water "Fluid in the pipes";

 Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{78,66},{58,86}})));

  Buildings.Applications.DHC.EnergyTransferStations.CoolingIndirect
                                         cooETS(
    redeclare package Medium = Medium1,
    m1_flow_nominal=0.1,
    dp1_nominal=1000,
    dp2_nominal=1000,
    m2_flow_nominal=0.05,
    T_a1_nominal=273.15 + 7,
    dpValve_nominal=10000,
    T_a2_nominal=273.15 + 12,
    use_Q_flow_nominal=true,
    Q_flow_nominal=10000)
    annotation (Placement(transformation(extent={{6,18},{26,38}})));
    Buildings.Fluid.Sources.Boundary_pT
                              sup_ChiWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,78})));

  Buildings.Fluid.Sources.Boundary_pT sink_ChilWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for chilled water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={34,78})));

  Modelica.Blocks.Sources.Constant setpoint_chilledWater(k=273.15 + 7)
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));
  Modelica.Blocks.Sources.Constant src_chilledWater(k=273.15 + 7)
    annotation (Placement(transformation(extent={{-92,72},{-72,92}})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=70 + 273.15)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-94,-82},{-74,-62}})));
  Fluid.Sources.Boundary_pT           sinHeaWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for heating water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={160,-78})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-24,-76})));
  BaseClasses.BuildingRCZ6 buildingRCZ6(nPorts_a=2, nPorts_b=2)
    annotation (Placement(transformation(extent={{38,-54},{98,6}})));
equation
  connect(cooETS.port_a1,sup_ChiWat. ports[1])  annotation (Line(points={{6,34},{
          -4,34},{-4,78},{-16,78}},    color={0,127,255}));
  connect(cooETS.port_b1,sink_ChilWat. ports[1]) annotation (Line(points={{26,34},
          {36,34},{36,78},{24,78}},    color={0,127,255}));
  connect(cooETS.TSet,setpoint_chilledWater. y)  annotation (Line(points={{4,28},{
          -71,28}},                  color={0,0,127}));
  connect(src_chilledWater.y,sup_ChiWat. T_in) annotation (Line(points={{-71,82},
          {-38,82}},                     color={0,0,127}));
  connect(THeaWatSup.y, supHeaWat.T_in)
    annotation (Line(points={{-73,-72},{-36,-72}}, color={0,0,127}));
  connect(buildingRCZ6.weaBus, weaDat.weaBus) annotation (Line(
      points={{68.1,-2.6},{68.1,36.7},{58,36.7},{58,76}},
      color={255,204,51},
      thickness=0.5));
  connect(cooETS.port_a2, buildingRCZ6.ports_a[1]) annotation (Line(points={{26,
          22},{32,22},{32,-44},{38,-44}}, color={0,127,255}));
  connect(supHeaWat.ports[1], buildingRCZ6.ports_a[2]) annotation (Line(points=
          {{-14,-76},{12,-76},{12,-40},{38,-40}}, color={0,127,255}));
  connect(buildingRCZ6.ports_b[1], sinHeaWat.ports[1]) annotation (Line(points=
          {{98,-44},{124,-44},{124,-78},{150,-78}}, color={0,127,255}));
  connect(buildingRCZ6.ports_b[2], cooETS.port_b2) annotation (Line(points={{98,
          -40},{104,-40},{104,-90},{-2,-90},{-2,22},{6,22}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Connect_RC_ETS_Old;
