--------------------------------------------------------------------------------
--
--  File Name: helper
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/3/2017
--  
--  Description: This file contains the helper functions that are used in other
--    modules in the program. These functions are not used directly in the 
--    program menus, but are small functions that help promote code reuse in
--    the rest of the program. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local helper = {};


--------------------------------------------------------------------------------
--
--  Function Name: performContrastStretch
--
--  Description: This function provides contrast stretching on the given image 
--    from the lower endpoint to the upper endpoint. It creates a lookup table
--    to store the transformation, and then loops over the image, applying the
--    transformation.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    low - User selected lower endpoint for contrast stretch
--    high - User selected upper endpoint for contrast stretch
--
--  Return: 
--    img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function performContrastStretch( img, low, high )
  local lookUp = {};    --Lookup Table to store transformation information

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
--  Function Name: computeHistogram
--
--  Description: This function computes the histogram of a given image. It 
--    supports multiple image color models, such as RGB, YIQ, YUV, and IHS. It
--    begins by converting the image if necessary to the correct model. It then
--    steps through each pixel in the image, tallying up the total number of
--    pixels for each intensity. Finally, the image is converted back and the
--    histogram is returned.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    model - What color model to produce the histogram for
--
--  Return: 
--    histogram - Table with counts the pixels for each intensity value
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

  local histogram = {};    --Table to store histogram counts

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


--------------------------------------------------------------------------------
--
-- Function Name: contPseudoLUT
--
-- Description: This function is just meant to clean up the continiuous pseudocolor
--              function. It takes the next value we are going for and if it's
--              greater than the current color value we increase by 8, if it's
--              less than we decrease by 8, otherwise it stays the same.
--
-- Parameters:
--   val - The current r, g, or b value
--   LUT - The look up table where we will store our values
--   i - The level we are on
--   j - The pixel in the level we are on
--
-- Return: 
--   LUT - An updated look up table for either the r, g, or b channel
--
--------------------------------------------------------------------------------
local function contPseudoLUT( val, LUT, i, j )

  if val[i + 1] ~= nil then
    if val[i + 1] > val[i] then
      LUT[j + ((i - 1) * 32)] = (8 * (j + 1)) - 1; -- If we are increasing then we add 8
    elseif val[i + 1] < val[i] then
      LUT[j + ((i - 1) * 32)] = 255 - (8 * j); -- If we are decreasing then we add 8
    else
      LUT[j + ((i - 1) * 32)] = val[i]; -- If we aren't changing then we can just set the value
    end
  end

  --Return look up table
  return LUT;
end
helper.contPseudoLUT = contPseudoLUT;


--Return table of helper functions
return helper;  