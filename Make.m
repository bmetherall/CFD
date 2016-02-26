#!/usr/local/bin/WolframScript -script

(*Change the current directory*)
SetDirectory["/home/brady/SU2/CFD/Results/Turbulent_Cylinder"];
Print[ToString[$CommandLine[[4]]]];
num = ToString[$CommandLine[[4]]];

CSV = "surface_flow_0" <> num <> ".csv";
DAT = "flow_0" <> num <> ".dat";
PNG = "Square_Cylinder" <> num <> ".png";

(*Set the plot limits, colour function, and the legend style*)
xyzlimits = {{-2, 10},{-2.5, 2.5},{0, 125}};
colfunc = ColorData["SunsetColors"][#/xyzlimits[[3,2]]] &;
leg = BarLegend[{colfunc, xyzlimits[[3]]}, LegendLabel -> "Velocity (m/s)",
    LegendMarkerSize -> 500];

(*Draw a gray ploygon using the points of the surface_flow.csv*)
shape = Graphics[{Gray, Polygon[Import[CSV][[2;;-1, {2, 3}]]]}];

(*Clean the data so it's in a usable form*)
(*Import the data file, and remove the preamble (three lines)*)
datafile = Import[DAT][[4 ;; -1]];

(*There is four seemingly random numbers per line for several lines at*)
(*the end, this ignores those lines*)
Do[If[Dimensions[datafile[[i]]][[1]] == 4,
   {CleanData = datafile[[1 ;; i - 1]], Break[]}],
   {i, 1, Dimensions[datafile][[1]]}];
(*Only the first 5 columns are needed: x, y, \[Rho], \[Rho]u, \[Rho]v*)
Data = CleanData[[All, 1 ;; 5]];

(*Declare and fill array for the velocity*)
velocity = {};
Do[AppendTo[velocity, {Data[[i, 1]], Data[[i, 2]], 
   Sqrt[(Data[[i, 4]]/Data[[i, 3]])^2 + (Data[[i, 5]]/Data[[i, 3]])^2]}],
   {i, 1, Length[Data]}]

velplot = ListDensityPlot[velocity, ColorFunction -> colfunc, 
   PlotRange -> xyzlimits, 
   AspectRatio -> Automatic, LabelStyle -> {Black, FontSize -> 18}, 
   PlotLegends -> leg, ColorFunctionScaling -> False, Frame -> True, 
   FrameLabel -> {"x", "y"}, ImageSize -> 1000, 
   PlotLabel -> "Static Cylinder (Re = 20000)", 
   Epilog -> {Style[Text[num, {9, -2}], FontSize -> 14]}];

SetDirectory["/home/brady/SU2/CFD/Results/Turbulent_Cylinder/Movies"];
Export[PNG, Show[velplot, shape]]

