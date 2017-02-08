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
  
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
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
  return il.showHistogram( img );
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
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Get historgram of converted image
  local histogram = il.histogram( img, "yiq" );
  
  --Get intensity counts
  local counts = {};
  for i = 0, 255 do
    counts[i] = 0;
  end
  for r, c in img:pixels() do
    counts[img:at(r,c).y] = counts[img:at(r,c).y] + 1;
  end
  
  --Create equalization transformation
  local lookUp = {};
  lookUp[0] = counts[0];
  for i = 1, 255 do
    lookUp[i] = lookUp[i-1] + counts[i];
  end
  for i = 0, 255 do
    lookUp[i] = lookUp[i] * 255 / ( img.height * img.width );
    lookUp[i] = math.floor( lookUp[i] + 0.5 );
  end
  
  --Apply equalization transformation
  for r,c in img:pixels() do
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end
  
  --Convert back to RGB
  img = il.YIQ2RGB(img);
  
  return img;
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
local function equalizeClip( img, clipPercentage )
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Get historgram of converted image
  local histogram = il.histogram( img, "yiq" );
  
  --Get intensity counts
  local counts = {};
  local max = math.floor( img.height * img.width * clipPercentage );
  local diff = 0;
  for i = 0, 255 do
    counts[i] = 0;
  end
  for r, c in img:pixels() do
    counts[img:at(r,c).y] = counts[img:at(r,c).y] + 1;
  end
  for i = 0, 255 do
    if counts[i] > max then
      diff = diff + ( counts[i] - max );
      counts[i] = max;
    end
  end
  
  --Create equalization transformation
  local lookUp = {};
  lookUp[0] = counts[0];
  for i = 1, 255 do
    lookUp[i] = lookUp[i-1] + counts[i];
  end
  for i = 0, 255 do
    lookUp[i] = lookUp[i] * 255 / ( ( img.height * img.width ) - diff );
    lookUp[i] = math.floor( lookUp[i] + 0.5 );
  end
  
  --Apply equalization transformation
  for r,c in img:pixels() do
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end
  
  --Convert back to RGB
  img = il.YIQ2RGB(img);
  
  return img;
end
hist.equalizeClip = equalizeClip;


--Return table of histogram functions
return hist;  