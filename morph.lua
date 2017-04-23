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
--  Description: This is a wrapper function for geodesic dilation. It opens the
--    specified mask file, then passes all arguments to a function to implement
--    geodesic dilation.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskFile - File containing mask image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying geodesic dilation
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
--  Description: This is a wrapper function for geodesic erosion. It opens the
--    specified mask file, then passes all arguments to a function to implement
--    geodesic erosion.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskFile - File containing mask image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying geodesic erosion
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
--  Description: This is a wrapper function for reconstruction by dilation. It
--    opens the specified mask file, then passes all arguments to a function to
--    implement reconstruction by dilation.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskFile - File containing mask image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying reconstruction by erosion
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
--  Description: This is a wrapper function for reconstruction by erosion. It
--    opens the specified mask file, then passes all arguments to a function to
--    implement reconstruction by erosion.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskFile - File containing mask image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying reconstruction by erosion
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
--  Description: This function dilates a binary image. It is only intended to be
--    used on binary images.
--
--  Parameters:
--    img - Input image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying dilation
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
morph.dilate = dilate;


--------------------------------------------------------------------------------
--
--  Function Name: erode
--
--  Description: This function erodes a binary image. It is only intended to be
--    used on binary images.
--
--  Parameters:
--    img - Input image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying erosion
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
morph.erode = erode;


--------------------------------------------------------------------------------
--
--  Function Name: openRec
--
--  Description: This function performs opening by reconstruction. It begins by
--    performing the specified number of erosions, then performs reconstruction
--    by dilation.
--
--  Parameters:
--    img - Input image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--    iterations - How many erosions to perform
--
--  Return: 
--    resultImg - The image after applying opening by reconstruction
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
--  Description: This function performs closing by reconstruction. It begins by
--    performing the specified number of dilations, then performs reconstruction
--    by erosion.
--
--  Parameters:
--    img - Input image
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--    iterations - How many dilations to perform
--
--  Return: 
--    resultImg - The image after applying closing by reconstruction
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
--  Description: This function performs automatic hole filling. It begins by
--    complementing the mask image. It then sets up the marker image, which will
--    be the inverse of any pixels on the border, and zero for any interior
--    pixels. It then performs reconstruction by dilation and returns the 
--    complement of the result.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    resultImg - The image after filling holes
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
      markerImg:at(r,c).r = 0;
      markerImg:at(r,c).g = 0;
      markerImg:at(r,c).b = 0;
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
--  Description: This function performs automatic border clearing. It begins by
--    setting up the marker image, which will be the value of any pixels on the
--    border, and zero for any interior pixels. It then performs reconstruction
--    by dilation and returns the result subtracted from the original image.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    resultImg - The image after clearing border
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
      --Set to value of image
      markerImg:at(r,c).r = img:at(r,c).r;
      markerImg:at(r,c).g = img:at(r,c).g;
      markerImg:at(r,c).b = img:at(r,c).b;
    
    --If interior pixel
    else
      --Remove from set
      markerImg:at(r,c).r = 0;
      markerImg:at(r,c).g = 0;
      markerImg:at(r,c).b = 0;
    end
  end
  
  --Perform reconstruction by dilation
  local recImg = morphHelper.applyRecDilate( markerImg, img, 3, 3 );
  
  --Subtract result from original image
  for r,c in resultImg:pixels() do
    resultImg:at(r,c).r = img:at(r,c).r - recImg:at(r,c).r;
    resultImg:at(r,c).g = img:at(r,c).g - recImg:at(r,c).g;
    resultImg:at(r,c).b = img:at(r,c).b - recImg:at(r,c).b;
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
local function thinMorph( img, n, filter1, filter2, prune )
  --White, black, and -1 for positions we don't care about
  if filter1 == nil then
    filter1 = { { 0, 0, 0 }, { -1, 255, -1 }, { 255, 255, 255 } };
  end
  if filter2 == nil then
    filter2 = { { -1, 0, 0 }, { 255, 255, 0 }, { 255, 255, -1 } };
  end
 
  if prune then
    for i = 0, 3 do
      -- Hit/miss down, left, up, right
      img = morphHelper.hitOrMiss(img, filter1, 0);
      
      filter1 = helper.rotateFilter(filter1);
      filter1 = helper.rotateFilter(filter1);
    end
    -- If doing 8 directional then we need to hit/miss the diagonals
    if n == "8" then  
      for i = 0, 3 do
          img = morphHelper.hitOrMiss(img, filter2, 0);
          filter2 = helper.rotateFilter(filter2);
          filter2 = helper.rotateFilter(filter2);
      end
    end
  else
    for i = 0, 3 do
      -- Hit/miss down, left, up, right
      img = morphHelper.hitOrMiss(img, filter1, 0);
      
      filter1 = helper.rotateFilter(filter1);
      filter1 = helper.rotateFilter(filter1);

      -- If doing 8 directional then we need to hit/miss the diagonals
      if n == "8" then
          img = morphHelper.hitOrMiss(img, filter2, 0);
          filter2 = helper.rotateFilter(filter2);
          filter2 = helper.rotateFilter(filter2);
      end
    end
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

--------------------------------------------------------------------------------
--
--  Function Name: skeletonMorph
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
local function skeletonMorph( img, filter1, filter2, prune )
  local isFinished = false
  local procImage
  
  -- Loop image till processed image is same as unprocessed image
  while isFinished == false do
    isFinished = true
  
    -- Call thinning and send clone to prevent safe reference
    procImage = thinMorph(img:clone(), "8", filter1, filter2, prune)
    
    -- Check pixels in both images and compare to see if complete
    for r,c in procImage:pixels( 0 ) do
      -- If any pixel is different, run again
      if  img:at(r, c).r ~= procImage:at(r, c).r then
        isFinished = false
        break
      end
    end
    
    -- Set image to processed image to repeat process
    img = procImage
  end
  
  return img;
end
morph.skeletonMorph = skeletonMorph;

--------------------------------------------------------------------------------
--
--  Function Name: skeletonMorph
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
local function pruningMorph( img )
  local isFinished = false
  local procImage
  local sElement1 = {{-1, 0, 0},
                    {255, 255, 0},
                    {-1, 0, 0}}
  local sElement2 = {{255, 0, 0},
                    {0, 255, 0},
                    {0, 0, 0}}

  local images = {}
  
  img = skeletonMorph( img, sElement1, sElement2, true )
  --[[local clone = img:clone()
  
  for i = 1, 8 do
    images[i] = clone:clone()
    
    helper.applyConvolutionFilter( images[i], sElement, 3, false, false)
    
    sElement = helper.rotateFilter( sElement )
  end
  
  for i = 1, 8 do
    for r,c in images[i]:pixels( 0 ) do
      if images[i]:at(r, c).r ~= 0 then
        clone:at(r,c).r = 255
        clone:at(r,c).g = 255
        clone:at(r,c).b = 255
        break
      end
    end
  end]]--
  
  return img;
end
morph.pruningMorph = pruningMorph;

--Return table of miscellaneous functions
return morph;
