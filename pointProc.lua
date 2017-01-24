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
-- Function Name: grayscale
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
local function grayscale( img )
  return image.flat( img.width, img.height );
end
pointProc.grayscale = grayscale;

--------------------------------------------------------------------------------
--
-- Function Name: negate
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


--Return table of point process functions
return pointProc;  