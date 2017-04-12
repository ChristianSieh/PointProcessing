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
local helper = require("helper");

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
  --Create copy of image to erode
  local markerImg = img:clone();
  
  --Perform specified number of erosions
  for _ = 1, iterations do
    markerImg = erode( markerImg, filterWidth, filterHeight );
  end
  
  --Perform reconstruction by dilation
  return morphHelper.applyRecDilate( markerImg, img, 3, 3 );
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
  --Create copy of image to dilate
  local markerImg = img:clone();
  
  --Perform specified number of dilations
  for _ = 1, iterations do
    markerImg = dilate( markerImg, filterWidth, filterHeight );
  end
  
  --Perform reconstruction by erosion
  return morphHelper.applyRecErode( markerImg, img, 3, 3 );
end
morph.closeRec = closeRec;


--------------------------------------------------------------------------------
--
--  Function Name: holeFill
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
local function holeFill( img )
  --Set up mask image
  local maskImg = morphHelper.complement( img );
  
  --Set up marker image
  local row_max, col_max = img.height - 1, img.width - 1;
  local markerImg = img:clone();
  for r,c in img:pixels() do
    --If border pixel
    if r == 0 or r == row_max or c == 0 or c == col_max then
      --Set to inverse of image
      markerImg:at(r,c).r = 255 - img:at(r,c).r;
      markerImg:at(r,c).g = 255 - img:at(r,c).g;
      markerImg:at(r,c).b = 255 - img:at(r,c).b;
    
    --If interior pixel
    else
      --Remove from set
      markerImg:at(r,c).r = 255;
      markerImg:at(r,c).g = 255;
      markerImg:at(r,c).b = 255;
    end
  end
  
  --Perform reconstruction by dilation
  local resultImg = morphHelper.applyRecDilate( markerImg, maskImg, 3, 3 );
  
  --Return complement of result
  return morphHelper.complement( resultImg );
end
morph.holeFill = holeFill;


--------------------------------------------------------------------------------
--
--  Function Name: borderClearing
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
local function borderClearing( img )
  --Set up marker image
  local row_max, col_max = img.height - 1, img.width - 1;
  local markerImg = img:clone();
  local resultImg = img:clone();
  for r,c in img:pixels() do
    --If border pixel
    if r == 0 or r == row_max or c == 0 or c == col_max then
      --Set to inverse of image
      markerImg:at(r,c).r = img:at(r,c).r;
      markerImg:at(r,c).g = img:at(r,c).g;
      markerImg:at(r,c).b = img:at(r,c).b;
    
    --If interior pixel
    else
      --Remove from set
      markerImg:at(r,c).r = 255;
      markerImg:at(r,c).g = 255;
      markerImg:at(r,c).b = 255;
    end
  end
  
  --Perform reconstruction by dilation
  local recImg = morphHelper.applyRecDilate( markerImg, img, 3, 3 );
  
  --Subtract result from original image
  for r,c in resultImg:pixels() do
    --resultImg:at(r,c).r = img:at(r,c).r - recImg:at(r,c).r;
    --resultImg:at(r,c).g = img:at(r,c).g - recImg:at(r,c).g;
    --resultImg:at(r,c).b = img:at(r,c).b - recImg:at(r,c).b;
    if recImg:at(r,c).r == 0 then
      resultImg:at(r,c).r = 255;
      resultImg:at(r,c).g = 255;
      resultImg:at(r,c).b = 255;
    end
  end
  
  return resultImg;
end
morph.borderClearing = borderClearing;


--------------------------------------------------------------------------------
--
--  Function Name: thinMorph
--
--  Description: 
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--    n   - 4 directional or 8 directional neighbors
--
--------------------------------------------------------------------------------
local function thinMorph( img, n )
  --White, black, and -1 for positions we don't care about
  local filter = { { 0, 0, 0 }, { -1, 255, -1 }, { 255, 255, 255 } };
 
  for i = 0, 3 do
    -- Hit/miss down, left, up, right
    img = morphHelper.hitOrMiss(img, filter, 0);
    filter = helper.rotateFilter(filter);

    -- If doing 8 directional then we need to hit/miss the diagonals
    if n == "8" then
        img = morphHelper.hitOrMiss(img, filter, 0);
    end
    filter = helper.rotateFilter(filter);
  end
  
  return img;
end
morph.thinMorph = thinMorph;

--------------------------------------------------------------------------------
--
--  Function Name: thickMorph
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
local function thickMorph( img, n )
  --White, black, and -1 for positions we don't care about
  local filter = { { 255, 255, 255 }, { -1, 0, -1 }, { 0, 0, 0 } };
 
  for i = 0, 3 do
    -- Hit/miss down, left, up, right
    img = morphHelper.hitOrMiss(img, filter, 255);
    filter = helper.rotateFilter(filter);

    -- If doing 8 directional then we need to hit/miss the diagonals
    if n == "8" then
        img = morphHelper.hitOrMiss(img, filter, 255);
    end
    filter = helper.rotateFilter(filter);
  end
  
  return img;
end
morph.thickMorph = thickMorph;

--Return table of miscellaneous functions
return morph;
