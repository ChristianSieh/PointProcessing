--[[

  * * * * lip.lua * * * *

Lua image processing demo program: exercise all LuaIP library routines.

Authors: John Weiss and Alex Iverson
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

-- LuaIP image processing routines
require "ip"   -- this loads the packed distributable
local viz = require "visual"
local il = require "il"
-- for k,v in pairs( il ) do io.write( k .. "\n" ) end

-- load images listed on command line
local imgs = {...}
for i, fname in ipairs( imgs ) do loadImage( fname ) end

-----------
-- menus --
-----------

local cmarg1 = {name = "color model", type = "string", displaytype = "combo", choices = {"rgb", "yiq", "ihs"}, default = "rgb"}
local cmarg2 = {name = "color model", type = "string", displaytype = "combo", choices = {"yiq", "yuv", "ihs"}, default = "yiq"}
local cmarg3 = {name = "interpolation", type = "string", displaytype = "combo", choices = {"nearest neighbor", "bilinear"}, default = "bilinear"}

local function pointSelector( img, pt )
  local rgb = img:at( pt.y, pt.x )
  io.write( ( "point: (%d,%d) = (%d,%d,%d)\n" ):format( pt.x, pt.y, rgb.r, rgb.g, rgb.b ) );
  return img
end

local function rectSelector( img, r )
  io.write( ( "rect: (%d, %d, %d, %d)\n" ):format( r.x, r.y, r.width, r.height ) );
  return img
end

local function quadSelector( img, q )
  local strs = {}
  for i = 1, 4 do
    strs[i] = ("(%d, %d)"):format(q[i].x, q[i].y)
  end
  io.write("["..table.concat(strs, ", ").."]", "\n")
  return img
end

imageMenu("Point processes",
  {
    {"Grayscale YIQ\tCtrl-M", il.grayscaleYIQ, hotkey = "C-M"},
    {"Grayscale IHS", il.grayscaleIHS},
    {"Negate\tCtrl-N", il.negate, hotkey = "C-N", {cmarg1}},
    {"Brighten", il.brighten, {{name = "amount", type = "number", displaytype = "slider", default = 0, min = -255, max = 255}, cmarg1}},
    {"Contrast Stretch", il.contrastStretch,
      {{name = "min", type = "number", displaytype = "spin", default = 64, min = 0, max = 255},
        {name = "max", type = "number", displaytype = "spin", default = 191, min = 0, max = 255}}},
    {"Scale Intensities", il.scaleIntensities,
      {{name = "min", type = "number", displaytype = "spin", default = 64, min = 0, max = 255},
        {name = "max", type = "number", displaytype = "spin", default = 191, min = 0, max = 255}}},
    {"Posterize", il.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 4, min = 2, max = 64}, cmarg1}},
    {"Gamma", il.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = "1.0"}, cmarg1}},
    {"Log", il.logscale, {cmarg1}},
    {"Sawtooth", il.sawtooth, {{name = "levels", type = "number", displaytype = "spin", default = 4, min = 2, max = 64}}},
    {"Bitplane Slice", il.slice, {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
    {"Pseudocolor", il.pseudocolor,
      {{name = "method", type = "string", displaytype = "combo",
          choices = {"cont", "disc", "cube", "rand", "sin1", "sin2", "sepia", "solar", "saw1", "saw2"}, default = "cube"}}},
  }
)

imageMenu("Histogram processes",
  {
    {"Display Histogram", il.showHistogram,
      {{name = "color model", type = "string", displaytype = "combo", choices = {"yiq", "rgb"}, default = "yiq"}}},
    {"Contrast Stretch", il.stretch, {cmarg2}},
    {"Contrast Specify\tCtrl-H", il.stretchSpecify, hotkey = "C-H",
      {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
        {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}, cmarg2}},
    {"Histogram Equalize", il.equalize,
      {{name = "color model", type = "string", displaytype = "combo", choices = {"ihs", "yiq", "yuv", "rgb"}, default = "ihs"}}},
    {"Histogram Equalize Clip", il.equalizeClip,
      {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"},
        {name = "color model", type = "string", displaytype = "combo", choices = {"ihs", "yiq", "yuv"}, default = "ihs"}}},
    {"Adaptive Equalize", il.adaptiveEqualize,
      {{name = "width", type = "number", displaytype = "spin", default = 15, min = 3, max = 65}}},
    {"Adaptive Contrast Stretch", il.adaptiveContrastStretch,
      {{name = "width", type = "number", displaytype = "spin", default = 15, min = 3, max = 65}}},
  }
)

