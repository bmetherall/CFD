#!/usr/local/bin/WolframScript -script

Print[ToString[$CommandLine[[4]]]];

CSV = "surface_flow_0" <> ToString[$CommandLine[[4]]] <> ".csv";
DAT = "flow_0" <> ToString[$CommandLine[[4]]] <> ".dat";
PNG = "Square_Cylinder" <> ToString[$CommandLine[[4]]] <> ".png";

SetDirectory["/home/brady/SU2/CFD/Results/Square_Cylinder"];

xmin = -2;
xmax = 6;
ymin = -2;
ymax = 2;
zmax = 20;
colfunc = ColorData["SunsetColors"][#/zmax] &;
leg = BarLegend[{colfunc, {0, zmax}}, LegendLabel -> "Velocity (m/s)"];

data = Import[CSV];
shapedata = data[[2 ;; -1, {2, 3}]];
shape = Graphics[{Gray, Polygon[shapedata]}];
datafile = 
  ReadList[Export[".dat", Import[DAT][[4 ;; -1]]], 
   Number, RecordLists -> True, RecordSeparators -> {"\n"}];
DeleteFile[".dat"];
Do[If[Dimensions[datafile[[i]]][[1]] == 
    4, {CleanData = datafile[[1 ;; i - 1]], Break[]}], {i, 1, 
   Dimensions[datafile][[1]]}];
Test = CleanData[[All, 1 ;; 6]];

stream = {};
Velocity = {};
Do[
  AppendTo[
   Velocity, {Test[[i, 1]], Test[[i, 2]], 
    Sqrt[(Test[[i, 4]]/Test[[i, 3]])^2 + (Test[[i, 5]]/
         Test[[i, 3]])^2]}], {i, 1, Length[Test]}]

velplot = 
  ListDensityPlot[Velocity, ColorFunction -> colfunc, 
   PlotRange -> {{xmin, xmax}, {ymin, ymax}, {0, zmax}}, 
   AspectRatio -> Automatic, PlotLegends -> leg, 
   ColorFunctionScaling -> False, FrameLabel -> {"x", "y"}, 
   PlotLabel -> 
 Style["Static Square Cylinder (Re = 250)", FontSize -> 18, Black], ImageSize -> Full];

SetDirectory["/home/brady/SU2/CFD/Results/Square_Cylinder/Movies"];
Export[PNG, Show[velplot, shape]]
