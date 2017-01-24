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

--Load images listed on command line
local imgs = {...}
for i, fname in ipairs(imgs) do loadImage(fname) end

--Define menu of point process operations
imageMenu("Point Processes",
  {
    {"Grayscale", pointProc.grayscale}
  }
)

--Begin program
start()
