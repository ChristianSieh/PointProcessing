--------------------------------------------------------------------------------
--
--  Program Name: Point Processing
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 1/22/2017
--  
--  Description: This program implements basic image processing routines. It
--    provides a GUI where users can open, duplicate, and save images. Various
--    image processing routines can be applied to these images, such as 
--    adjusting brightness, contrast, and colors.
--
--    This file is used as the start file for the program. It defines the 
--    various menus used in the program, including one each for point processes,
--    histogram operations, segmenting operations, and a help menu. Once these
--    menus have been set up, it launches the program.
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

--Load images listed on command line
local imgs = {...}
for i, fname in ipairs(imgs) do loadImage(fname) end

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
      {{name = "Threshold", type = "number", displaytype = "spin", default = 128, min = 0, max = 255}}},
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
      {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"}}},
  }
)

--Define menu of segment operations
imageMenu("Segment",
  {
    {"Binary Threshold", segment.threshold,
      {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
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
