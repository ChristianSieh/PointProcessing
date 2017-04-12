--------------------------------------------------------------------------------
--
--  Program Name: Point Processing
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 4/24/2017
--  
--  Description: This project contains all of the image processing techniques
--    that have been implemented this semester. It includes point processes,
--    neighborhood processes, edge detectors, morphological operations, and
--    other miscellaneous processes.
--  
--------------------------------------------------------------------------------

--LuaIP image processing routines
require "ip"   -- this loads the packed distributable
local viz = require "visual"
local il = require "il"
local pointProc = require "pointProc"
local hist = require "hist"
local segment = require "segment"
local helper = require "helper"
local edge = require "edge"
local neighborhood = require "neighborhood"
local noise = require "noise"
local morph = require "morph"
local morphHelper = require "morphHelper"

--Load images listed on command line
--local imgs = {...}

local imgs = {"Images/sampleTextInverseBold.png", "Images/Skeletonize.png"}
for i, fname in ipairs(imgs) do loadImage(fname) end

local function pointSelector( img, pt )
  local rgb = img:at( pt.y, pt.x )
  io.write( ( "point: (%d,%d) = (%d,%d,%d)\n" ):format( pt.x, pt.y, rgb.r, rgb.g, rgb.b ) );
  return img
end

local function rectSelector( img, r )
  io.write( ( "rect: (%d, %d, %d, %d)\n" ):format( r.x, r.y, r.width, r.height ) );
  return img
end

