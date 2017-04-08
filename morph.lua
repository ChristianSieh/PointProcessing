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
  
  --Complement marker and mask
  morphHelper.complement( markerImg );
  morphHelper.complement( maskImg );
  
  --Apply geodesic dilation (dual with respect to complement)
  local resultImg = morphHelper.applyGeoDilate( markerImg, maskImg, filterWidth,
                                            filterHeight );
  
  --Complement result image
  morphHelper.complement( resultImg );
  
  return resultImg;
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
local function recDilate( markerImg, maskFile, filterWidth, filterHeight, comp )
  --Open specified mask file
  local maskImg = image.open( maskFile );
  
  --Complement marker and mask if requested (for duals)
  if comp then
    --Complement marker and mask
    morphHelper.complement( markerImg );
    morphHelper.complement( maskImg );
  end
  
  --Loop until stable
  local changed;
  repeat
    --Apply geodesic dilation
    local resultImg = morphHelper.applyGeoDilate( markerImg, maskImg, filterWidth, filterHeight );
    
    --Compare result to marker to see if stable yet
    changed = false;
    for r,c in markerImg:pixels() do
      if markerImg:at(r,c).r ~= resultImg:at(r,c).r then
        changed = true;
      end
    end
    
    --Copy result into markerImg
    markerImg = resultImg;
  until not changed
  
  return markerImg;
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
  --Apply reconstruction by dilation (dual with respect to complement)
  local resultImg = recDilate( markerImg, maskFile, filterWidth, filterHeight, true );
  
  --Complement result image
  morphHelper.complement( resultImg );
  
  return resultImg;
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