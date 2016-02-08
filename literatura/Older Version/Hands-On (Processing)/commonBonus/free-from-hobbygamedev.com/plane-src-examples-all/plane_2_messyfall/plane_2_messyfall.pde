PImage sky,land;

void setup() {
  size(717,509);
  
  sky = loadImage("bg.jpg");
  land = loadImage("land.gif");

  frameRate(24);
}

void landGravity() {
  land.loadPixels();

  for(int j=0;j<land.width;j++) {
    for(int k=land.height;k>0;k--) {
      int i = j+k*land.width;
      if(i<0 || i>=land.pixels.length-2*land.width-1) {
        continue;
      }
      color c = land.pixels[i];
      color comp = land.pixels[i+land.width];
      color comp2 = land.pixels[i+2*land.width];
      color cuse = -1;
      int dx = 0;
      int dy = 0;
      float ac = alpha(c);
      if(ac>alpha(comp2)) {
        cuse = comp2;
        dy = 2;
      } else if(ac>alpha(comp)) {
        cuse = comp;
        dy = 1;
      } else if(random(4)<1 && i+1+2*land.width < land.pixels.length) {
        comp = land.pixels[i-1+land.width];
        comp2 = land.pixels[i+1+land.width];
        
        // if the dirt is stacked tall and 1 pixel thin...
        if(ac>alpha(comp) &&
           ac>alpha(comp2)) {
          float rv=red(land.pixels[i]);
          float gv=green(land.pixels[i]);
          float bv=blue(land.pixels[i]);
          land.pixels[i] = color(rv,gv,bv,0); // erase the top pixel by setting its alpha to 0
        }
        continue;
      } else {
        continue;
      }
      
      // randomize the dirt fall to go left and right some of the time
      if(random(3)>1) {
        if(random(2)<1 && i%land.width>=0) {
          if(ac>alpha(land.pixels[i+dx-1+dy*land.width])) {
            dx--;
          }
        }
        if(random(2)<1 && i%land.width<land.width) {
          if(ac>alpha(land.pixels[i+dx+1+dy*land.width])) {
            dx++;
          }
        }
      }
      
      float rv=red(land.pixels[i]);
      float gv=green(land.pixels[i]);
      float bv=blue(land.pixels[i]);
      land.pixels[i] = color(rv,gv,bv,0);
      land.pixels[i+dx+dy*land.width] = c;
    }
  }
  land.updatePixels();
}

// this function will draw a transparent sqaure onto the land image, "cutting a hole" in it
void carveLand(int atX,int atY,int rad) {
  int left=atX-rad;
  int right=atX+rad;
  int top=atY-rad;
  int bottom=atY+rad;
  
  // we want to make sure that the left, right, top, and bottom are within the image dimensions
  if(left < 0) {
    left = 0;
  }
  if(right >= land.width) {
    right = land.width-1;
  }
  if(top < 0) {
    top = 0;
  }
  if(bottom >= land.height) {
    bottom = land.height-1;
  }
  
  // then for each pixel in that square area...
  for(int x=left;x<right;x++) {
    for(int y=top;y<bottom;y++) {
      int dest = x+y*land.width;
      land.pixels[dest] = color(255,255,255,0); // set its alpha to zero
    }
  }
}

// Processing calls this function when a mouse button gets pressed
void mousePressed() {
  // in Processing, mouseX and mouseY always contain the current x and y coordinates of the mouse
  carveLand(mouseX, mouseY, 25);
}

void draw() {
  landGravity();

  image(sky,0,0);
  image(land,0,0);
}
