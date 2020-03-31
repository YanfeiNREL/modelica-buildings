within Buildings.Applications.DHC.Loads.Examples;
model Coupling_RC_ETS_New
extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    pAtm(displayUnit="Pa") = 101339,
    filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=true)
    "Weather data reader"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,90})));


 package MediumW = Buildings.Media.Water
 "Source side medium";
 package MediumA = Modelica.Media.Air
 "Load side medium";

// Do not fully qualify the path to building as {{project_name}}.Loads... That does
// not work in JModelica.

//Modelica.Blocks.Interfaces.RealOutput x=5;

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=15
 "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=35
 "Nominal mass flow rate of secondary (building) district cooling side";

 Fluid.Sources.MassFlowSource_T supChiWat(
   redeclare package Medium = MediumW,
   use_T_in=false,
    nPorts=1,
    m_flow=3,
    T=280.15)
             "Chilled water supply" annotation (Placement(transformation(
       extent={{-10,-10},{10,10}},
       rotation=0,
       origin={-64,-28})));
 Fluid.Sources.Boundary_pT sinChiWat(
   redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 6000,
    T=285.15)
  "Sink for chilled water"
    annotation (Placement(transformation(
       extent={{10,-10},{-10,10}},
       rotation=0,
       origin={70,-4})));
 Modelica.Blocks.Sources.RealExpression TChiWatSet(
    y=7 + 273.15)
   "Primary loop chilled water setpoint temperature"
   annotation (Placement(transformation(extent={{-74,-60},{-54,-40}})));

 Modelica.Blocks.Sources.RealExpression THeaWatSup(y=273.15 + 70)
   "Heating water supply temperature"
   annotation (Placement(transformation(extent={{-98,48},{-78,68}})));
 Fluid.Sources.Boundary_pT sinHeaWat(
   redeclare package Medium =MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 600,
    T=313.15)
    "Sink for heating water" annotation (Placement(transformation(
         extent={{10,-10},{-10,10}},
         rotation=0,
         origin={88,84})));
 Fluid.Movers.FlowControlled_m_flow pumBui(
   redeclare package Medium = MediumW,
   inputType=Buildings.Fluid.Types.InputType.Constant,
   use_inputFilter=false,
    nominalValuesDefineDefaultPressureCurve=true,
    redeclare Fluid.Movers.Data.Generic per,
    dp_nominal=6000,
    constantMassFlowRate=3,
    m_flow_nominal=3,
    addPowerToMedium=true)
   "Building-side (secondary) pump"
   annotation (Placement(transformation(extent={{-74,-82},{-54,-62}})));
Modelica.Fluid.Sources.FixedBoundary pre1(
   redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 6000,
    use_T=false,
    T=280.15)
   "Pressure source"
  annotation (Placement(transformation(
       extent={{-10,-10},{10,10}},
       rotation=0,
       origin={-64,0})));

  EnergyTransferStations.CoolingIndirect cooETS(
    redeclare package Medium = MediumW,
    T_a1_nominal=273.15 + 7,
    dpValve_nominal=10000,
    T_a2_nominal=273.15 + 12,
    Q_flow_nominal=10000,
    m1_flow_nominal=100,
    m2_flow_nominal=50,
    dp1_nominal=10000,
    dp2_nominal=10000,
    use_Q_flow_nominal=false)
    annotation (Placement(transformation(extent={{16,-52},{36,-32}})));
  Fluid.Sources.Boundary_pT supHeaWat1(
    redeclare package Medium = MediumW,
    use_T_in=true,
    nPorts=1,
    p(displayUnit="Pa") = 6000)
              "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,62})));
  BaseClasses.BuildingRCZ6 buildingRCZ6(nPorts_a=2, nPorts_b=2)
    annotation (Placement(transformation(extent={{14,24},{58,68}})));
Modelica.Fluid.Sources.FixedBoundary pre2(
    redeclare package Medium = MediumW,
    nPorts=1,
    p(displayUnit="Pa") = 6000,
    T=285.15)
   "Pressure source"
  annotation (Placement(transformation(
       extent={{10,-10},{-10,10}},
       rotation=0,
       origin={52,-82})));
equation





  connect(sinChiWat.ports[1], cooETS.port_b1)
    annotation (Line(points={{60,-4},{60,-36},{36,-36}}, color={0,127,255}));
  connect(TChiWatSet.y, cooETS.TSet) annotation (Line(points={{-53,-50},{-28,-50},
          {-28,-42},{14,-42}}, color={0,0,127}));
  connect(cooETS.port_a1, supChiWat.ports[1]) annotation (Line(points={{16,-36},
          {-28,-36},{-28,-28},{-54,-28}}, color={0,127,255}));
  connect(pre1.ports[1], cooETS.port_a1)
    annotation (Line(points={{-54,0},{16,0},{16,-36}}, color={0,127,255}));
  connect(supHeaWat1.T_in, THeaWatSup.y) annotation (Line(points={{-62,66},{-70,
          66},{-70,58},{-77,58}}, color={0,0,127}));
  connect(pumBui.port_b, cooETS.port_b2) annotation (Line(points={{-54,-72},{-18,
          -72},{-18,-48},{16,-48}}, color={0,127,255}));
  connect(weaDat.weaBus, buildingRCZ6.weaBus) annotation (Line(
      points={{10,80},{26,80},{26,61.6933},{36.0733,61.6933}},
      color={255,204,51},
      thickness=0.5));
  connect(supHeaWat1.ports[1], buildingRCZ6.ports_a[1]) annotation (Line(points={{-40,62},
          {-14,62},{-14,31.3333},{14,31.3333}},          color={0,127,255}));
  connect(pumBui.port_a, buildingRCZ6.ports_a[2]) annotation (Line(points={{-74,-72},
          {-94,-72},{-94,34.2667},{14,34.2667}},
        color={0,127,255}));
  connect(cooETS.port_a2, buildingRCZ6.ports_b[1]) annotation (Line(points={{36,-48},
          {94,-48},{94,31.3333},{58,31.3333}},      color={0,127,255}));
  connect(buildingRCZ6.ports_b[2], sinHeaWat.ports[1]) annotation (Line(points={{58,
          34.2667},{80,34.2667},{80,84},{78,84}},                color={0,127,
          255}));
  connect(pre2.ports[1], cooETS.port_b2)
    annotation (Line(points={{42,-82},{16,-82},{16,-48}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Coupling_RC_ETS_New;
