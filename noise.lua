--------------------------------------------------------------------------------
--
--  File Name: noise
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 3/11/2017
--  
--  Description: This file contains the function definitions for the 
--    noise operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local noise = {};


--------------------------------------------------------------------------------
--
--  Function Name: noiseClean
--
--  Description: This function takes all of the neighbors in a 3x3 area and
--               calculates their average. Then the difference between the
--               current pixel value and the average is calculated. If the
--               difference is above the threshold then the pixel's value
--               changes otherwise it remains the same.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    threshold - A threshold level defined by the user that tells if a pixel
--                should be changed, if it falls above the threshold, or stay 
--                it's current value.
--
--  Return: 
--    newImg - The image object after being smoothed
--
--------------------------------------------------------------------------------
local function noiseClean( img, threshold )
  --Convert to grayscale
  il.RGB2YIQ( img );
  
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( 1 ) do
    local average = 0;
    
    --Loop over each neighbor pixel
    for x = -1, 1 do
      for y = -1, 1 do
        if x ~= 0 or y ~= 0 then
          average = average + img:at( r + x, c + y ).i;
        end
      end
    end
    average = average / 8;
    
    --Find difference between current pixel and average of neighbors
    local diff = math.abs( img:at(r,c).i - average );
    
    --Apply out-of-range transformation
    if diff < threshold then
      newImg:at(r,c).i = img:at(r,c).i;
    else
      newImg:at(r,c).i = average;
    end
  end
  
  --Covert back to color
  il.YIQ2RGB( newImg );
  
  return newImg;
end
noise.noiseClean = noiseClean;

--Return table of noise functions
return noise;  