--------------------------------------------------------------------------------
--
--  File Name: misc
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 1/22/2017
--  
--  Description: This file contains the function definitions for the histogram
--    operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local segment = {};

--------------------------------------------------------------------------------
--
-- Function Name: Binary Threshold
--
-- Description: Binary thresholding take a threshold specified by the user
--              and every intensity below the threshold gets converted
--              to black and every value above gets converted to white.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--   lvl - The threshold specified by the user. Any intensity below the threshold
--         is set to black while anything above is set to white.
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function threshold( img, lvl )
  -- Compute LUT
  local LUT = {};
  
  for i = 0, 255 do
    if i < lvl then
      LUT[i] = 0;
    else
      LUT[i] = 255;
    end
  end
  
  img = il.RGB2IHS(img);
  
  --Loop over all pixels
  for r,c in img:pixels() do
    img:at(r,c).i = LUT[img:at(r,c).i];
    img:at(r,c).s = 0;
  end
  
  img = il.IHS2RGB(img);
  
  return img;
  
end
segment.threshold = threshold;

--Return table of histogram functions
return segment;  