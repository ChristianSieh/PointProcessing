--------------------------------------------------------------------------------
--
--  File Name: pointProc
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 1/22/2017
--  
--  Description: This file contains the function definitions for the point
--    process operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded files
local il = require("il");
local helper = require("helper");

--Table to hold the point process functions
local pointProc = {};

--------------------------------------------------------------------------------
--
-- Function Name: Grayscale
--
-- Description: This function converts the given image to grayscale, using a 
--   ratio of 30% red, 59% green, and 11% blue.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function grayscale( img )
  --Loop over all pixels
  for r,c in img:pixels() do
    --Get intensity at current pixel with specified weights
    local intensity = img:at(r,c).r * 0.3
                    + img:at(r,c).g * 0.59
                    + img:at(r,c).b * 0.11;
    intensity = math.floor( intensity + 0.5 );
    
    --Assign to all three color components
    img:at(r,c).r = intensity;
    img:at(r,c).g = intensity;
    img:at(r,c).b = intensity; 
  end  
  return img;
end
pointProc.grayscale = grayscale;

--------------------------------------------------------------------------------
--
-- Function Name: Negate
--
-- Description: This function negates the given image. It does so by applying a
--   function which will invert each color component to each pixel in the image.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function negate( img )
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
    end
  );
end
pointProc.negate = negate;

--------------------------------------------------------------------------------
--
-- Function Name: Posterize
--
-- Description: This function reduces the numbers of colors in the image to
--              the number specified by the lvl parameter. 
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--   lvl - The number of colors to have in the image for each rgb channel
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function posterize( img, lvl )

  -- Set Ranges
  -- Input range is the pixels coming in so 256 / 8 for example means that
  -- every 32 pixels is a color
  local inputRange = 256 / lvl;
  inputRange = math.ceil(inputRange);
  
  -- The output range is used to change the level for the new pixels so 
  -- if we use 8 as our lvl again we will get 256/7 so for every 37
  -- pixels we need to change colors
  local outputRange = 256 / (lvl - 1)
  outputRange = math.ceil(outputRange);
  
  local LUT = {};
  
  -- Compute LUT
  for i = 0, lvl - 1 do
    for j = (inputRange * i ), inputRange * (i + 1) do
      if (outputRange * i) > 255 then
        LUT[j] = 255;
      elseif i > 0 then
        LUT[j] = (outputRange * i);
      else
        LUT[j] = 0;
      end
    end
  end
  
  img = il.RGB2YIQ(img);
  
  for r,c in img:pixels() do
    img:at(r,c).y = LUT[img:at(r,c).y];
  end
  
  img = il.YIQ2RGB(img);
  
  return img;
end
pointProc.posterize = posterize;

--------------------------------------------------------------------------------
--
-- Function Name: Brightness
--
-- Description: This function adds the level specified to each rgb value.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function brightness( img, lvl )
  local lookUp = {};
  for i = 0, 255 do
    lookUp[i] = i + lvl;
    
    if lookUp[i] > 255 then
      lookUp[i] = 255;
    elseif lookUp[i] < 0 then
      lookUp[i] = 0;
    end
  end
  
  il.RGB2YIQ( img );
  
  for r,c in img:pixels() do
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end
  
  il.YIQ2RGB( img );
  
  return img;
  
  end
pointProc.brightness = brightness;

--------------------------------------------------------------------------------
--
-- Function Name: manualContrast
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
local function manualContrast( img, low, high )
  --Convert to YIQ so we can use intensity
  img = il.RGB2YIQ(img);
  
  --Call helper function to perform contrast stretching with specified endpoints
  img = helper.performContrastStretch( img, low, high );
  
  --Convert back to RGB
  img = il.YIQ2RGB(img);
  
  return img;
end
pointProc.manualContrast = manualContrast;


--------------------------------------------------------------------------------
--
-- Function Name: Gamma
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
local function gamma( img, lvl )
  local lookUp = {};
  for i = 0, 255 do
    lookUp[i] = math.pow( i / 256, lvl ) * 256;
    lookUp[i] = math.floor( lookUp[i] + 0.5 );
  end
  
  for i = 0, 255 do
    if lookUp[i] > 255 then
      lookUp[i] = 255;
    elseif lookUp[i] < 0 then
      lookUp[i] = 0;
    end
  end
  
  il.RGB2YIQ( img );
  
  for r,c in img:pixels() do
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end
  
  il.YIQ2RGB( img );
  
  return img;
end
pointProc.gamma = gamma;

--------------------------------------------------------------------------------
--
-- Function Name: Log Scale
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
local function logScale( img )
  local lookUp = {};
  local c = 255 / math.log( 1 + 255 );
  for i = 0, 255 do
    lookUp[i] = c * math.log( 1 + i );
    lookUp[i] = math.floor( lookUp[i] + 0.5 );
  end
  
  for i = 0, 255 do
    if lookUp[i] > 255 then
      lookUp[i] = 255;
    elseif lookUp[i] < 0 then
      lookUp[i] = 0;
    end
  end
  
  il.RGB2YIQ( img );
  
  for r,c in img:pixels() do
    img:at(r,c).y = lookUp[img:at(r,c).y];
  end
  
  il.YIQ2RGB( img );
  
  return img;
end
pointProc.logScale = logScale;

