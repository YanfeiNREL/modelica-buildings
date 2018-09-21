within Buildings.Occupants.BaseClasses.Validation;
model Logit1DQuadratic "Test model for 1D binary variable generation function"
 extends Modelica.Icons.Example;

  parameter Integer seed = 5 "Seed for the random number generator";
  parameter Real A = 0.1 "Parameter A";
  parameter Real B = 0.5 "Parameter B";
  parameter Real C = 1.3 "Parameter A";
  parameter Real D = 1.5 "Parameter B";
  Real x "Time-varying real number as input";
  output Real y "Output";
initial equation
  y = 0;
equation
  x = time+1;
  when sample(0, 0.1) then
  if Buildings.Occupants.BaseClasses.logit1DQuadratic(x,A,B,C,D,globalSeed=integer(seed*1E6*time)) then
    y = 1;
  else
    y = 0;
  end if;
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/Logit1DQuadratic.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.BaseClasses.logit1DQuadratic\">
Buildings.Occupants.BaseClasses.logit1DQuadratic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Logit1DQuadratic;
