--------------------------------------------------------------------------------
--
--  File Name: edge
--  Authors: Matt Dyke & Christian Sieh
--  Course: CSC 442 - Digital Image Processing
--  Instructor: Dr. Weiss
--  Date: 2/10/2017
--  
--  Description: This file contains the function definitions for the 
--    edge detection operations. The functions are stored in a table as they are 
--    created. This table is then returned at the end of the file, allowing
--    them to be called from the main part of the program, prog1.
--  
--------------------------------------------------------------------------------

--Define already loaded il file
local il = require("il");

--Table to hold the point process functions
local edge = {};


--------------------------------------------------------------------------------
--
--  Function Name: Sobel Edge Magnitude
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
local function sobelMag( img, lvl )
  
  return img;
end
edge.sobelMag = sobelMag;

--------------------------------------------------------------------------------
--
--  Function Name: Sobel Edge Direction
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
local function sobelDir( img, lvl )
  
  return img;
  
end
edge.sobelDir = sobelDir;

--------------------------------------------------------------------------------
--
--  Function Name: Kirsch Edge Magnitude & Direction
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
local function kirsch( img, lvl )
  
  return img;
  
end
edge.kirsch = kirsch;

--------------------------------------------------------------------------------
--
--  Function Name: Laplacian
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
local function laplacian( img, lvl )
  
  return img;
  
end
edge.laplacian = laplacian;

--------------------------------------------------------------------------------
--
--  Function Name: Range
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
local function range( img, lvl )
  
  return img;
  
end
edge.range = range;

--------------------------------------------------------------------------------
--
--  Function Name: Range
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
local function range( img, lvl )
  
  return img;
  
end
edge.range = range;

--------------------------------------------------------------------------------
--
--  Function Name: Standard Deviation
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
local function stdDev( img, lvl )
  
  return img;
  
end
edge.stdDev = stdDev;

--Return table of edge functions
return edge;