--Define menu of point process operations
imageMenu("Point Processes",
  {
    {"Grayscale", pointProc.grayscale},
    {"Negate", pointProc.negate},
    {"Posterize", pointProc.posterize,
      {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Brightness", pointProc.brightness, 
      {{name = "levels", type = "number", displaytype = "spin", default = 0, min = -256, max = 256}}},
    {"Contrast Stretch", pointProc.manualContrast,
      {{name = "min", type = "number", displaytype = "spin", default = 64, min = 0, max = 255},
       {name = "max", type = "number", displaytype = "spin", default = 191, min = 0, max = 255}}},
    {"Gamma", pointProc.gamma,
      {{name = "gamma", type = "string", default = "1.0"}}},
    {"Log", pointProc.logScale},
    {"Bitplane Slice", pointProc.slice,
      {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
    {"Disc Pseudocolor", pointProc.distPsuedocolor},
    {"Cont Pseudocolor", pointProc.contPsuedocolor},
    {"Solarize", pointProc.solarize,       
      {{name = "Threshold", type = "number", displaytype = "spin", default = 128, min = 0, max = 255}}},
    {"Inverse Solarize", pointProc.inverseSolarize,       
      {{name = "Threshold", type = "number", displaytype = "spin", default = 128, min = 0, max = 255}}}
  }
)

--Define menu of histogram operations
imageMenu("Histogram processes",
  {
    {"Automated Contrast Stretch", hist.automatedContrast},
    {"Contrast Specify", hist.contrastSpecify,
      {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
       {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}}},
    {"Histogram Display\tCtrl-H", il.showHistogram, hotkey = "C-H"},
    {"Histogram Display RGB\tCtrl-J", il.showHistogramRGB, hotkey = "C-J"},
    {"Histogram Equalization", hist.histogramEqualize},
    {"Histogram Equalize Clip", hist.histogramClipping,
      {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"}}}
  }
)

imageMenu("Neighborhood ops",
  {
    {"Smooth", neighborhood.smooth},
    {"Sharpen", neighborhood.sharpen},
    {"Mean", neighborhood.mean,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Minimum", neighborhood.minimum,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Maximum", neighborhood.maximum,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 3, max = 65}}},
    {"Median+", neighborhood.medianPlus},
    {"Median", il.timed(neighborhood.median),
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Emboss", neighborhood.emboss}
  }
)

imageMenu("Edge detection",
  {
    {"Sobel Edge Mag\tCtrl-E", edge.sobelMag, hotkey = "C-E"},
    {"Sobel Edge Mag/Dir", edge.sobelDir},
    {"Kirsch Edge Mag/Dir", edge.kirsch},
    {"Laplacian", edge.laplacian},
    {"Range", edge.range,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}},
    {"Std Dev", edge.stdDev,
      {{name = "width", type = "number", displaytype = "spin", default = 3, min = 0, max = 65}}}
  }
)

imageMenu("Morphological operations",
  {
    {"Geodesic Dilate\tCtrl-N", morph.geoDilate, hotkey = "C-N",
      {{name = "Mask", type = "string", displaytype = "textbox", default = ".\\Images\\mask.png"},
       {name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
       {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Geodesic Erode\tCtrl-M", morph.geoErode, hotkey = "C-M",
      {{name = "Mask", type = "string", displaytype = "textbox", default = ".\\Images\\mask.png"},
       {name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
       {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Reconstruction by Dilation\tCtrl-Shift-N", morph.recDilate, hotkey = "C-Shift-N",
      {{name = "Mask", type = "string", displaytype = "textbox", default = ".\\Images\\mask.png"},
       {name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
       {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Reconstruction by Erosion\tCtrl-Shift-M", morph.recErode, hotkey = "C-Shift-M",
      {{name = "Mask", type = "string", displaytype = "textbox", default = ".\\Images\\mask.png"},
       {name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
       {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Dilate", morph.dilate,
       {{name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
        {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Erode", morph.erode,
       {{name = "SE Width", type = "number", displaytype = "spin", default = 3, min = 1, max = 65},
        {name = "SE Height", type = "number", displaytype = "spin", default = 3, min = 1, max = 65}}},
    {"Opening by Reconstruction\tCtrl-Alt-M", morph.openRec, hotkey = "C-Alt-M",
       {{name = "SE Width", type = "number", displaytype = "spin", default = 1, min = 1, max = 65},
        {name = "SE Height", type = "number", displaytype = "spin", default = 15, min = 1, max = 65},
        {name = "Number of Erosions", type = "number", displaytype = "spin", default = 1, min = 1, max = 65}}},
    {"Closing by Reconstruction\tCtrl-Alt-N", morph.closeRec, hotkey = "C-Alt-N",
       {{name = "SE Width", type = "number", displaytype = "spin", default = 1, min = 1, max = 65},
        {name = "SE Height", type = "number", displaytype = "spin", default = 15, min = 1, max = 65},
        {name = "Number of Dilations", type = "number", displaytype = "spin", default = 1, min = 1, max = 65}}},
    { "Hole Filling", morph.holeFill },
    { "Border Clearing", morph.borderClearing },
    {"Morph Thin", morph.thinMorph,
      {{name = "n", type = "string", displaytype = "combo", choices = {"4", "8"}, default = "8"}}},
    {"Morph Thin - Weiss", il.thinMorph,
      {{name = "n", type = "string", displaytype = "combo", choices = {"4", "8"}, default = "8"}}},
    {"Morph Thick", morph.thickMorph,
      {{name = "n", type = "string", displaytype = "combo", choices = {"4", "8"}, default = "8"}}},
    { "Zoom In\tCtrl+Z", morphHelper.zoomIn, hotkey = "C-Z" },
    { "Zoom Out\tCtrl+Z", morphHelper.zoomOut, hotkey = "C-X" },
    { "Complement\tCtrl+C", morphHelper.complement, hotkey = "C-C" }
  }
)

--Define menu of segment operations
imageMenu("Misc",
  {
    {"Binary Threshold", segment.threshold,
      {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
    {"Point Selector", pointSelector, {{name="point", type = "point", default = {x=0, y=0}}}},
    {"Rectangle Selector", rectSelector, {{name="rect", type = "rect", default = {x=0,y=0,width=0,height=0}}}}
  }
)

imageMenu("Noise",
  {
    {"Add Impulse Noise", il.impulseNoise,
      {{name = "probability", type = "number", displaytype = "slider", default = 64, min = 0, max = 1000}}},
    {"Add Gaussian noise", il.gaussianNoise,
      {{name = "sigma", type = "number", displaytype = "textbox", default = "16.0"}}},
    {"Out-of-Range Noise Cleaning", noise.noiseClean,
      {{name = "threshold", type = "number", displaytype = "slider", default = 64, min = 0, max = 256}}}
  }
)

--Define help menu
imageMenu("Help",
  {
    { "Help", viz.imageMessage( "Help", helper.HelpMessage ) },
    { "About", viz.imageMessage( "Point Processing Program", "Authors: Matt Dyke and Christian Sieh\nClass: CSC442/542 Digital Image Processing\nDate: Spring 2017" ) },
    {"Debug Console", viz.imageDebug}
  }
)

--Begin program
start()