imageMenu("Neighborhood ops",
  {
    {"Smooth", il.smooth},
    {"Sharpen", il.sharpen},
    {"Mean", il.mean,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Weighted Mean 1", il.meanW1,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Weighted Mean 2", il.meanW2,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Gaussian\tCtrl-G", il.meanW3, hotkey = "C-G",
      {{name = "sigma", type = "number", displaytype = "textbox", default = "1.0"}}},
    {"Minimum", il.minimum},
    {"Maximum", il.maximum},
    {"Median+", il.medianPlus},
    {"Median 3x3", il.curry(il.median, 3)},
    {"Median", il.median,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Emboss", il.emboss},
  }
)

imageMenu("Edge detection",
  {
    {"Sobel Edge Mag\tCtrl-E", il.sobelMag, hotkey = "C-E"},
    {"Sobel Edge Mag/Dir", il.sobel},
    {"Horizontal/Vertical Edges", il.edgeHorVer},
    {"Kirsch Edge Mag/Dir", il.kirsch},
    {"Canny", il.canny,
      {
        {name = "sigma", type = "number", displaytype = "textbox", default = "2.0"},
        {name = "strong edge threshold", type = "number", displaytype = "slider", default = 32, min = 0, max = 255},
        {name = "weak edge threshold", type = "number", displaytype = "slider", default = 16, min = 0, max = 255},
      }},
    {"Laplacian", il.laplacian, {{name = "magnitude", type = "boolean"}}},
    {"Laplacian of Gaussian", il.LoG,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "4.0"}}},
    {"Difference of Gaussians (DoG)", il.DoG,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "2.0"}}},
    {"Marr-Hildreth (LoG with ZC)", il.marrHildrethLoG,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "4.0"}}},
    {"Marr-Hildreth (DoG with ZC)", il.marrHildrethDoG,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "2.0"}}},
    {"Zero Crossings 2D", il.zeroCrossings},
    {"Morph Gradient", il.morphGradient},
    {"Range", il.range},
    {"Variance", il.variance,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Std Dev", il.stdDev,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
  }
)

imageMenu("Morphological operations",
  {
    {"Dilate+", il.dilate},
    {"Erode+", il.erode},
    {"Dilate", il.dilate,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Erode", il.erode,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Open", il.open,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Close", il.close,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"SmoothOC", il.smoothOC,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"SmoothCO", il.smoothCO,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Morph Sharpen", il.sharpenMorph},
    {"Hit-Miss top", il.hitMissTop},
    {"Morph Thin", il.thinMorph,
      {{name = "n", type = "string", displaytype = "combo", choices = {"4", "8"}, default = "8"}}},
    {"ZS Thin", il.thinZS},
    {"Grayscale Thin", il.thinGrayZS},
    {"Morph3D+", il.morph3D,
      {{name = "morph op", type = "string", displaytype = "combo",
          choices = {"erode", "dilate", "open", "close", "smoothCO", "smoothOC"}, default = "erode"}}},
  }
)

imageMenu("Frequency domain",
  {
    {"DFT Magnitude", il.dftMagnitude},
    {"DFT Phase", il.dftPhase},
    {"DFT Mag and Phase", il.dft},
    {"Ideal filter", il.idealFilter,
      {{name = "cutoff", type = "number", displaytype = "spin", default = 10, min = 0, max = 100},
        {name = "boost", type = "number", displaytype = "textbox", default = "0.0"},
        {name = "lowscale", type = "number", displaytype = "textbox", default = "1.0"},
        {name = "highscale", type = "number", displaytype = "textbox", default = "0.0"}}},
    {"Gaussian LP filter", il.gaussLPF,
      {{name = "cutoff", type = "number", displaytype = "spin", default = 10, min = 0, max = 100},
        {name = "boost", type = "number", displaytype = "textbox", default = "0.0"}}},
    {"Gaussian HP filter", il.gaussHPF,
      {{name = "cutoff", type = "number", displaytype = "spin", default = 10, min = 0, max = 100},
        {name = "boost", type = "number", displaytype = "textbox", default = "0.0"}}},
  }
)

