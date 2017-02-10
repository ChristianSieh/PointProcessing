--------------------------------------------------------------------------------
--
--  File Name: neighborhood
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/10/2017
--  
--  Description: This file contains the function definitions for the 
--    neighborhood operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local neighborhood = {};

--------------------------------------------------------------------------------
--
--  Function Name: Smooth
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
local function smooth( img, lvl )
  
  return img;
  
end
neighborhood.smooth = smooth;

--------------------------------------------------------------------------------
--
--  Function Name: Sharpen
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
local function sharpen( img, lvl )
  
  return img;
  
end
neighborhood.sharpen = sharpen;

--------------------------------------------------------------------------------
--
--  Function Name: Mean
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
local function mean( img, lvl )
  
  return img;
  
end
neighborhood.mean = mean;

--------------------------------------------------------------------------------
--
--  Function Name: Minimum
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
local function minimum( img, lvl )
  
  return img;
  
end
neighborhood.minimum = minimum;

--------------------------------------------------------------------------------
--
--  Function Name: Maximum
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
local function maximum( img, lvl )
  
  return img;
  
end
neighborhood.maximum = maximum;

--------------------------------------------------------------------------------
--
--  Function Name: Median Plus
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
local function medianPlus( img, lvl )
  
  return img;
  
end
neighborhood.medianPlus = medianPlus;

--------------------------------------------------------------------------------
--
--  Function Name: Median
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
local function median( img, lvl )
  
  return img;
  
end
neighborhood.median = median;

--------------------------------------------------------------------------------
--
--  Function Name: Emboss
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
local function emboss( img, lvl )
  
  return img;
  
end
neighborhood.emboss = emboss;

--Return table of miscellaneous functions
return neighborhood;  