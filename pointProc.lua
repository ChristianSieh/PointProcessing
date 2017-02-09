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
-- Description: 
--
-- Parameters:
--   img - An image object from ip.lua representing the image to process
--
-- Return: 
--   img - The image object after having the point process performed upon it
--
--------------------------------------------------------------------------------
local function posterize( img, lvl )

  -- Set Ranges
  local inputRange = 256 / lvl;
  inputRange = math.ceil(inputRange);
  
  local outputRange = 256 / (lvl - 1)
  outputRange = math.ceil(outputRange);
  
  local LUT = {};
  local temp = 0
  
  -- Compute LUT
  for i = 0, lvl - 1 do
    for j = (inputRange * i ), inputRange * (i + 1) do
      if (outputRange * i) - 1 > 255 then
        LUT[j] = 255;
      elseif i > 0 then
        LUT[j] = (outputRange * i);
      else
        LUT[j] = 0;
      end
    end
  end
  
  -- Update Image
  return img:mapPixels(
    function( r, g, b )
      return LUT[r], LUT[g], LUT[b];
    end
  );
end
pointProc.posterize = posterize;

--------------------------------------------------------------------------------
--
-- Function Name: Brightness
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
local function brightness( img, lvl )
  return img:mapPixels(
    function( r, g, b )
      local temp = { r + lvl, g + lvl, b + lvl };
      
      for i = 1, 3 do
        if temp[i] > 255 then
          temp[i] = 255
        end
        if temp[i] < 0 then
          temp[i] = 0
        end
      end
        
      return temp[1], temp[2], temp[3]
    end
  );
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
  return img:mapPixels(
    function( r, g, b )
      
      local c = 2;
      local temp = { c * math.pow(r, lvl), c * math.pow(g, lvl), c * math.pow(b, lvl) };
      
      for i = 1, 3 do
        if temp[i] > 255 then
          temp[i] = 255
        end
        if temp[i] < 0 then
          temp[i] = 0
        end
      end
      
      return temp[1], temp[2], temp[3]
    end
  );
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
  return img:mapPixels(
    function( r, g, b )
      local c = 50;

      local temp = { c * math.log(1 + r), c * math.log(1 + g), c * math.log(1 + b) };
      
      for i = 1, 3 do
        if temp[i] > 255 then
          temp[i] = 255
        end
        if temp[i] < 0 then
          temp[i] = 0
        end
      end
      
      return temp[1], temp[2], temp[3]
    end
  );
end
pointProc.logScale = logScale;

--------------------------------------------------------------------------------
--
-- Function Name: Bitplane Slice
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
local function slice( img )
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
    end
  );
end
pointProc.slice = slice;

--------------------------------------------------------------------------------
--
-- Function Name: Discrete Psuedocolor
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
local function distPsuedocolor( img )
  local rVal = {0, 255, 255, 0, 0, 0, 255, 255};
  local gVal = {0, 0, 255, 255, 255, 0, 0, 255};
  local bVal = {0, 0, 0, 0, 255, 255, 255, 255};
  local rLUT = {};
  local gLUT = {};
  local bLUT = {};
  
  -- Compute LUT
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
-- Description: 
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
-- Function Name: Looks Cool
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
local function looksCool( img )
    
  img = il.RGB2YIQ(img);
    
  local c = 10
    
  for r,c in img:pixels() do
    img:at(r,c).y = c * math.log(1 + img:at(r,c).y);
  end
  
  img = il.YIQ2RGB(img);
  
  return img;
  
end
pointProc.looksCool = looksCool;

--Return table of point process functions
return pointProc;  