imageMenu("Color models",
  {
    {"Convert from RGB", il.fromRGB,
      {{name = "color model", type = "string", displaytype = "combo", choices = {"ihs", "yiq","yuv"}, default = "ihs"}}},
    {"Convert to RGB", il.toRGB,
      {{name = "color model", type = "string", displaytype = "combo", choices = {"ihs", "yiq","yuv"}, default = "ihs"}}},
    {"Display color bank", il.getColorBank,
      {{name = "color bank", type = "string", displaytype = "combo", choices = {"R","G","B","I","H","S","Y","Inphase","Quadrature","U","V"}, default = "R"}}},
    {"Modify color bank", il.setColorBank,
      {{name = "color bank", type = "string", displaytype = "combo", choices = {"R","G","B","I","H","S","Y","Inphase","Quadrature","U","V"}, default = "R"},
        {name = "amount", type = "number", displaytype = "slider", default = 0, min = -255, max = 255}}},
    {"Swap color banks", il.swapColorBanks,
      {{name = "color bank", type = "string", displaytype = "combo", choices = {"RBG","GRB","GBR","BRG","BGR"}, default = "RBG"}}},
    {"False Color", il.falseColor,
      {{name = "image R", type = "image"}, {name = "image G", type = "image"}, {name = "image B", type = "image"}}},
  }
)

imageMenu("Segment",
  {
    {"Binary Threshold", il.threshold,
      {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
    {"Iterative Threshold", il.iterativeThreshold},
    {"Laplacian Threshold", il.laplacianThreshold},
    {"Adaptive Threshold", il.adaptiveThreshold,
      {{name = "width", type = "number", displaytype = "spin", default = 15, min = 3, max = 65}}},
    {"Connected Components", il.connComp,
      {{name = "epsilon", type = "number", displaytype = "spin", default = 16, min = 0, max = 128}}},
    {"Size Filter", il.sizeFilter,
      {{name = "epsilon", type = "number", displaytype = "spin", default = 16, min = 0, max = 128},
        {name = "thresh", type = "number", displaytype = "spin", default = 100, min = 0, max = 16000000}}},
    {"Chamfer 3-4 DT", il.chamfer34},
    {"Contours", il.contours,
      {{name = "interval", type = "number", displaytype = "spin", default = 32, min = 1, max = 128}}},
    {"Add Contours", il.addContours,
      {{name = "interval", type = "number", displaytype = "spin", default = 32, min = 1, max = 128}}},
  }
)

imageMenu("Noise",
  {
    {"Impulse Noise", il.impulseNoise,
      {{name = "probability", type = "number", displaytype = "slider", default = 64, min = 0, max = 1000}}},
    {"White (Salt) Noise", il.whiteNoise,
      {{name = "probability", type = "number", displaytype = "slider", default = 64, min = 0, max = 1000}}},
    {"Black (Pepper) Noise", il.blackNoise,
      {{name = "probability", type = "number", displaytype = "slider", default = 64, min = 0, max = 1000}}},
    {"Gaussian noise", il.gaussianNoise,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "16.0"}}},
    {"Periodic noise", il.periodicNoise,
      {{name = "u0", type = "number", displaytype = "textbox", default = "32.0"},
        {name = "v0", type = "number", displaytype = "textbox", default = "32.0"},
        {name = "amplitude", type = "number", displaytype = "textbox", default = "32.0"}}},
    {"Noise Clean", il.noiseClean,
      {{name = "threshold", type = "number", displaytype = "slider", default = 64, min = 0, max = 256}}},
  }
)

imageMenu("Misc",
  {
    {"Point Selector", pointSelector, {{name="point", type = "point", default = {x=0, y=0}}}},
    {"Rectangle Selector", rectSelector, {{name="rect", type = "rect", default = {x=0,y=0,width=0,height=0}}}},
    {"Quadrilateral Selector", quadSelector, {{name="quad", type = "quad", default = {{0, 0}, {100, 0}, {100, 100}, {0, 100}}}}},
    {"Crop Image", il.crop, {{name="rect", type = "rect", default = {x=0,y=0,width=0,height=0}}}},
    {"Resize", il.rescale,
      {{name = "rows", type = "number", displaytype = "spin", default = 1024, min = 1, max = 16384},
        {name = "cols", type = "number", displaytype = "spin", default = 1024, min = 1, max = 16384}, cmarg3}},
    {"Rotate", il.rotate,
      {{name = "theta", type = "number", displaytype = "slider", default = 0, min = -360, max = 360}, cmarg3}},
    {"Stat Diff", il.statDiff,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65},
        {name = "k", type = "number", displaytype = "textbox", default = "1.0"}}},
    {"Add Image", il.add, {{name = "image", type = "image"}}},
    {"Subtract Image", il.sub, {{name = "image", type = "image"}}},
  }
)

imageMenu("Help",
  {
    {"Help", viz.imageMessage( "Help", "Abandon all hope, ye who enter here..." )},
    {"About", viz.imageMessage( "LuaIP Demo " .. viz.VERSION, "Authors: JMW and AI\nClass: CSC442/542 Digital Image Processing\nDate: Spring 2017" )},
    {"Debug Console", viz.imageDebug},
  }
)

start()
