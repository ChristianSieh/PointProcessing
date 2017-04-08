--------------------------------------------------------------------------------
--
--  File Name: morph
--  Authors: Matt Dyke, Christian Sieh, & Taylor Doell
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 3/22/2017
--  
--  Description: This file contains the function definitions for the 
--    morphological operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");
local morphHelper = require("morphHelper");

--Table to hold the point process functions
local morph = {};

--------------------------------------------------------------------------------
--
--  Function Name: geoDilate
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
local function geoDilate( markerImg, maskFile, filterWidth, filterHeight )
  --Open specified mask file
  local maskImg = image.open( maskFile );
  
  --Apply geodesic dilation
  return morphHelper.applyGeoDilate( markerImg, maskImg, filterWidth, filterHeight );
end
morph.geoDilate = geoDilate;


--------------------------------------------------------------------------------
--
--  Function Name: geoErode
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
local function geoErode( markerImg, maskFile, filterWidth, filterHeight )
  --Open specified mask file
  local maskImg = image.open( maskFile );
  
  --Apply geodesic erosion
  return morphHelper.applyGeoErode( markerImg, maskImg, filterWidth, filterHeight );
end
morph.geoErode = geoErode;


--------------------------------------------------------------------------------
--
--  Function Name: recDilate
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
local function recDilate( markerImg, maskFile, filterWidth, filterHeight )
  --Open specified mask file
  local maskImg = image.open( maskFile );
  
  --Apply reconstruction by dilation
  return morphHelper.applyRecDilate( markerImg, maskImg, filterWidth, filterHeight );
end
morph.recDilate = recDilate;


--------------------------------------------------------------------------------
--
--  Function Name: recErode
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
local function recErode( markerImg, maskFile, filterWidth, filterHeight )
  --Open specified mask file
  local maskImg = image.open( maskFile );
  
  --Apply reconstruction by erosion
  return morphHelper.applyRecErode( markerImg, maskImg, filterWidth, filterHeight );
end
morph.recErode = recErode;


--------------------------------------------------------------------------------
--
--  Function Name: dilate
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
local function dilate( img )

  
  return img;
end
morph.dilate = dilate;

--------------------------------------------------------------------------------
--
--  Function Name: erode
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
local function erode( img )

  
  return img;
end
morph.erode = erode;

--------------------------------------------------------------------------------
--
--  Function Name: open
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
local function open( img )

  
  return img;
end
morph.open = open;

--------------------------------------------------------------------------------
--
--  Function Name: close
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
local function close( img )

  
  return img;
end
morph.close = close;

--Return table of miscellaneous functions
return morph;  