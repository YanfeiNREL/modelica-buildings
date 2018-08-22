within Buildings.Occupants.Office.Lighting;
model Gunay2016Light "A model to predict occupants' lighting behavior with illuminance"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AArriv = -0.009 "Slope of logistic regression_arrival";
  parameter Real BArriv = 1.6 "Intercept of logistic regression_arrival";
  parameter Real AInter = -0.002 "Slope of logistic regression_intermediate";
  parameter Real BInter = -3.9 "Intercept of logistic regression_intermediate";
  parameter Integer seed = 30 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput Illu "Illuminance on the working plane, unit:" annotation (
       Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "State of Lighting"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real pArriv(
    unit="1",
    min=0,
    max=1) "Probability of switch on the lighting upon arrival";
  Real pInter(
    unit="1",
    min=0,
    max=1) "Intermediate robability of switch on the lighting";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";
initial equation
  t0 = time;
  on = false;
equation
  pArriv = Modelica.Math.exp(AArriv*Illu + BArriv)/(1+Modelica.Math.exp(AArriv*Illu + BArriv));
  pInter = Modelica.Math.exp(AInter*Illu + BInter)/(1+Modelica.Math.exp(AInter*Illu + BInter));
  sampleTrigger = sample(t0,samplePeriod);
  when {occ,sampleTrigger} then
    if sampleTrigger then
      if occ == true then
        if pre(on) == false then
          on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pInter, globalSeed=seed);
        else
          on = true;
        end if;
      else
        on = false;
      end if;
    else
      on = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pArriv, globalSeed=seed);
    end if;
  end when;


  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Light_Illu")},
defaultComponentName="lig",
Documentation(info="<html>
<p>
Model predicting the state of the lighting with the illuminance on the working plane
and occupancy.
</p>
<h4>Inputs</h4>
<p>
illuminance: the illuminance on the working plane, should be input with the unit of lux.
</p>
<p>
Occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of lighting: a boolean variable, true indicates the light 
is on, false indicates the light is off.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the light is always off. When the 
space is occupied, the probability to switch on the light depends
on the illuminance level on the working plane. The lower the
illuminance level, the higher the chance to switch on the lighting.
</p>
<p>
The probability to switch on the lighting is different when subjects just arrived and when
subjects have stayed indoor for a while. The probability to switch lights is higher when 
subjects just arrived. Accordingly, two different probability functions 
have been applied.
</p>
<p>
The switch-off probability is found to be very low in this research, which 
is might because occupants failed to notice the lighting is on when the indoor
daylight illuminance levels were high. Therefore, in this model, the lighting would
be switched off only when the space is unoccupied.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Gunay, H.B., O'Brien, W. and Beausoleil-Morrison, I., 
2016. Implementation and comparison of existing occupant behaviour models in EnergyPlus. 
Journal of Building Performance Simulation, 9(6), pp.567-588.&quot;.
</p>
<p>
The model parameters are utilized as inputs for the lighting behavior models developped by
Gunay et al.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 27, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Gunay2016Light;
