--------------------------------------------------------------------------------
--
--  File Name: misc
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/10/2017
--  
--  Description: This file contains the function definitions for the 
--    miscellaneous operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local misc = {};


--------------------------------------------------------------------------------
--
--  Function Name: Impulse Noise
--
--  Description: 
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function impulseNoise( img, lvl )
  
  return img;
  
end
misc.impulseNoise = impulseNoise;

--------------------------------------------------------------------------------
--
--  Function Name: Gaussian Noise
--
--  Description: 
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function gaussNoise( img, lvl )
  
  return img;
  
end
misc.gaussNoise = gaussNoise;

--Return table of miscellaneous functions
return misc;  