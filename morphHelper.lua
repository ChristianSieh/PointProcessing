--------------------------------------------------------------------------------
--
--  File Name: morphHelper
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 4/8/2017
--  
--  Description: This file contains many of the helper functions that are used
--    in the implementation of the morphological operators.
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
--  Description: Makes image 10 times bigger. This function stretches the width
--    and height of the image by making 10 copies of each pixel in each
--    direction. This function is only intended to be used to zoom in on the
--    test images for morphological operators.
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
--  Description: Makes image 10 times smaller. This function compresses the 
--    width and height of the image by keeping every tenth pixel. This image is
--    only meant to be used to zoom out of the test images for morphological 
--    operators.
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
--  Description: This returns the complement of an image. It sets any pixel with
--    a maxed out red component to white - all other pixels are set to black.
--    Because of this implementation, this funtion is only intended to be used
--    on binary images.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    resultImg - complemented image
--
--------------------------------------------------------------------------------
local function complement( img )
  local resultImg = image.flat( img.width, img.height );
  
  --Loop over all pixels in image
  for r,c in img:pixels() do
    --If pixel is black
    if img:at(r,c).r == 0 then
      --Set pixel to white
      resultImg:at(r,c).r = 255;
      resultImg:at(r,c).g = 255;
      resultImg:at(r,c).b = 255;
      
    --Else pixel is white
    else
      --Set pixel to black
      resultImg:at(r,c).r = 0;
      resultImg:at(r,c).g = 0;
      resultImg:at(r,c).b = 0;
    end
  end
  
  return resultImg;
end
morphHelper.complement = complement;


--------------------------------------------------------------------------------
--
--  Function Name: applyGeoDilate
--
--  Description: This function performs the implementation of geodesic dilation
--    on the given marker image using the given mask image. It calculates the
--    pixels to loop over and what the neighborhood for each pixel would be. For
--    each pixel, if the pixel is in the mask and all its neighbors are as well,
--    then that pixel is retained. Otherwise the pixel is not a part of the 
--    result.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskImg - Mask image used in geodesic operators
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
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
      if maskImg:at(r,c).r == 255 then
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
      else
        resultImg:at(r,c).r = 0;
        resultImg:at(r,c).g = 0;
        resultImg:at(r,c).b = 0;
      end
    end
  end
  
  return resultImg;
end
morphHelper.applyGeoDilate = applyGeoDilate;


--------------------------------------------------------------------------------
--
--  Function Name: applyGeoErode
--
--  Description: This function performs the implementation of geodesic erosion
--    on the given marker image using the given mask image. It does so by using
--    geodesic dilation, its dual with respect to complement. The mask and 
--    marker are complemented, geodesic dilation is applied, and the result is
--    complemented before returning.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskImg - Mask image used in geodesic operators
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying geodesic erosion
--
--------------------------------------------------------------------------------
local function applyGeoErode( markerImg, maskImg, filterWidth, filterHeight )
  --Complement marker and mask
  markerImg = morphHelper.complement( markerImg );
  maskImg = morphHelper.complement( maskImg );
  
  --Apply geodesic dilation (dual with respect to complement)
  local resultImg = morphHelper.applyGeoDilate( markerImg, maskImg, filterWidth, filterHeight );
  
  --Complement result image
  resultImg = morphHelper.complement( resultImg );
  
  return resultImg;
end
morphHelper.applyGeoErode = applyGeoErode;


--------------------------------------------------------------------------------
--
--  Function Name: applyRecDilate
--
--  Description: This function performs the implementation of reconstruction by
--    dilation using the given marker and mask images. It repeatedly applies
--    geodesic dilation, and checks to see if any changes occured after each
--    iteration. If none did, then reconstruction is complete.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskImg - Mask image used in geodesic operators
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    markerImg - The image after applying reconstruction by dilation
--
--------------------------------------------------------------------------------
local function applyRecDilate( markerImg, maskImg, filterWidth, filterHeight )
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
morphHelper.applyRecDilate = applyRecDilate;


--------------------------------------------------------------------------------
--
--  Function Name: applyRecErode
--
--  Description: This function performs the implementation of reconstruction by
--    erosion. It does so as the dual with respect to complement of 
--    reconstruction by dilation. It complements the mask and marker, performs
--    reconstruction by dilation, and then returns the complement of the result.
--
--  Parameters:
--    markerImg - Marker image used in geodesic operators
--    maskImg - Mask image used in geodesic operators
--    filterWidth - Width of the filter to use
--    filterHeight - Height of the filter to use
--
--  Return: 
--    resultImg - The image after applying reconstruction by erosion
--
--------------------------------------------------------------------------------
local function applyRecErode( markerImg, maskImg, filterWidth, filterHeight )
  --Complement marker and mask
  markerImg = morphHelper.complement( markerImg );
  maskImg = morphHelper.complement( maskImg );
  
  --Apply geodesic dilation (dual with respect to complement)
  local resultImg = morphHelper.applyRecDilate( markerImg, maskImg, filterWidth, filterHeight );
  
  --Complement result image
  resultImg = morphHelper.complement( resultImg );
  
  return resultImg;
end
morphHelper.applyRecErode = applyRecErode;


--------------------------------------------------------------------------------
--
--  Function Name: hitOrMiss
--
--  Description: hitOrMiss loops through all the pixels in an image and tries
--               to apply the specified structuring element to each pixel. If
--               the pixel is valid for hitOrMiss then it's value is updated
--               to the value passed in, otherwise it reamains the same.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    newImg - The image after shrinking
--    structElem - The structuring element to be used for hit/miss
--
--------------------------------------------------------------------------------
local function hitOrMiss( img, structElem, value )
  local newImg = img:clone();
  local pixelImg = image.flat(img.width, img.height);

  --Indexing array for looping over structuring element
  local index = {};
  for i = 1, 3 do
    index[i] = i - 2;
  end
  
  --Loop over all pixels, ignoring border due to filter size
  for r,c in newImg:pixels( 1 ) do
    local valid = true;
    local x = 1;
    local rC;
    local gC;
    local bC;
    
    --While we have a valid match to our SE, loop through SE
    while valid and x <= 3 do
        for y = 1, 3 do
          --Get rgb values while looping through structuring element
          rC = img:at(r + index[x], c + index[y] ).r;
          gC = img:at(r + index[x], c + index[y] ).g;
          bC = img:at(r + index[x], c + index[y] ).b;

          --If rgb didn't match then hit/miss didn't work and this pixel isn't valid
          if structElem[x][y] ~= -1 and rC ~= structElem[x][y] and 
                gC ~= structElem[x][y] and bC ~= structElem[x][y] then
              valid = false;
          end
        end
        x = x + 1;
    end
    
    --If hit/miss passed then update pixel to value otherwise leave it the same
    if valid then
        newImg:at(r,c).r = value;
        newImg:at(r,c).g = value;
        newImg:at(r,c).b = value;
        pixelImg:at(r,c).r = 255;
        pixelImg:at(r,c).g = 255;
        pixelImg:at(r,c).b = 255;
    else
        newImg:at(r,c).r = img:at(r,c).r;
        newImg:at(r,c).g = img:at(r,c).g;
        newImg:at(r,c).b = img:at(r,c).b;
    end
  end

  return newImg, pixelImg;
end
morphHelper.hitOrMiss = hitOrMiss;


--Return table of helper functions
return morphHelper;  