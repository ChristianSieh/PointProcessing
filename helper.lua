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
    for r,c in img:pixels() do
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


--------------------------------------------------------------------------------
--
-- Function Name: eightWay
--
-- Description: 
--
-- Parameters:
--   img - 
--   filter - 
--   num - 
--
-- Return: 
--   img - 
--
--------------------------------------------------------------------------------
local function eightWay( img, filter, num)
  local temp;

  img = il.RGB2YIQ(img);

  for r,c in img:pixels(1) do
    -- UP LEFT
    temp = filter[1] * img:at(r - 1, c - 1).y;
    -- UP
    temp = temp + filter[2] * img:at(r - 1, c).y;
    -- UP RIGHT
    temp = temp + filter[3] * img:at(r - 1, c).y;
    -- RIGHT
    temp = temp + filter[4] * img:at(r, c + 1).y;
    -- MIDDLE
    temp = temp + filter[5] * img:at(r, c).y;
    -- DOWN RIGHT
    temp = temp + filter[6] * img:at(r + 1, c + 1).y;
    -- DOWN
    temp = temp + filter[7] * img:at(r + 1, c).y;
    -- DOWN LEFT
    temp = temp + filter[8] * img:at(r + 1, c - 1).y;
    -- LEFT
    temp = temp + filter[9] * img:at(r, c - 1).y;
    
    temp = temp * num
    
    if(temp > 255) then
      temp = 255;
    elseif(temp < 0) then
      temp = 0;
    end
    
    img:at(r, c).y = temp;
  end

  img = il.YIQ2RGB(img);

  return img;
end
helper.eightWay = eightWay;


--------------------------------------------------------------------------------
--
-- Function Name: applyConvolutionFilter
--
-- Description: 
--
-- Parameters:
--
-- Return: 
--
--------------------------------------------------------------------------------
local function applyConvolutionFilter( img, filter, filterSize, recenter )
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing array for looping over filter
  local index = {};
  for i = 1, filterSize do
    index[i] = i - 1 - ( ( filterSize - 1 ) / 2 );
  end
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( ( filterSize - 1 ) / 2 ) do
    local temp = 0;
    
    --At each pixel, loop over and add neighbors
    for x = 1, filterSize do
      for y = 1, filterSize do
        temp = temp + ( img:at(r + index[x], c + index[y] ).i * filter[x][y] );
      end
    end
    
    --Recenter to gray (128) if specified
    if recenter then
      temp = temp + 128;
    end
    
    --Trim result
    if(temp > 255) then
      temp = 255;
    elseif(temp < 0) then
      temp = 0;
    end
    
    --Copy new intensity and old chromaticities to new image
    newImg:at(r,c).i = temp;
  end
  
  --Return new image
  return newImg;
end
helper.applyConvolutionFilter = applyConvolutionFilter;


--------------------------------------------------------------------------------
--
-- Function Name: applyRankOrderFilter
--
-- Description: 
--
-- Parameters:
--
-- Return:
--
--------------------------------------------------------------------------------
local function applyRankOrderFilter( img, filter, filterSize )
  --New blank image to save results as processed
  local newImg = img:clone();
  
  --Indexing array for looping over filter
  local index = {};
  for i = 1, filterSize do
    index[i] = i - 1 - ( ( filterSize - 1 ) / 2 );
  end
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( ( filterSize - 1 ) / 2 ) do
    local neighbors = {};
    local i = 1;
    
    --At each pixel, loop over and collect neighbors
    for x = 1, filterSize do
      for y = 1, filterSize do
        for _ = 1, filter[x][y] do
          neighbors[i] = img:at(r + index[x], c + index[y] ).i;
          i = i + 1;
        end
      end
    end
    
    --Apply specified transformation (currently only median)
    table.sort( neighbors );
    newImg:at(r,c).i = neighbors[i/2];
  end
  
  --Return new image
  return newImg;
end
helper.applyRankOrderFilter = applyRankOrderFilter;


--Define help message
helper.HelpMessage = "The following image processing techniques can be applied by selecting them from the menus.\n" ..
"Grayscale - Converts image to grayscale image\n" ..
"Negate - Negates the image, inverting color channels\n" ..
"Posterize - Splits image into specified number of intensities\n" ..
"Brightness - Increase or decrease image brightness\n" ..
"Contrast Stretch - Stretch image contrast between endpoints\n" ..
"Gamma - Perform gamma transformation with specified gamma\n" ..
"Log - Perform log transformation\n" ..
"Bit-plane Slice - Set pixel intensity based on binary value\n" ..
"Discrete Pseudocolor - Split image into 8 colors based on intensity\n" ..
"Continuous Pseudocolor - Split image into 256 colors based on intensity\n" ..
"Solarize - Negate pixels below threshold\n" ..
"Inverse Solarize - Negate pixels above threshold\n" ..
"Automated Contrast Stretch - Stretches image contrast between brightest and darkest pixels\n" ..
"Contrast Specify - Stretches image contrast between brightest and darkest pixels, ignoring percentage\n" ..
"Histogram Display - Display image histogram of intensities\n" ..
"Histogram Display RGB - Display image histogram of color channels\n" ..
"Histogram Equalization - Spread out image intensities based on histogram\n" ..
"Histogram Equalize Clip - Spread out image intensities based on histogram, ingoring percentage\n" ..
"Binary Threshold - Any pixel above threshold is set to white, any below is set to black\n";

--Return table of helper functions
return helper;  