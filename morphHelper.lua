--------------------------------------------------------------------------------
--
--  File Name: morphHelper
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 4/8/2017
--  
--  Description: 
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local morphHelper = {};


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
morphHelper.zoomIn = zoomIn;


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
morphHelper.zoomOut = zoomOut;


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
morphHelper.complement = complement;


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
morphHelper.applyGeoDilate = applyGeoDilate;


--Return table of helper functions
return morphHelper;  