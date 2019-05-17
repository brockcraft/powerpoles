/**
 A sketch to blend high contrast images together, subtracting the blacks and 
 substituting a desaturated color value. To reduce processing load the
 images are filtered upon loading, rather than during the draw loop.
 The draw loop only controls what portion of the images are displayed and
 supports writing out a file when the desired view is shown.
 
 The sketch loads image files from the /data folder and mixes them using the BLEND function.
 You must have images in the /data subdirectory for it to work.
 
 * In interactive mode: Mouse Drag vertically to paint the images in sequence
 * Press 's' to save the image file (overwrites existing file!)
 
 Draws upon BLEND example (C. Reas)
 
 B Craft, 5/1/2019
 */

int numberOfImages = 27; // 19 The number of images to be blended. Should match number in data folder to be processed.

int hue=0;                        // keeps track of the hue during increments
int hueStep = 255/numberOfImages; // step through the full hue spectrum across all images
int globalSaturation = 60;        // set saturation of blacks to a light intensity ~60
int brighnessSensitivity = 240;   // this is the threshold at which blacks will be detected and replaced with a color

// Create PImage arrays to hold the images
PImage[] images = new PImage[numberOfImages];
PImage[] imagesEnhanced = new PImage[numberOfImages];

String temp;  // utility variable to report info to the console

int renderNumber=1; // keep track of which image we are rendering
int selMode = REPLACE; // variables to select blend mode
String name = "REPLACE";

void setup() {
  //size(504, 672, P3D);     //size should match image aspect ratio
  //size(1008, 1344, P3D);   // other sizes
  //size(3024,4032, P3D);
  colorMode(HSB); // use HSB more to make it easy to vary saturation
  fullScreen();
  // open all of the images in the data folder and load them into the image buffer
  for (int i=0; i<numberOfImages; i++) {
    temp = "img" + i +".jpg"; 
    images[i] = loadImage(temp);

    //process the images as they are loaded
    imagesEnhanced[i] = new PImage(images[i].width, images[i].height);

    //report results
    println("Loaded " + temp);
    
    // apply the image adjustment function from the source image to a new image
    adjust(images[i], imagesEnhanced[i], hue);
    println("Adjusted " + temp);
    
    // increment the hue value upwards
    hue=hue+hueStep;
    println("Applied hue:" + hue);
  }

  noStroke();
}

// main loop
void draw() {  
  scale(.125);
  background(255);

  renderNumber=numberOfImages; // renders all of the images. uncomment next line to use mouse interaction instead
  //renderNumber = int(map(mouseY, 0, height, 1, numberOfImages)); // uncomment to use mouse interaction to plot images successively

  selMode=MULTIPLY;  // set render mode explictly (Overrides mouse clicks). Comment out to use mouseclick instead

// blend the images on top of each other
  for (int i=0; i<renderNumber; i++) {
    blend(imagesEnhanced[i], 0, 0, imagesEnhanced[i].width, imagesEnhanced[i].height, 0, 0, width, height, selMode);
  }
}

// function to adjust image saturation. takes source image, destination image, and the hue value to adjust
void adjust(PImage input, PImage output, int hueStep)
{
  int w = input.width;
  int h = input.height;

  //this is required before manipulating the image pixels directly
  input.loadPixels();
  output.loadPixels();

  //loop through all pixels in the image
  for (int i = 0; i < w*h; i++)
  {  
    //get color values from the current pixel (which are stored as a list of type 'color')
    color inColor = input.pixels[i];

    //Use bit-shifting to retrieve values from the pixel
    int hue = (inColor >> 16) & 0xFF;
    int sat = (inColor >> 8) & 0xFF;
    int brt = inColor & 0xFF;      

    hue = hueStep;
    sat = globalSaturation; 
    
    // if brightness is less than threshold, replace black with colors 
    if (brt<brighnessSensitivity) {
      output.pixels[i] = color(hue, sat, 255);
      // brt = 255;
      // output.pixels[i]= 0xff000000 | (hue << 16) | (sat << 8) | brt; //this does the same but faster
    } else {
     // sat = 0;
     // output.pixels[i]= 0xff000000 | (hue << 16) | (sat << 8) | brt; //this does the same but faster
      output.pixels[i] = color(hue, 0, brt);
    }
  }

  //so that we can display the new image we must call this for each image
  input.updatePixels();
  output.updatePixels();
}

// select different BLEND modes with mouseclick
void mousePressed() {

  if (selMode == REPLACE) { 
    selMode = BLEND;
    name = "BLEND";
  } else if (selMode == BLEND) { 
    selMode = ADD;
    name = "ADD";
  } else if (selMode == ADD) { 
    selMode = SUBTRACT;
    name = "SUBTRACT";
  } else if (selMode == SUBTRACT) { 
    selMode = LIGHTEST;
    name = "LIGHTEST";
  } else if (selMode == LIGHTEST) { 
    selMode = DARKEST;
    name = "DARKEST";
  } else if (selMode == DARKEST) { 
    selMode = DIFFERENCE;
    name = "DIFFERENCE";
  } else if (selMode == DIFFERENCE) { 
    selMode = EXCLUSION;  
    name = "EXCLUSION";
  } else if (selMode == EXCLUSION) { 
    selMode = MULTIPLY;  
    name = "MULTIPLY";
  } else if (selMode == MULTIPLY) { 
    selMode = SCREEN;
    name = "SCREEN";
  } else if (selMode == SCREEN) { 
    selMode = REPLACE;
    name = "REPLACE";
  }
  println(name);
}

// save the image buffer to a file (tiff is uncompressed, but big)
void keyPressed() {
  if (key=='s') {
    save("output.tiff");
  }
}
