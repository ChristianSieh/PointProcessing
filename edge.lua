--------------------------------------------------------------------------------
--
--  File Name: edge
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/10/2017
--  
--  Description: This file contains the function definitions for the 
--    edge detection operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");
local helper = require("helper");

--Table to hold the point process functions
local edge = {};

--Sobel filters
local sobelGXPosFilter = { { -1, -2, -1 }, { 0, 0, 0 }, { 1, 2, 1 } };
local sobelGYPosFilter = { { -1, 0, 1 }, { -2, 0, 2 }, { -1, 0, 1 } };
local sobelGXNegFilter = { { 1, 2, 1 }, { 0, 0, 0 }, { -1, -2, -1 } };
local sobelGYNegFilter = { { 1, 0, -1 }, { 2, 0, -2 }, { 1, 0, -1 } };
  

--------------------------------------------------------------------------------
--
--  Function Name: Sobel Edge Magnitude
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
local function sobelMag( img )  
  --Covert to grayscale before applying filters
  il.RGB2YIQ( img );
  
  --Apply Sobel edge detectors as convolution filters
  local gxPos = helper.applyConvolutionFilter( img, sobelGXPosFilter, 3 );
  local gyPos = helper.applyConvolutionFilter( img, sobelGYPosFilter, 3 );
  local gxNeg = helper.applyConvolutionFilter( img, sobelGXNegFilter, 3 );
  local gyNeg = helper.applyConvolutionFilter( img, sobelGYNegFilter, 3 );
  
  --Loop over each pixel in the image
  local mag = img:clone();
  for r,c in mag:pixels() do
    --Combine results from Sobel filters
    local temp = math.sqrt( gxPos:at(r,c).r * gxPos:at(r,c).r
                          + gyPos:at(r,c).r * gyPos:at(r,c).r
                          + gxNeg:at(r,c).r * gxNeg:at(r,c).r
                          + gyNeg:at(r,c).r * gyNeg:at(r,c).r );
    
    --Trim result
    if(temp > 255) then
      temp = 255;
    elseif(temp < 0) then
      temp = 0;
    end
    
    mag:at(r,c).y = temp;
  end
  
  --Covert back to color
  il.YIQ2RGB( mag );
  
  return mag;
end
edge.sobelMag = sobelMag;


--------------------------------------------------------------------------------
--
--  Function Name: Sobel Edge Direction
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
local function sobelDir( img, lvl )
  --Covert to grayscale before applying filters
  il.RGB2YIQ( img );
  
  --Apply Sobel edge detectors as convolution filters
  local gxPos = helper.applyConvolutionFilter( img, sobelGXPosFilter, 3 );
  local gyPos = helper.applyConvolutionFilter( img, sobelGYPosFilter, 3 );
  local gxNeg = helper.applyConvolutionFilter( img, sobelGXNegFilter, 3 );
  local gyNeg = helper.applyConvolutionFilter( img, sobelGYNegFilter, 3 );
  
  --Create images for use later
  local mag = img:clone();
  local dir = image.flat( img.width, img.height );
  local gx = image.flat( img.width, img.height );
  local gy = image.flat( img.width, img.height );
  
  --Combine opposing Sobel filters
  for r,c in img:pixels() do
    gx:at(r,c).y = gxPos:at(r,c).y + gxNeg:at(r,c).y;
    gy:at(r,c).y = gyPos:at(r,c).y + gyNeg:at(r,c).y;
  end
  
  --Loop over each pixel in the image
  for r,c in mag:pixels() do
    --Find direction of strongest edge
    local temp = math.atan2( gyPos:at(r,c).y, gxPos:at(r,c).y ) * ( 255 / 1.57 );
    dir:at(r,c).r = temp;
    dir:at(r,c).g = temp;
    dir:at(r,c).b = temp;
    
    --Combine results from Sobel filters
    temp = math.sqrt( gx:at(r,c).y * gx:at(r,c).y
                    + gy:at(r,c).y * gy:at(r,c).y );
    
    --Trim result
    if(temp > 255) then
      temp = 255;
    elseif(temp < 0) then
      temp = 0;
    end
    
    --Apply restuls from Sobel transformations
    mag:at(r,c).r = temp;
    mag:at(r,c).g = temp;
    mag:at(r,c).b = temp;
  end
  
  --Covert back to color
  il.YIQ2RGB( img );
  
  return img, mag, dir;
end
edge.sobelDir = sobelDir;


