local pointProc = {};

local function grayscale( img )
  return image.flat( img.width, img.height );
end
pointProc.grayscale = grayscale;

return pointProc;
  