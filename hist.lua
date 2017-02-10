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
--  Function Name: automatedContrast
--
--  Description: This function performs contrast stretching on the given
--    image. The stretching is applied between an upper and lower bounds, which 
--    correspond the highest and lowest pixel intensity values in the image.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function automatedContrast( img )
  --Get historgram of converted image
  local histogram = helper.computeHistogram( img, "yiq" );
  
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
--  Function Name: Contrast Specify
--
--  Description: This function performs contrast stretching on the given
--    image. The stretching is applied between an upper and lower bounds, which 
--    correspond the highest and lowest pixel intensity values in the image, 
--    ignoring a percentage of the total pixels, as specified by the user.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--    lowerBound - Percentage of dark pixels to ignore when finding lower bound
--    upperBound - Percentage of light pixels to ignore when finding upper bound
--
--------------------------------------------------------------------------------
local function contrastSpecify( img, lowerBound, upperBound )
  --Get historgram of converted image
  local histogram = helper.computeHistogram( img, "yiq" );
  
  --Find number of pixels to skip
  local lowerPixel = img.height * img.width * lowerBound / 100;
  local upperPixel = img.height * img.width * ( 100 - upperBound  ) / 100;
  
  --Find minimum value in histogram
  local temp = 0;
  local lowerSum = 0;
  while( lowerSum < lowerPixel and temp < 255) do
    lowerSum = lowerSum + histogram[temp];
    temp = temp + 1;
  end  
  local low = temp;
  
  --Find maximum value in histogram
  temp = 255;
  local upperSum = 0;
  while( upperSum < upperPixel and temp > 0) do
    upperSum = upperSum + histogram[temp];
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
hist.contrastSpecify = contrastSpecify;


--------------------------------------------------------------------------------
--
--  Function Name: histogramEqualize
--
--  Description: This function performs histogram equalization. This involves 
--    trying to flatten the image's histogram of intensities as much as possible
--    by spreading out the most prevalent intensities to a wider output range.
--
--  Parameters:
--   img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function histogramEqualize( img )
  --Get historgram of converted image
  local histogram = helper.computeHistogram( img, "yiq" );
  
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Create equalization transformation
  local lookUp = {};
  lookUp[0] = histogram[0];
  for i = 1, 255 do
    lookUp[i] = lookUp[i-1] + histogram[i];
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
hist.histogramEqualize = histogramEqualize;


--------------------------------------------------------------------------------
--
--  Function Name: histogramClipping
--
--  Description: This function performs histogram equalization with clipping. 
--    This involves trying to flatten the image's histogram of intensities as
--    much as possible by spreading out the most prevalent intensities to a
--    wider output range. A certain percentage of pixels is ignored in order
--    to reduce the effect of noise on the image.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    clipPercentage - Percent of pixels to ignore when finding the min and max
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function histogramClipping( img, clipPercentage )
  --Get historgram of converted image
  local histogram = helper.computeHistogram( img, "yiq" );
  
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Clip histogram values
  local max = math.floor( img.height * img.width * ( clipPercentage / 100 ) );
  local num_pixels = 0;
  for i = 0, 255 do
    if histogram[i] > max then
      histogram[i] = max;
    end
    num_pixels = num_pixels + histogram[i];
  end
  
  --Create equalization transformation
  local lookUp = {};
  lookUp[0] = histogram[0];
  for i = 1, 255 do
    lookUp[i] = lookUp[i-1] + histogram[i];
  end
  for i = 0, 255 do
    lookUp[i] = lookUp[i] * 255 / num_pixels;
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
hist.histogramClipping = histogramClipping;


--Return table of histogram functions
return hist;  