--------------------------------------------------------------------------------
--
--  Function Name: Kirsch Edge Magnitude & Direction
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
local function kirsch( img, lvl )
  --Set up initial Kirsch filter
  local filter = { { -3, -3, -3 }, { -3, 0, -3 }, { 5, 5, 5 } };
  
  --Create images for use later
  local mag = img:clone();
  local dir = image.flat( img.width, img.height );
  
  --Covert to grayscale before applying filters
  il.RGB2YIQ( img );
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in img:pixels( 1 ) do
    local max_value = -1;
    local max_index = 0;
    
    --Loop eight times, once for each Kirsch filter
    for i = 1, 8 do
      local temp = 0;
      --At each pixel, loop over neighbors
      for x = 1, 3 do
        for y = 1, 3 do
          --Apply current filter
          temp = temp + ( img:at(r + x-2, c + y-2 ).i * filter[x][y] );
        end
      end
      
      --Check if biggest response so far
      if temp > max_value then
        max_value = temp;
        max_index = i;
      end
      
      --Rotate to create next Kirsch filter
      filter = helper.rotateFilter( filter );
    end
    
    --Scale result
    max_value = max_value / 3;
    
    --Trim result
    if(max_value > 255) then
      max_value = 255;
    elseif(max_value < 0) then
      max_value = 0;
    end
    
    --Apply restuls from Kirsch transformations
    mag:at(r,c).r = max_value;
    mag:at(r,c).g = max_value;
    mag:at(r,c).b = max_value;
    
    if max_value > 0 then
      dir:at(r,c).r = ( ( max_index - 1 - 2 ) % 8 ) * 32;
      dir:at(r,c).g = ( ( max_index - 1 - 2 ) % 8 ) * 32;
      dir:at(r,c).b = ( ( max_index - 1 - 2 ) % 8 ) * 32;
    else
      dir:at(r,c).r = 0;
      dir:at(r,c).g = 0;
      dir:at(r,c).b = 0;
    end
  end
    
  --Covert back to color
  il.YIQ2RGB( img );
  
  return img, mag, dir;
end
edge.kirsch = kirsch;


--------------------------------------------------------------------------------
--
--  Function Name: Laplacian
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
local function laplacian( img, lvl )
  --Smoothing filter
  local filter = { { -1, -1, -1 }, { -1, 8, -1 }, { -1, -1, -1 } };
  
  --Covert to grayscale before applying filter
  il.RGB2YIQ( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
edge.laplacian = laplacian;


--------------------------------------------------------------------------------
--
--  Function Name: range
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
local function range( img, filterSize )
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Convert to grayscale to find intensities
  il.RGB2YIQ( img );
  
  --Indexing for traversing neighbors
  local index = ( filterSize - 1 ) / 2;
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( index ) do
    local max = -1;
    local min = 1000;
    
    --Loop over each neighbor pixel
    for x = -index, index do
      for y = -index, index do
        --Check if current neighbor is larger than current max
        if img:at( r + x, c + y ).i > max then
          max = img:at( r + x, c + y ).i;
        end
        --Check if current neighbor is smaller than current min
        if img:at( r + x, c + y ).i < min then
          min = img:at( r + x, c + y ).i;
        end
      end
    end
    
    --Trim result
    local temp = max - min;
    if(temp > 255) then
      temp = 255;
    elseif(temp < 0) then
      temp = 0;
    end
    
    --Apply range transformation
    newImg:at(r,c).r = temp;
    newImg:at(r,c).g = temp;
    newImg:at(r,c).b = temp;
  end
  
  return newImg;
end
edge.range = range;


--------------------------------------------------------------------------------
--
--  Function Name: Standard Deviation
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
local function stdDev( img, filterSize )
  --Convert to grayscale to find mean intensity
  il.RGB2YIQ( img );
  
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing for traversing neighbors
  local index = ( filterSize - 1 ) / 2;
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in img:pixels( index ) do
    local mean = 0;
    local diff = 0;
    local sqDiff = 0;
    local variance = 0;
    
    --Loop over each neighbor pixel to calculate sample mean for neighborhood
    for x = -index, index do
      for y = -index, index do
        mean = mean + img:at( r + x, c + y ).i;
      end
    end
    mean = mean / ( filterSize * filterSize );
    
    --Loop over each neighbor pixel
    for x = -index, index do
      for y = -index, index do
        diff = img:at( r + x, c + y ).i - mean;
        sqDiff = sqDiff + ( diff * diff );
      end
    end
    
    --Calculate standard deviation
    variance = sqDiff / ( filterSize * filterSize );
    newImg:at(r,c).i = math.sqrt( variance );
  end
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
edge.stdDev = stdDev;


--Return table of edge functions
return edge;