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
      end
    end
  end
  
  return markerImg, maskImg, resultImg;
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
        resultImg:at(r,c).r = 0;
        resultImg:at(r,c).g = 0;
        resultImg:at(r,c).b = 0;      
      else
        --Loop over all neighbors
        for rn = heightLowIndex, heightHighIndex do
          for cn = widthLowIndex, widthHighIndex do
            if markerImg:at(r + rn, c + cn).r == 255 then
              resultImg:at(r,c).r = 255;
              resultImg:at(r,c).g = 255;
              resultImg:at(r,c).b = 255;
            end
          end
        end
      end
    end
  end
  
  return markerImg, maskImg, resultImg;
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
  local resultImg;
  
  --Indexing for traversing neighbors
  local widthLowIndex = -math.floor( ( filterWidth -1 ) / 2 );
  local widthHighIndex = widthLowIndex + filterWidth - 1;
  local heightLowIndex = -math.floor( ( filterHeight -1 ) / 2 );
  local heightHighIndex = heightLowIndex + filterHeight - 1;
  
  --Loop geodesic dilation until no changes
  local changed;
  repeat
    --Set up new result image
    resultImg = markerImg:clone();
    
    --Initialized changed flag to false
    changed = false;
    
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
        end
        
        --Check if pixel was changed this iteration
        if resultImg:at(r,c).r ~= markerImg:at(r,c).r then
          changed = true;
        end
      end
    end
    
    --Copy new result image into old marker image
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
  --Open specified mask file
  local maskImg = image.open( maskFile );
  local resultImg;
  
  --Indexing for traversing neighbors
  local widthLowIndex = -math.floor( ( filterWidth -1 ) / 2 );
  local widthHighIndex = widthLowIndex + filterWidth - 1;
  local heightLowIndex = -math.floor( ( filterHeight -1 ) / 2 );
  local heightHighIndex = heightLowIndex + filterHeight - 1;
  
  --Loop geodesic dilation until no changes
  local changed;
  repeat
    --Set up new result image
    resultImg = markerImg:clone();
    
    --Initialized changed flag to false
    changed = false;
    
    --Loop over all pixels outside of border
    for r = -heightLowIndex, markerImg.height - 1 - heightHighIndex do
      for c = -widthLowIndex, markerImg.width - 1 - widthHighIndex do
        --If pixel is in mask
        if maskImg:at(r,c).r == 0 then
          resultImg:at(r,c).r = 0;
          resultImg:at(r,c).g = 0;
          resultImg:at(r,c).b = 0;      
        else
          --Loop over all neighbors
          for rn = heightLowIndex, heightHighIndex do
            for cn = widthLowIndex, widthHighIndex do
              if markerImg:at(r + rn, c + cn).r == 255 then
                resultImg:at(r,c).r = 255;
                resultImg:at(r,c).g = 255;
                resultImg:at(r,c).b = 255;
              end
            end
          end
        end
        
        --Check if pixel was changed this iteration
        if resultImg:at(r,c).r ~= markerImg:at(r,c).r then
          changed = true;
        end
      end
    end
    
    --Copy new result image into old marker image
    markerImg = resultImg;
  until not changed
    
  return markerImg;
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
  local filter1 = { { 0, 0, 0 }, { -1, 255, -1 }, { 255, 255, 255 } };
  local filter2 = { { -1, 0, 0 }, { 255, 255, 0 }, { 255, 255, -1 } };
 
  il.RGB2YIQ( img );
 
  for i = 0, 3 do
    -- Hit/miss down, left, up, right
    img = helper.hitOrMiss(img, filter1);
    filter1 = helper.rotateFilter(filter1);
    filter1 = helper.rotateFilter(filter1);

    -- If doing 8 directional then we need to hit/miss the diagonals
    if n == "8" then
        img = helper.hitOrMiss(img, filter2);
        filter2 = helper.rotateFilter(filter2);
        filter2 = helper.rotateFilter(filter2);
    end
  end
  
  il.YIQ2RGB( img );
  
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

  
  return img;
end
morph.thickMorph = thickMorph;

--Return table of miscellaneous functions
return morph;
