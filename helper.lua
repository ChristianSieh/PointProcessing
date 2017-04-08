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
-- Function Name: applyConvolutionFilter
--
-- Description: This function takes an image and a filter of filterSize and uses
--              the filter to perform convolution. This is accomplished by summing
--              each pixel in the neighbordhood and multiplying by it's associatted
--              position in the filter. This function can also recenter the image to
--              128, and finally this function provides clipping.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    filter - The filter to be used in the convolution process
--    filterSize - The size of the filter that was passed in
--    recenter - A boolean used to specify if the image should be recentered
--               around the value 128
--
--  Return: 
--    newImg - The image object after being smoothed
--
--------------------------------------------------------------------------------
local function applyConvolutionFilter( img, filter, filterSize, recenter, adjust )
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
        temp = temp + ( img:at(r + index[x], c + index[y] ).i * filter[y][x] );
      end
    end
    
    --Recenter to gray (128) if specified
    if recenter then
      temp = temp + 128;
    end
    
    --Adjust values if specified
    if adjust and temp < 0 then
      temp = -temp;
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
-- Description: This function takes an image and a filter of filterSize and uses
--              the filter to perform a rank order. This function goes to each
--              neighbor specified by the filter and puts them in a list. An
--              insertion sort is then used to sort the list. Finally the middle
--              value is returned from the list.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--    filter - The filter to be used in the convolution process
--    filterSize - The size of the filter that was passed in
--
--  Return: 
--    newImg - The image object after being smoothed
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
    helper.insertionSort( neighbors, i );
    newImg:at(r,c).i = neighbors[i/2];
  end
  
  --Return new image
  return newImg;
end
helper.applyRankOrderFilter = applyRankOrderFilter;


--------------------------------------------------------------------------------
--
-- Function Name: rotateFilter
--
-- Description: This function is used to rotate a 3x3 filter counter-clockwise.
--
--  Parameters:
--    filter - A filter that is to be rotated by the function
--
--  Return: 
--    newFilter - The new, rotated filter
--
--------------------------------------------------------------------------------
local function rotateFilter( filter )
  --Create new filter
  local newFilter = { {}, {}, {} };
  
  newFilter[1][1] = filter[1][2];
  newFilter[1][2] = filter[1][3];
  newFilter[1][3] = filter[2][3];
  newFilter[2][3] = filter[3][3];
  newFilter[3][3] = filter[3][2];
  newFilter[3][2] = filter[3][1];
  newFilter[3][1] = filter[2][1];
  newFilter[2][1] = filter[1][1];
  newFilter[2][2] = filter[2][2];

  return newFilter;
end
helper.rotateFilter = rotateFilter;


--------------------------------------------------------------------------------
--
-- Function Name: insertionSort
--
-- Description: This takes a list and it's size in order to create a sorted list
--              by using an insertion sort
--
--  Parameters:
--    list - The list that is to be sorted
--    length - The length of the list to be sorted
--
--  Return: 
--    list - The sorted list
--
--------------------------------------------------------------------------------
local function insertionSort( list, length )
  --Loop over each item in list
  for i = 2, length - 1 do
    local curr = list[i];
    local j = i - 1;
    
    --Loop back through list until no numbers less than curr
    while j >= 1 and list[j] > curr do
      list[j+1] = list[j];
      j = j - 1;
    end
    
    --Insert current value into sorted portion of list
    list[j+1] = curr;
  end
end
helper.insertionSort = insertionSort;


--------------------------------------------------------------------------------
--
--  Function Name: zoomIn
--
--  Description: Makes image 10 times bigger
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    newImg - The image after growing
--
--------------------------------------------------------------------------------
local function zoomIn( img )
  --Create new image
  local newImg = image.flat( img.width * 10, img.height * 10 );
  
  --Stretch image
  for r,c in newImg:pixels() do
    newImg:at(r,c).r = img:at( math.floor(r/10), math.floor(c/10) ).r;
    newImg:at(r,c).g = img:at( math.floor(r/10), math.floor(c/10) ).g;
    newImg:at(r,c).b = img:at( math.floor(r/10), math.floor(c/10) ).b;
  end
  
  return newImg;
end
helper.zoomIn = zoomIn;


--------------------------------------------------------------------------------
--
--  Function Name: zoomOut
--
--  Description: Makes image 10 times smaller
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    newImg - The image after shrinking
--
--------------------------------------------------------------------------------
local function zoomOut( img )
  --Create new image
  local newImg = image.flat( math.floor( img.width / 10 ),
                             math.floor( img.height / 10 ) );
  
  --Shrink image
  for r,c in newImg:pixels() do
    newImg:at(r,c).r = img:at( r*10, c*10 ).r;
    newImg:at(r,c).g = img:at( r*10, c*10 ).g;
    newImg:at(r,c).b = img:at( r*10, c*10 ).b;
  end
  
  return newImg;
end
helper.zoomOut = zoomOut;


--------------------------------------------------------------------------------
--
--  Function Name: applyGeoDilate
--
--  Description: 
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    resultImg - The image after applying geodesic dilation
--
--------------------------------------------------------------------------------
local function applyGeoDilate( markerImg, maskImg, filterWidth, filterHeight )
  --Create starting copy of marker
  local resultImg = markerImg:clone();
  
  --Indexing for traversing neighbors
  local widthLowIndex = -math.floor( ( filterWidth -1 ) / 2 );
  local widthHighIndex = widthLowIndex + filterWidth - 1;
  local heightLowIndex = -math.floor( ( filterHeight -1 ) / 2 );
  local heightHighIndex = heightLowIndex + filterHeight - 1;
  
  --Loop over all pixels outside of border
  for r = -heightLowIndex, markerImg.height - 1 - heightHighIndex do
    for c = -widthLowIndex, markerImg.width - 1 - widthHighIndex do
      --If pixel is in mask
      if maskImg:at(r,c).r == 0 then
        --Loop over all neighbors
        for rn = heightLowIndex, heightHighIndex do
          for cn = widthLowIndex, widthHighIndex do
            if markerImg:at(r + rn, c + cn).r == 0 then
              resultImg:at(r,c).r = 0;
              resultImg:at(r,c).g = 0;
              resultImg:at(r,c).b = 0;
            end
          end
        end
      else
        resultImg:at(r,c).r = 255;
        resultImg:at(r,c).g = 255;
        resultImg:at(r,c).b = 255;
      end
    end
  end
  
  return resultImg;
end
helper.applyGeoDilate = applyGeoDilate;


--------------------------------------------------------------------------------
--
--  Function Name: complement
--
--  Description: 
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    newImg - The image after shrinking
--
--------------------------------------------------------------------------------
local function complement( img )
  --Loop over all pixels in image
  for r,c in img:pixels() do
    --If pixel is black
    if img:at(r,c).r == 0 then
      --Set pixel to white
      img:at(r,c).r = 255;
      img:at(r,c).g = 255;
      img:at(r,c).b = 255;
      
    --Else pixel is white
    else
      --Set pixel to black
      img:at(r,c).r = 0;
      img:at(r,c).g = 0;
      img:at(r,c).b = 0;
    end
  end
end
helper.complement = complement;


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