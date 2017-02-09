--------------------------------------------------------------------------------
--
--  File Name: helper
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 1/22/2017
--  
--  Description: 
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local helper = {};


--------------------------------------------------------------------------------
--
-- Function Name: performContrastStretch
--
-- Description: 
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--   low - User selected lower endpoint for contrast stretch
--   high - User selected upper endpoint for contrast stretch
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function performContrastStretch( img, low, high )
  local lookUp = {};

  --Create look up table
  for i = 0, 255 do
    --Calculate pixel value after contrast stretching, using formula from book
    lookUp[i] = ( 255 / ( high - low ) ) * ( i - low );
    lookUp[i] = math.floor( lookUp[i] + 0.5 );

    --Clip high and low pixel values that are out of bounds
    if lookUp[i] > 255 then
      lookUp[i] = 255;
    end
    if lookUp[i] < 0 then
      lookUp[i] = 0;
    end
  end

  --Loop over each pixel
  for r,c in img:pixels() do    
    --Assign new pixel value
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end

  return img;
end
helper.performContrastStretch = performContrastStretch;


--------------------------------------------------------------------------------
--
-- Function Name: computeHistogram
--
-- Description: 
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--   model - What color model to produce the histogram for
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function computeHistogram( img, model )
  --Convert image based on model
  if( model == "yiq" or model == "YIQ" ) then
    img = il.RGB2YIQ(img);
  elseif( model == "yuv" or model == "YUV" ) then
    img = il.RGB2YUV(img);
  elseif( model == "ihs" or model == "IHS" ) then
    img = il.RGB2IHS(img);
  elseif( model ~= "rgb" and model ~= "RGB" ) then
    --Invalid option
    return nil;
  end

  local histogram = {};

  --If RGB histograms requested
  if( model == "rgb" or model == "RGB" ) then
    --Initialize red, blue, & gree histograms
    for i = 0, 2 do
      histogram[i] = {};
      for j = 0, 255 do
        histogram[i][j] = 0;
      end
    end
    
    --Loop over pixels
    for r,c in mig:pixels() do
      histogram[0][img:at(r,c).r] = histogram[0][img:at(r,c).r] + 1;
      histogram[1][img:at(r,c).g] = histogram[1][img:at(r,c).g] + 1;
      histogram[2][img:at(r,c).b] = histogram[2][img:at(r,c).b] + 1;
    end
    
  --Else if YIQ, YUV, or IHS histogram requested
  else
    --Initialize histogram
    for i = 0, 255 do
      histogram[i] = 0;
    end

    --Loop over pixels
    for r,c in img:pixels() do
      histogram[img:at(r,c).y] = histogram[img:at(r,c).y] + 1;
    end
  end
  
  --Convert image back
  if( model == "yiq" or model == "YIQ" ) then
    img = il.YIQ2RGB(img);
  elseif( model == "yuv" or model == "YUV" ) then
    img = il.YUV2RGB(img);
  elseif( model == "ihs" or model == "IHS" ) then
    img = il.IHS2RGB(img);
  end

  --Return histogram(s)
  return histogram;
end
helper.computeHistogram = computeHistogram;

--Return table of helper functions
return helper;  