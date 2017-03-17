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
--  Description: This function uses a 3x3 filter with convolution to cause a
--               weighted averaging which smoothens the image.
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
  il.RGB2YIQ( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
neighborhood.smooth = smooth;


--------------------------------------------------------------------------------
--
--  Function Name: Sharpen
--
--  Description: This function uses a 3x3 filter with convolution to cause a
--               sharpening of the image.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    newImg - The image object after being sharpened
--
--------------------------------------------------------------------------------
local function sharpen( img )
  --Sharpening filter
  local filter = { { 0, -1, 0 }, { -1, 5, -1 }, { 0, -1, 0 } };
  
  --Covert to grayscale before applying filter
  il.RGB2YIQ( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
neighborhood.sharpen = sharpen;


--------------------------------------------------------------------------------
--
--  Function Name: Mean
--
--  Description: This function allows the user to specify an n sized neighborhood,
--               and each pixel in this neighborhood is used to calculate a mean
--               that replaces the pixel.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    filterSize - width & height of the filter to be applied
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
  if filterSize % 2 == 0 then
    filterSize = filterSize + 1;
  end
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
--  Description: This function allows the user to specify an n sized neighborhood,
--               and this the minimum value is taken from this neighborhood and
--               assigned to the pixel.
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    filterSize - width & height of the filter to be applied
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
  if filterSize % 2 == 0 then
    filterSize = filterSize + 1;
  end
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
--  Description: This function allows the user to specify an n sized neighborhood,
--               and this the maximum value is taken from this neighborhood and
--               assigned to the pixel.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    filterSize - width & height of the filter to be applied
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
  if filterSize % 2 == 0 then
    filterSize = filterSize + 1;
  end
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
--  Description: This function uses a plus shaped median filter to pick which
--               pixels in the neighborhood to use for rank order. After being
--               sorted, the middle sorted pixel is used to replace the current
--               pixel.
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
  il.RGB2YIQ( img );
  
  --Apply rank-order filter
  newImg = helper.applyRankOrderFilter( img, filter, 3 );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
neighborhood.medianPlus = medianPlus;


--------------------------------------------------------------------------------
--
--  Function Name: Median
--
--  Description: This function uses an n sized median filter to pick which
--               pixels in the neighborhood to use for rank order. After being
--               sorted, the middle sorted pixel is used to replace the current
--               pixel.
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
  --Adjust filter size for even filters
  if filterSize % 2 == 0 then
    filterSize = filterSize + 1;
  end
  
  --Create filter
  local filter = {};
  for i = 1, filterSize do
    filter[i] = {};
    for j = 1, filterSize do
      filter[i][j] = 1;
    end
  end
  
  --Covert to grayscale before applying filter
  il.RGB2YIQ( img );
  
  --Apply rank-order filter
  newImg = helper.applyRankOrderFilter( img, filter, filterSize );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
neighborhood.median = median;


--------------------------------------------------------------------------------
--
--  Function Name: Emboss
--
--  Description: This function uses a 3x3 filter with convolution to cause an
--               embossing effect on the image.
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
  local filter = { { 1, 0, 0 }, { 0, 0, 0 }, { 0, 0, -1 } };
  
  --Covert to grayscale before applying filter
  il.RGB2YIQ( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3, true );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
neighborhood.emboss = emboss;


--Return table of miscellaneous functions
return neighborhood;  