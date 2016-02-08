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
        
        if(ac>alpha(comp) &&
           ac>alpha(comp2)) {
          float rv=red(land.pixels[i]);
          float gv=green(land.pixels[i]);
          float bv=blue(land.pixels[i]);
          land.pixels[i] = color(rv,gv,bv,0);
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

void shredHole(float atX_f,float atY_f,int rad,int count) {
  int atX=int(atX_f);
  int atY=int(atY_f);
  
  land.loadPixels(); // load colors from image into land.pixels[] array
  
  for(int i=0;i<count;i++) {
    float rang = radians(random(360)); // pick a random direction
    float d = 1+random(rad); // at a random distance in that direction
    int nx = int(atX+d*cos(rang)); // identify which x position that direction/angle refers to
    
    if(nx > 0 && nx < land.width-1) { // if we let it go too far left or right, blast damage would wrap
      int dest = nx+int(atY+d*sin(rang))*land.width; // determine target position to erase
      
      if(dest >= 0 && dest < land.pixels.length) { // only if the target pixel is in the total image
        land.pixels[dest] = color(255,0,0,0); // draw a transparent pixel there to hide it
      }
    }
  }
  
  land.updatePixels(); // update colors into image from land.pixels[] array
}

void mousePressed() {
  shredHole(mouseX,mouseY,90,2500);
}

void draw() {
  landGravity();

  image(sky,0,0);
  image(land,0,0);
}
