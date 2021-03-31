# powerpoles
 A Processing (https://www.processing.org) sketch to blend high contrast images together, subtracting the blacks and 
 substituting a desaturated color value. To reduce processing load the
 images are filtered upon loading, rather than during the draw loop.
 The draw loop only controls what portion of the images are displayed and
 supports writing out a file when the desired view is shown.
 
 The sketch loads image files from the /data folder and mixes them using the BLEND function. Other settings are retained for exploring different kinds of image processing.
 You must have images in the /data subdirectory for it to work.
 
 * In interactive mode: Mouse Drag vertically to paint the images in sequence
 * Press 's' to save the image file (overwrites existing file!)
 
 Draws upon BLEND example (C. Reas)
 
 B Craft, 5/1/2019, 3/31/21
