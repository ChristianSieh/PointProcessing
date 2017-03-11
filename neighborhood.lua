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
local helper = require("helper");

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
--    newImg - The image object after being smoothed
--
--------------------------------------------------------------------------------
local function smooth( img )
  --Smoothing filter
  local filter = { { 1/16, 2/16, 1/16 }, { 2/16, 4/16, 2/16 }, { 1/16, 2/16, 1/16 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after being sharpened
--
--------------------------------------------------------------------------------
local function sharpen( img, lvl )
  --Sharpening filter
  local filter = { { 0, -1, 0 }, { -1, 5, -1 }, { 0, -1, 0 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function mean( img, filterSize )
  --Convert to grayscale to find mean intensity
  il.RGB2YIQ( img );
  
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing for traversing neighbors
  local index = ( filterSize - 1 ) / 2;
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( index ) do
    local mean = 0;
    
    --Loop over each neighbor pixel
    for x = -index, index do
      for y = -index, index do
        mean = mean + img:at( r + x, c + y ).i;
      end
    end
    
    --Apply mean transformation
    newImg:at(r,c).i = mean / ( filterSize * filterSize );
  end
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function minimum( img, filterSize )
  --Convert to grayscale to find minimum intensity
  il.RGB2YIQ( img );
  
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing for traversing neighbors
  local index = ( filterSize - 1 ) / 2;
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( index ) do
    local min = 256;
    
    --Loop over each neighbor pixel
    for x = -index, index do
      for y = -index, index do
        if img:at( r + x, c + y ).i < min then
          min = img:at( r + x, c + y ).i;
        end
      end
    end
    
    --Apply minimum transformation
    newImg:at(r,c).i = min;
  end
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function maximum( img, filterSize )
  --Convert to grayscale to find maximum intensity
  il.RGB2YIQ( img );
  
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing for traversing neighbors
  local index = ( filterSize - 1 ) / 2;
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( index ) do
    local max = -1;
    
    --Loop over each neighbor pixel
    for x = -index, index do
      for y = -index, index do
        if img:at( r + x, c + y ).i > max then
          max = img:at( r + x, c + y ).i;
        end
      end
    end
    
    --Apply maximum transformation
    newImg:at(r,c).i = max;
  end
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function medianPlus( img )
  local filter = { { 0, 1, 0 }, { 1, 1, 1 }, { 0, 1, 0 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply rank-order filter
  newImg = helper.applyRankOrderFilter( img, filter, 3 );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
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
--    filterSize - width & height of the filter to be applied
--
--  Return: 
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function median( img, filterSize )
  --Create filter
  local filter = {};
  for i = 1, filterSize do
    filter[i] = {};
    for j = 1, filterSize do
      filter[i][j] = 1;
    end
  end
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply rank-order filter
  newImg = helper.applyRankOrderFilter( img, filter, filterSize );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
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
--    newImg - The image object after having the process performed upon it
--
--------------------------------------------------------------------------------
local function emboss( img )
  --Embossing filter
  local filter = { { 0, 0, 0 }, { 0, 1, 0 }, { 0, 0, -1 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3, true );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
end
neighborhood.emboss = emboss;


--Return table of miscellaneous functions
return neighborhood;  