--------------------------------------------------------------------------------
--
-- Function Name: Bitplane Slice
--
-- Description: This function take the bit specified (0 - 7) and checks that bit
--              in each intensity value. If the bit is a 1 then the value
--              maps to black otherwise it maps to white.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function slice( img, bitVal )
  --Convert to IHS so we can use intensity
  img = il.RGB2IHS(img);
  
  for r,c in img:pixels() do
    local val = img:at(r,c).i;
    local test = bit32.extract(val, bitVal);
    if test > 0 then
      img:at(r,c).i = 255;
    else
      img:at(r,c).i = 0;
    end
    img:at(r,c).s = 0;
  end
  
  --Convert back to RGB
  img = il.IHS2RGB(img);
  
  return img;
end
pointProc.slice = slice;

--------------------------------------------------------------------------------
--
-- Function Name: Discrete Psuedocolor
--
-- Description: This function starts at black and walks the color cube for
--              each pixel in the image. It maps these pixels to black, red,
--              yellow, green, cyan, blue, magenta, and white depending on
--              which level (sections of 32 pixels) they fall in.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function distPsuedocolor( img )
  local rVal = {0, 255, 255, 0, 0, 0, 255, 255};
  local gVal = {0, 0, 255, 255, 255, 0, 0, 255};
  local bVal = {0, 0, 0, 0, 255, 255, 255, 255};
  local rLUT = {};
  local gLUT = {};
  local bLUT = {};
  
  -- Compute LUT
  -- For each of the 8 color values, map each level (32 pixels) to that
  -- color
  for i = 0, 7 do
    for j = 0, 32 do
      rLUT[j + (i * 32)] = rVal[i + 1];
      gLUT[j + (i * 32)] = gVal[i + 1]; 
      bLUT[j + (i * 32)] = bVal[i + 1]; 
    end
  end
  
  -- Update Image
  return img:mapPixels(
    function( r, g, b )
      return rLUT[r], gLUT[g], bLUT[b];
    end
  );
end
pointProc.distPsuedocolor = distPsuedocolor;

--------------------------------------------------------------------------------
--
-- Function Name: Continuous Psuedocolor
--
-- Description: This function starts at black and walks the color cube for
--              each pixel in the image. It maps these pixels the same as
--              in the discrete function but each rgb value from 0 - 255
--              increases or decreases by 8. For example, the red channel
--              is at 0 for black and 255 for red so to go from red to
--              black you need to increase by 8 for each 32 steps. There are
--              32 steps since there are 256 values and 8 colors on the color
--              cube.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function contPsuedocolor( img )
  -- Little hacky since I just threw an extra value on the end
  local rVal = {0, 255, 255, 0, 0, 0, 255, 255, 255};
  local gVal = {0, 0, 255, 255, 255, 0, 0, 255, 255};
  local bVal = {0, 0, 0, 0, 255, 255, 255, 255, 255};
  local rLUT = {};
  local gLUT = {};
  local bLUT = {};
  
  -- Compute LUT
  -- Since we are doing 8 colors, each color will have 32 values between it and the next color
  for i = 1, 9 do
    for j = 0, 32 do
      if rVal[i + 1] ~= nil then
        if rVal[i + 1] > rVal[i] then
          rLUT[j + ((i - 1) * 32)] = (8 * (j + 1)) - 1; -- If we are increasing then we add 8
        elseif rVal[i + 1] < rVal[i] then
          rLUT[j + ((i - 1) * 32)] = 255 - (8 * j); -- If we are decreasing then we add 8
        else
          rLUT[j + ((i - 1) * 32)] = rVal[i]; -- If we aren't changing then we can just set the value
        end
      end
      
      if gVal[i + 1] ~= nil then
        if gVal[i + 1] > gVal[i] then
          gLUT[j + ((i - 1) * 32)] = (8 * (j + 1)) - 1;
        elseif gVal[i + 1] < gVal[i] then
          gLUT[j + ((i - 1) * 32)] = 255 - (8 * j);
        else
          gLUT[j + ((i - 1) * 32)] = gVal[i];
        end
      end
      
      if bVal[i + 1] ~= nil then
        if bVal[i + 1] > bVal[i] then
          bLUT[j + ((i - 1) * 32)] = (8 * (j + 1)) - 1;
        elseif bVal[i + 1] < bVal[i] then
          bLUT[j + ((i - 1) * 32)] = 255 - (8 * j);
        else
          bLUT[j + ((i - 1) * 32)] = bVal[i];
        end
      end
      
    end
  end
  
  -- Update Image
  return img:mapPixels(
    function( r, g, b )
      return rLUT[r], gLUT[g], bLUT[b];
    end
  );
end
pointProc.contPsuedocolor = contPsuedocolor;

--------------------------------------------------------------------------------
--
-- Function Name: Solarize
--
-- Description: This function negates intensities that are below the threshold
--              using the IHS color model.
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function solarize( img, lvl )
  --Convert to IHS so we can use intensity
  img = il.RGB2IHS(img);
  
  for r,c in img:pixels() do
    local val = img:at(r,c).y;
    if val < lvl then
      img:at(r,c).i =  255 - val;
    end
  end
  
  --Convert back to RGB
  img = il.IHS2RGB(img);
  
  return img;
end
pointProc.solarize = solarize;

--------------------------------------------------------------------------------
--
-- Function Name: Inverse Solarize
--
-- Description: This function negates intensities that are above the threshold
--              using the IHS color model.
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function inverseSolarize( img, lvl )
  --Convert to IHS so we can use intensity
  img = il.RGB2IHS(img);
  
  for r,c in img:pixels() do
    local val = img:at(r,c).y;
    if val > lvl then
      img:at(r,c).i =  255 - val;
    end
  end
  
  --Convert back to RGB
  img = il.IHS2RGB(img);
  
  return img;
end
pointProc.inverseSolarize = inverseSolarize;

--Return table of point process functions
return pointProc;  