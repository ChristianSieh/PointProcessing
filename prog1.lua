--------------------------------------------------------------------------------
--
--  Program Name: Point Processing
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 1/22/2017
--  
--  Description:
--  
--------------------------------------------------------------------------------

--LuaIP image processing routines
require "ip"   -- this loads the packed distributable
local viz = require "visual"
local il = require "il"
local pointProc = require "pointProc"
local hist = require "hist"
local misc = require "misc"

--Load images listed on command line
local imgs = {...}
for i, fname in ipairs(imgs) do loadImage(fname) end

--Define menu of point process operations
imageMenu("Point Processes",
  {
    {"Grayscale", pointProc.grayscale},
    {"Grayscale - Weiss", il.grayscale},
    {"Negate", pointProc.negate},
    {"Negate - Weiss", il.negate},
    {"Posterize", pointProc.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Posterize - Weiss", il.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Brightness", pointProc.brightness, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Brightness - Weiss", il.brighten, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Contrast Stretch", pointProc.manualContrast,
      {{name = "min", type = "number", displaytype = "spin", default = 64, min = 0, max = 255},
       {name = "max", type = "number", displaytype = "spin", default = 191, min = 0, max = 255}}},
    {"Contrast Stretch - Weiss", il.contrastStretch,
      {{name = "min", type = "number", displaytype = "spin", default = 64, min = 0, max = 255},
       {name = "max", type = "number", displaytype = "spin", default = 191, min = 0, max = 255}}},
    {"Gamma", pointProc.gamma, {{name = "gamma", type = "string", default = "1.0"}}},
    {"Gamma - Weiss", il.gamma, {{name = "gamma", type = "string", default = "1.0"}}},
    {"Log", pointProc.logScale},
    {"Log - Weiss", il.logscale},
    {"Bitplane Slice", pointProc.slice, {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
    {"Bitplane Slice - Weiss", il.slice, {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
    {"Disc Pseudocolor", pointProc.distPsuedocolor},
    {"Disc Pseudocolor - Weiss", il.pseudocolor2},
    {"Cont Pseudocolor", pointProc.contPsuedocolor},
    {"Cont Pseudocolor - Weiss", il.pseudocolor1},
    {"Solarize", pointProc.solarize,       
      {{name = "Threshold", type = "number", displaytype = "spin", default = 128, min = 0, max = 255}}},
    {"Inverse Solarize", pointProc.inverseSolarize,       
      {{name = "Threshold", type = "number", displaytype = "spin", default = 128, min = 0, max = 255}}},
  }
)

imageMenu("Histogram processes",
  {
    {"Automated Contrast Stretch", hist.automatedContrast},
    {"Automated Contrast Stretch - Weiss", il.stretch},
    {"Contrast Specify", hist.contrastSpecify,
      {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
        {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}}},
    {"Contrast Specify - Weiss", il.stretchSpecify,
      {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
        {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}}},
    --{"Histogram Equalize YIQ - Weiss", il.equalizeYIQ},
    --{"Histogram Equalize YUV - Weiss", il.equalizeYUV},
    --{"Histogram Equalize IHS - Weiss", il.equalizeIHS},
    {"Histogram Display\tCtrl-H", hist.histDisplay, hotkey = "C-H"},
    {"Histogram Display RGB\tCtrl-J", il.showHistogramRGB, hotkey = "C-J"},
    {"Histogram Equalization", hist.equalizeRGB},
    {"Histogram Equalization - Weiss", il.equalizeRGB},
    {"Histogram Equalize Clip", hist.equalizeClip, {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"}}},
    {"Histogram Equalize Clip - Weiss", il.equalizeClip, {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"}}},
    --{"Display Greyscale Histogram - Weiss", il.showHistogram},
  }
)

imageMenu("Misc",
  {
    {"Binary Threshold", misc.threshold, {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
    {"Binary Threshold - Wiess", il.threshold, {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
  }
)

imageMenu("Help",
  {
    { "Help", viz.imageMessage( "Help", "Abandon all hope, ye who enter here..." ) },
    { "About", viz.imageMessage( "LuaIP Demo " .. viz.VERSION, "Authors: JMW and AI\nClass: CSC442/542 Digital Image Processing\nDate: Spring 2017" ) },
    {"Debug Console", viz.imageDebug}
  }
)

--Begin program
start()
