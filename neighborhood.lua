--------------------------------------------------------------------------------
--
--  File Name: neighborhood
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/10/2017
--  
--  Description: This file contains the function definitions for the 
--    neighborhood operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");
local helper = require("helper");

--Table to hold the point process functions
local neighborhood = {};

--------------------------------------------------------------------------------
--
--  Function Name: Smooth
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
local function smooth( img )
  local filter = { { 1/16, 2/16, 1/16 }, { 2/16, 4/16, 2/16 }, { 1/16, 2/16, 1/16 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply convolution filter
  newImg = helper.applyConvolutionFilter( img, filter, 3 );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
end
neighborhood.smooth = smooth;

--------------------------------------------------------------------------------
--
--  Function Name: Sharpen
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
local function sharpen( img, lvl )
  filter = {0, -1, 0, -1, 5, -1, 0, -1, 0};
  
  img = helper.eightWay(img, filter, 1);
  
  return img;
end
neighborhood.sharpen = sharpen;

--------------------------------------------------------------------------------
--
--  Function Name: Mean
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
local function mean( img, num )
  
  local temp = 0;
  local dup = image.flat(img.width, img.height);
  local test = math.floor(num / 2);

  img = il.RGB2YIQ(img);
  dup = il.RGB2YIQ(dup);

  for r,c in img:pixels(num) do
    for i = -test, test do
      for j = - test, test do
        temp = temp + img:at(r + i, c + j).y;
      end
    end
  
  temp = temp * (1 / math.pow(num, 2))

    dup:at(r, c).y = temp;
  end

  dup = il.YIQ2RGB(dup);
  
  return dup;
end
neighborhood.mean = mean;

--------------------------------------------------------------------------------
--
--  Function Name: Minimum
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
local function minimum( img, lvl )
  
  local list = {};
  local dup = image.flat(img.width, img.height);
  
  img = il.RGB2YIQ(img);
  dup = il.RGB2YIQ(dup);

  for r,c in img:pixels(1) do
    -- UP LEFT
    list[1] = img:at(r - 1, c - 1).y;
    -- UP
    list[2] = img:at(r - 1, c).y;
    -- UP RIGHT
    list[3] = img:at(r - 1, c).y;
    -- RIGHT
    list[4] = img:at(r, c + 1).y;
    -- MIDDLE
    list[5] = img:at(r, c).y;
    -- DOWN RIGHT
    list[6] = img:at(r + 1, c + 1).y;
    -- DOWN
    list[7] = img:at(r + 1, c).y;
    -- DOWN LEFT
    list[8] = img:at(r + 1, c - 1).y;
    -- LEFT
    list[9] = img:at(r, c - 1).y;
    
    table.sort(list);
    
    dup:at(r, c).y = list[1];
    --dup:at(r, c).i = img:at(r, c).i;
    --dup:at(r, c).q = img:at(r, c).q;
  end

  dup = il.YIQ2RGB(dup);
  
  return dup;
end
neighborhood.minimum = minimum;

--------------------------------------------------------------------------------
--
--  Function Name: Maximum
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
local function maximum( img, lvl )
  local list = {};
  local dup = image.flat(img.width, img.height);
  
  img = il.RGB2YIQ(img);
  dup = il.RGB2YIQ(dup);

  for r,c in img:pixels(1) do
    -- UP LEFT
    list[1] = img:at(r - 1, c - 1).y;
    -- UP
    list[2] = img:at(r - 1, c).y;
    -- UP RIGHT
    list[3] = img:at(r - 1, c).y;
    -- RIGHT
    list[4] = img:at(r, c + 1).y;
    -- MIDDLE
    list[5] = img:at(r, c).y;
    -- DOWN RIGHT
    list[6] = img:at(r + 1, c + 1).y;
    -- DOWN
    list[7] = img:at(r + 1, c).y;
    -- DOWN LEFT
    list[8] = img:at(r + 1, c - 1).y;
    -- LEFT
    list[9] = img:at(r, c - 1).y;
    
    table.sort(list);
    
    dup:at(r, c).y = list[9];
    --dup:at(r, c).i = img:at(r, c).i;
    --dup:at(r, c).q = img:at(r, c).q;
  end

  dup = il.YIQ2RGB(dup);
  
  return dup;
end
neighborhood.maximum = maximum;

--------------------------------------------------------------------------------
--
--  Function Name: Median Plus
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
local function medianPlus( img, lvl )
  local filter = { { 0, 1, 0 }, { 1, 1, 1 }, { 0, 1, 0 } };
  
  --Covert to grayscale before applying filter
  il.RGB2IHS( img );
  
  --Apply convolution filter
  newImg = helper.applyRankOrderFilter( img, filter, 3 );
  
  --Covert back to color
  il.IHS2RGB( newImg );
  
  return newImg;
end
neighborhood.medianPlus = medianPlus;

--------------------------------------------------------------------------------
--
--  Function Name: Median
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
local function median( img )

  return img;
end
neighborhood.median = median;

--------------------------------------------------------------------------------
--
--  Function Name: Emboss
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
local function emboss( img, lvl )
  filter = {-1, -1, 0, -1, 0, 1, 0, 1, 1};
  
  local rTemp, gTemp, bTemp;

  for r,c in img:pixels(1) do
    -- UP LEFT
    rTemp = filter[1] * img:at(r - 1, c - 1).r;
    gTemp = filter[1] * img:at(r - 1, c - 1).g;
    bTemp = filter[1] * img:at(r - 1, c - 1).b;
    -- UP
    rTemp = rTemp + filter[2] * img:at(r - 1, c).r;
    gTemp = gTemp + filter[2] * img:at(r - 1, c).g;
    bTemp = bTemp + filter[2] * img:at(r - 1, c).b;
    -- UP RIGHT
    rTemp = rTemp + filter[3] * img:at(r - 1, c).r;
    gTemp = gTemp + filter[3] * img:at(r - 1, c).g;
    bTemp = bTemp + filter[3] * img:at(r - 1, c).b;
    -- RIGHT
    rTemp = rTemp + filter[4] * img:at(r, c + 1).r;
    gTemp = gTemp + filter[4] * img:at(r, c + 1).g;
    bTemp = bTemp + filter[4] * img:at(r, c + 1).b;
    -- MIDDLE
    rTemp = rTemp + filter[5] * img:at(r, c).r;
    gTemp = gTemp + filter[5] * img:at(r, c).g;
    bTemp = bTemp + filter[5] * img:at(r, c).b;
    -- DOWN RIGHT
    rTemp = rTemp + filter[6] * img:at(r + 1, c + 1).r;
    gTemp = gTemp + filter[6] * img:at(r + 1, c + 1).g;
    bTemp = bTemp + filter[6] * img:at(r + 1, c + 1).b;
    -- DOWN
    rTemp = rTemp + filter[7] * img:at(r + 1, c).r;
    gTemp = gTemp + filter[7] * img:at(r + 1, c).g;
    bTemp = bTemp + filter[7] * img:at(r + 1, c).b;
    -- DOWN LEFT
    rTemp = rTemp + filter[8] * img:at(r + 1, c - 1).r;
    gTemp = gTemp + filter[8] * img:at(r + 1, c - 1).g;
    bTemp = bTemp + filter[8] * img:at(r + 1, c - 1).b;
    -- LEFT
    rTemp = rTemp + filter[9] * img:at(r, c - 1).r;
    gTemp = gTemp + filter[9] * img:at(r, c - 1).g;
    bTemp = bTemp + filter[9] * img:at(r, c - 1).b;
    
    img:at(r, c).r = rTemp;
    img:at(r, c).r = gTemp;
    img:at(r, c).r = bTemp;
  end
  
  return img;
end
neighborhood.emboss = emboss;

--Return table of miscellaneous functions
return neighborhood;  