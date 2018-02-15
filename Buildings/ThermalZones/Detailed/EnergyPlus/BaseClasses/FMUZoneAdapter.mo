within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
class FMUZoneAdapter "Class used to couple the FMU"
extends ExternalObject;
    function constructor
      "Construct to connect to a thermal zone in EnergyPlus"
      input String fmuName "Name of the FMU";
      input String zoneName "Name of the thermal zone";
      input Integer nFluPor "Number of fluid ports of zone";
      output FMUZoneAdapter adapter;

      external "C" adapter = FMUZoneInit(fmuName, zoneName, nFluPor)
      annotation(Include="#include <FMUZoneInit.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

      annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>FMUBuildingAdapter</code> that
will be used to store the data structure needed to communicate with EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end constructor;

  function destructor "Release storage"
    input FMUZoneAdapter adapter;
    external "C" FMUZoneFree(adapter)
    annotation(Include=" #include <FMUZoneFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>ExtendableArray</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of the data structure needed to communicate with EnergyPlus.

</html>",
revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUZoneAdapter;
