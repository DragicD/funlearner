PImage sky,land;

void setup() {
  size(717,509);
  
  sky = loadImage("bg.jpg");
  land = loadImage("land.gif");

  frameRate(24);
}

void landGravity() { // this function slides the foreground image down
  land.loadPixels(); // fills land.pixels[] array with color data from its pixels
  
  int x=15,y=20;
  
  for(int j=0;j<land.width;j++) { // from left to right...
    // for(int k=land.height-2;k>0;k--) { // bottom to top of each column...
    for(int k=land.height-2;k>0;k--) { // bottom to top of each column...
      /* note that we start above the very bottom. We compare the alpha of each pixel
       * to the one below it. If it checked the bottom row, there would be no pixel
       * below the current one to check! That could cause the program to have an error.
       */
       
      int i = j+k*land.width; // find that pixel's spot in the pixel array

      color c = land.pixels[i]; // get the color of the current pixel
      color comp = land.pixels[i+land.width]; // get the color of the pixel below it
      
      if(alpha(c)>0 && alpha(comp)==0) { // is the higher pixel solid, but the lower pixel not?
        land.pixels[i] = comp; // then make the current pixel the color of the empty area below
        land.pixels[i+land.width] = c; // and give the pixel below the color from the solid one
      }
    }
  }
  land.updatePixels(); // updates the image based on color data in its land.pixels[] array
}

// Processing calls this function when the mouse button is pressed
void mousePressed() {
  land = loadImage("land.gif"); // reload the image file for land
}

void draw() {
  landGravity(); // adding this call to "draw()" so that it too will be called 24 times per second

  image(sky,0,0);
  image(land,0,0);
}
