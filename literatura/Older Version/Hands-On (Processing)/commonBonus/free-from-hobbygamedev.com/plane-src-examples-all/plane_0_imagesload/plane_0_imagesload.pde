// We have 2 images. Background (sky) and foreground (land)
PImage sky,land;

// Processing calls this function when the program starts
void setup() {
  size(717,509); // the dimensions of our game
  
  sky = loadImage("bg.jpg"); // using jpg for a pretty background
  land = loadImage("land.gif"); // using gif for foreground, since it needs transparency pixels

  frameRate(24); // telling the program to update (call "draw()" function) 24 times per second
}

// the program calls this function constantly (24 times per second, as specified in "Setup()" above)
void draw() {
  image(sky,0,0); // draw the sky image. Align it to the top-left corner, position (0,0)
  image(land,0,0); // draw the land image. Since we draw it after, its non-transparent areas block the sky.
}
