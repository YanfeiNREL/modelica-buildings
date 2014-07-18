within Buildings.Controls.DemandResponse.Examples.Validation;
model ConstantInputDayOfAdjustment
  "Demand response client with constant input for actual power consumption"
  extends Buildings.Controls.DemandResponse.Examples.Validation.ConstantInput(
     baseLoad(use_dayOfAdj=true));

  annotation (
  experiment(StopTime=5270400),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/Validation/ConstantInputDayOfAdjustment.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to 
<a href=\"modelica://Buildings.Controls.DemandResponse.Examples.Validation.ConstantInput\">
Buildings.Controls.DemandResponse.Examples.Validation.ConstantInput</a>,
except that the demand respond client is configured to use the day-of adjustment.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the baseline prediction model based on a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-62,96},{28,74}},
          lineColor={0,0,255},
          textString="fixme: check that there are no spikes in baseLoad.PPre
and in adj at t=1.2132e+06")}));
end ConstantInputDayOfAdjustment;
