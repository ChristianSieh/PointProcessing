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
local function dilate( img, filterWidth, filterHeight )
  --Create starting copy of marker
  local resultImg = img:clone();
  
  --Indexing for traversing neighbors
  local widthLowIndex = -math.floor( ( filterWidth -1 ) / 2 );
  local widthHighIndex = widthLowIndex + filterWidth - 1;
  local heightLowIndex = -math.floor( ( filterHeight -1 ) / 2 );
  local heightHighIndex = heightLowIndex + filterHeight - 1;
  
  --Loop over all pixels outside of border
  for r = -heightLowIndex, img.height - 1 - heightHighIndex do
    for c = -widthLowIndex, img.width - 1 - widthHighIndex do
      --Loop over all neighbors
      for rn = heightLowIndex, heightHighIndex do
        for cn = widthLowIndex, widthHighIndex do
          if img:at(r + rn, c + cn).r == 0 then
            resultImg:at(r,c).r = 0;
            resultImg:at(r,c).g = 0;
            resultImg:at(r,c).b = 0;
          end
        end
      end
    end
  end
  
  return resultImg;
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
local function erode( img, filterWidth, filterHeight )
  --Create starting copy of marker
  local resultImg = img:clone();
  
  --Indexing for traversing neighbors
  local widthLowIndex = -math.floor( ( filterWidth -1 ) / 2 );
  local widthHighIndex = widthLowIndex + filterWidth - 1;
  local heightLowIndex = -math.floor( ( filterHeight -1 ) / 2 );
  local heightHighIndex = heightLowIndex + filterHeight - 1;
  
  --Loop over all pixels outside of border
  for r = -heightLowIndex, img.height - 1 - heightHighIndex do
    for c = -widthLowIndex, img.width - 1 - widthHighIndex do
      --Loop over all neighbors
      for rn = heightLowIndex, heightHighIndex do
        for cn = widthLowIndex, widthHighIndex do
          if img:at(r + rn, c + cn).r == 255 then
            resultImg:at(r,c).r = 255;
            resultImg:at(r,c).g = 255;
            resultImg:at(r,c).b = 255;
          end
        end
      end
    end
  end
  
  return resultImg;
end
morph.erode = erode;

--------------------------------------------------------------------------------
--
--  Function Name: openRec
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
local function openRec( img, filterWidth, filterHeight, iterations )

  
  return img;
end
morph.openRec = openRec;

--------------------------------------------------------------------------------
--
--  Function Name: closeRec
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
local function closeRec( img, filterWidth, filterHeight, iterations )

  
  return img;
end
morph.closeRec = closeRec;


--Return table of miscellaneous functions
return morph;  