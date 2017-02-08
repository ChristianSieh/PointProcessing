--------------------------------------------------------------------------------
--
--  File Name: hist
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

--Define already loaded files
local il = require("il");
local helper = require("helper");

--Table to hold the point process functions
local hist = {};

--------------------------------------------------------------------------------
--
-- Function Name: automatedContrast
--
-- Description: 
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function automatedContrast( img )
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Get historgram of converted image
  local histogram = il.histogram( img, "yiq" );
  
  --Find minimum value in histogram
  local temp = 0;
  while( histogram[temp] == 0 and temp < 255) do
    temp = temp + 1;
  end  
  local low = temp;
  
  --Find maximum value in histogram
  temp = 255;
  while( histogram[temp] == 0 and temp > 0) do
    temp = temp - 1;
  end  
  local high = temp;  
  
  --Call helper function to perform contrast stretching with specified endpoints
  img = helper.performContrastStretch( img, low, high );
  
  --Convert back to RGB
  img = il.YIQ2RGB(img);
  
  return img;
end
hist.automatedContrast = automatedContrast;


--------------------------------------------------------------------------------
--
-- Function Name: Contrast Specify
--
-- Description:
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function contrastSpecify( img )
  return image.flat( img.width, img.height );
end
hist.contrastSpecify = contrastSpecify;

--------------------------------------------------------------------------------
--
-- Function Name: Histogram Display
--
-- Description:
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function histDisplay( img )
  return image.flat( img.width, img.height );
end
hist.histDisplay = histDisplay;

--------------------------------------------------------------------------------
--
-- Function Name: Histogram Equalize RGB
--
-- Description:
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function equalizeRGB( img )
  return image.flat( img.width, img.height );
end
hist.equalizeRGB = equalizeRGB;

--------------------------------------------------------------------------------
--
-- Function Name: Histogram Equalize Clip
--
-- Description:
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function equalizeClip( img )
  return image.flat( img.width, img.height );
end
hist.equalizeClip = equalizeClip;


--Return table of histogram functions
return hist;  