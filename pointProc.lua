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

--Define already loaded il file
local il = require("il");

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
local function posterize( img )
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
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
local function gamma( img )
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
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
      return 255 - r, 255 - g, 255 - b;
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
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
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
  return img:mapPixels(
    function( r, g, b )
      return 255 - r, 255 - g, 255 - b;
    end
  );
end
pointProc.contPsuedocolor = contPsuedocolor;

--Return table of point process functions
return pointProc;  