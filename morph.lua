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
--  Description: thinMorph takes an image, if the operation will be 4 or 8
--               directional, and two filters. If no filters are specified then the 
--               two filters in the code are used one after the other, 
--               applied with hitOrMiss, and rotated by 90 degrees.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--    n   - 4 directional or 8 directional neighbors
--    filter1 - optional first filter that can be used
--    filter2 - optional second filter that can be used
--
--------------------------------------------------------------------------------
local function thinMorph( img, n, filter1, filter2)
  --White, black, and -1 for positions we don't care about
  if filter1 == nil then
    filter1 = { { 0, 0, 0 }, { -1, 255, -1 }, { 255, 255, 255 } };
  end
  if filter2 == nil then
    filter2 = { { -1, 0, 0 }, { 255, 255, 0 }, { 255, 255, -1 } };
  end
  
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

  return img;
end
morph.thinMorph = thinMorph;

--------------------------------------------------------------------------------
--
--  Function Name: pruningThin
--
--  Description: pruningThin is like thinMorph above, but it runs the filters
--               in a different order, has to keep track of individual changes
--               for each filter and then union them together.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the point process performed upon it
--    filter1 - The first filter that is to be used
--    filter2 - The second filter that is to be used
--
--------------------------------------------------------------------------------
local function pruningThin(img, sElement1, sElement2)
  local temp = image.flat(img.width, img.height);
  local currentSE = sElement1;
  local hitMissImages = {};
  
    --First create the 8 images using {B}
  for i = 1, 8 do
    if i == 5 then
      currentSE = sElement2
    end
    
    -- Hit or miss the image to find the end points
    _, hitMissImages[i] = morphHelper.hitOrMiss(img, currentSE, 255);
    
    currentSE = helper.rotateFilter(currentSE);
    currentSE = helper.rotateFilter(currentSE);
  end

  --Next union them all together
  for r, c in img:pixels( 0 ) do
    for i = 1, 8 do
      if hitMissImages[i]:at(r, c).r == 255 then
        img:at(r, c).r = 0;
        img:at(r, c).g = 0;
        img:at(r, c).b = 0;
      end
    end
  end
  
  return img;
end
morph.pruningThin = pruningThin

--------------------------------------------------------------------------------
--
--  Function Name: thickMorph
--
--  Description: This function uses the kernel specified, runs hit/miss
--               and rotates the filter after each hit/miss. If a pixel
--               matches the kernel then it is changed to white since
--               we are using white for the foreground and black for the
--               background.
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
  local kernel = { { 255, 255, 255 }, { -1, 0, -1 }, { 0, 0, 0 } };
 
  for i = 0, 3 do
    -- Hit/miss down, left, up, right
    img = morphHelper.hitOrMiss(img, kernel, 255);
    kernel = helper.rotateFilter(kernel);

    -- If doing 8 directional then we need to hit/miss the diagonals
    if n == "8" then
        img = morphHelper.hitOrMiss(img, kernel, 255);
    end
    kernel = helper.rotateFilter(kernel);
  end
  
  return img;
end
morph.thickMorph = thickMorph;

--------------------------------------------------------------------------------
--
--  Function Name: skeletonMorph
--
--  Description: skeletonMorph repeats multiple morphological thinning's to the
--               input image. Once the images from one iteration of thinning to
--               the next show know changes, it has found the skeleton of the
--               input image and returns the result.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the skeletonization process performed
--
--------------------------------------------------------------------------------
local function skeletonMorph( img )
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
      if img:at(r, c).r ~= procImage:at(r, c).r then
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
--  Function Name: pruningMorph
--
--  Description: pruningMorph uses a B structuring element that is used
--               throughout the function. The function starts off by running
--               the morphological thinning 3 times. Then 8 images are then
--               created to capture all of the end points in the image. Next,
--               it must union all those together in order to get an image
--               containing all the end points. Then it runs dilation and
--               intersection in order to reconstruct pixel by pixel the
--               original structure of the input image. pruningMorph finishes
--               by unioning the first thinned image with the reconstructed
--               image to form the final pruned result image.
--
--  Parameters:
--    img - An image object from ip.lua representing the image to process
--
--  Return: 
--    img - The image object after having the pruning process performed upon it
--
--------------------------------------------------------------------------------
local function pruningMorph( img )
  local sElement1 = {{-1, 0, 0},
                    {255, 255, 0},
                    {-1, 0, 0}}
  local sElement2 = {{255, 0, 0},
                    {0, 255, 0},
                    {0, 0, 0}}
  local currentSE = sElement1;

  -- Initialize and create images
  local hitMissImages = {};
  local image1 = img:clone();
  local image2 = image.flat(img.width, img.height);
  local image3 = image.flat(img.width, img.height);
  local resultImg = image.flat(img.width, img.height)
  
  --Create image1, thin(A,{B}) 3 times
  for i = 1, 3 do
    image1 = pruningThin(image1, sElement1, sElement2)
  end
  
  --Create image2, union( hitMiss(image1, {B}) )
  --First create the 8 images using {B}
  for i = 1, 8 do
    if i == 5 then
      currentSE = sElement2
    end
    
    -- Hit or miss the image to find the end points
    _, hitMissImages[i] = morphHelper.hitOrMiss(image1, currentSE, 255);
    
    currentSE = helper.rotateFilter(currentSE);
    currentSE = helper.rotateFilter(currentSE);
  end
    
  --Next union them all together
  for r, c in img:pixels( 0 ) do
    for i = 1, 8 do
      if hitMissImages[i]:at(r, c).r == 255 then
        image2:at(r, c).r = 255;
        image2:at(r, c).g = 255;
        image2:at(r, c).b = 255;
        break
      end
    end
  end
  
  --Assign image3 to image2, intersect( dilate(image2, H), img)
  image3 = image2
  
  for i = 1, 3 do
    image3 = morphHelper.dilateAndIntersect( img, image3, dilate, i )
  end
  
  --union(image1, image3) into the resultImg
  morphHelper.union( resultImg, image1, image3 );
  
  return resultImg;
end
morph.pruningMorph = pruningMorph;

--Return table of miscellaneous functions
return morph;
