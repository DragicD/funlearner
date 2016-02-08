PImage sky,land;
PImage bombImg;
PImage tankImg;
PImage planeImg; // image for player's plane

ArrayList bombList;
ArrayList enemyList;

Plane pl = new Plane(); // player's ride

int enemySpawnTimer = 0;

PFont font; // used to keep track of font for on-screen text

float cameraOffsetX, cameraOffsetY; // adding cameraOffsetY for plane to fly high
float shakeAmt;
int landOffY;

Boolean holdingUp = false;
Boolean holdingDown = false;
Boolean holdingLeft = false;
Boolean holdingRight = false;
Boolean holdingSpace = false;
Boolean holdingA = false;
Boolean holdingS = false;
Boolean holdingD = false;
Boolean holdingF = false;

void spawnStartEnemies() {
  int startEnemies = 12;
  for(int i=0;i<startEnemies;i++) {
    enemyList.add(new Enemy(int(random(land.width))));
  }
}

void setup() {
  size(717,509);
  
  cameraOffsetX = 0;
  cameraOffsetY = 0;
  shakeAmt = 0.0;

  sky = loadImage("bg.jpg");
  land = loadImage("land.gif");
  bombImg = loadImage("bomb.png");
  tankImg = loadImage("tank.png");
  planeImg = loadImage("plane.png"); // load the plane image
  
  // Use the "Tools" menu in Processing and select "Create Font" to make a vlw font when needed
  // that's how I made the one used here:
  font = loadFont("Monospaced-13.vlw"); // load font

  landOffY = land.height;
  
  bombList = new ArrayList();
  enemyList = new ArrayList();

  spawnStartEnemies();
  pl.respawn(); // create player plane

  frameRate(60); // setting higher than needed to make slowdown more apparent
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
  int atY=int(atY_f)-landOffY;
  
  land.loadPixels();
  
  for (int i = enemyList.size()-1; i >= 0; i--) { 
    Enemy enemy = (Enemy) enemyList.get(i);
    if(enemy.pos.dist(new PVector(atX_f,atY_f))<rad*0.7) {
      enemyList.remove(i);
    }
  }
  
  for(int i=0;i<count;i++) {
    float rang = radians(random(360));
    float d = 1+random(rad);
    int nx = int(atX+d*cos(rang));
    
    if(nx > 0 && nx < land.width-1) {
      int dest = nx+int(atY+d*sin(rang))*land.width;
      
      if(dest >= 0 && dest < land.pixels.length) {
        land.pixels[dest] = color(255,255,255,0);
      }
    }
  }
  
  land.updatePixels();
}

int heightAt(int posX) {
  if(posX < 0) {
    posX = 0;
  }
  if(posX > land.width-1) {
    posX = land.width-1;
  }
  
  for(int h=0;h<land.height;h++) {
    if( alpha(land.pixels[posX+h*land.width])>0 ) {
      return h+landOffY-1;
    }
  }
  return land.height+landOffY;
}

void handleBombs() {
  for (int i = bombList.size()-1; i >= 0; i--) {
    Bomb bomb = (Bomb) bombList.get(i);
    
    bomb.handle();
    
    if (bomb.finished()) {
      bombList.remove(i);
    }
  }
}

void handleEnemies() {
  if(enemySpawnTimer--<0) {
    enemySpawnTimer=60+int(random(60));
    enemyList.add(new Enemy(land.width-2));
  }

  for (int i = enemyList.size()-1; i >= 0; i--) { 
    Enemy enemy = (Enemy) enemyList.get(i);
    
    enemy.handle();
    
    if (enemy.finished()) {
      enemyList.remove(i);
    }
  }
}

void cameraPosition() {
  // balance camera position so it shows mostly in front and below...
  // but don't make the camera too forward looking, or explosions behind plane won't be visible :D
  cameraOffsetY = pl.pos.y-int(height*0.3);
  
  if(cameraOffsetY>0) {
    cameraOffsetY=0;
  }
  
  cameraOffsetX = pl.pos.x-int(width*0.4);
  
  if(cameraOffsetX>land.width-width-1) {
    cameraOffsetX=land.width-width-1;
  }
  if(cameraOffsetX<0) {
    cameraOffsetX=0;
  }
  
  float rang = radians(random(360));
  pushMatrix();
  translate(abs(sin(rang)*shakeAmt),abs(cos(rang)*shakeAmt));

  shakeAmt *= 0.35;
}

void keyPressed() {
  if (keyCode == UP) {
    holdingUp = true;
  }
  if (keyCode == DOWN) {
    holdingDown = true;
  }
  if (keyCode == LEFT) {
    holdingLeft = true;
  }
  if (keyCode == RIGHT) {
    holdingRight = true;
  }
  if (key == 'a') {
    holdingA = true;
  }
  if (key == 's') {
    holdingS = true;
  }
  if (key == 'd') {
    holdingD = true;
  }
  if (key == 'f') {
    holdingF = true;
  }  
  if (key == ' ') {
    holdingSpace = true;
  }
}

void keyReleased() {
  if (keyCode == UP) {
    holdingUp = false;
  }
  if (keyCode == DOWN) {
    holdingDown = false;
  }
  if (keyCode == LEFT) {
    holdingLeft = false;
  }
  if (keyCode == RIGHT) {
    holdingRight = false;
  }
  if (key == 'a') {
    holdingA = false;
  }
  if (key == 's') {
    holdingS = false;
  }
  if (key == 'd') {
    holdingD = false;
  }
  if (key == 'f') {
    holdingF = false;
  }
  if (key == ' ') {
    holdingSpace = false;
  }
}

void draw() {
  if(focused) { // in Processing, focused is true if the user clicked the window (so it can detect keys)
    cameraPosition();
    
    landGravity();
  
    image(sky,0,0);
  
    pushMatrix();
    translate(-cameraOffsetX,-cameraOffsetY);
  
    handleBombs(); 
    pl.handle(); // move and draw plane
    handleEnemies();
  
    image(land,0,landOffY);
    popMatrix(); // undo camera offset adjustment
  
    popMatrix(); // undo explosive shake adjustment
    
    // for comments on how these work, see the else (focused==false) branch parallel to this one down below
    fill(0);
    textSize(13);
    textFont(font);
    textAlign(CENTER);
    if(pl.isAlive==false) { // player crashed plane?
      text("Spacebar to Reset Plane", width/2, height/2-18);
    } else {
      text(int(frameRate) + " fps", width/2, 18); // showing frames per second, as indicator of performance
    }

  } else { // program does not have focus, so we'll pause it 

    background(0); // black out the entire screen (paused)
    
    fill(255); // white font
    textSize(13); // font size 13
    textFont(font); // load the font we have in memory
    textAlign(CENTER); // center the text
    
    // This function takes the text string, then x position, then y position.
    // the above function calls set up which color, size, font, and alignment it uses
    // width and height here refer to the program's dimensions, as set by size(,) in setup()
    // the "slash n" mark, \n , means "new line" and breaks text like the enter key
    text("Click in this area\nthen use arrow keys\nto control plane.\n\nSpacebar to attack.", width/2, height/2-38);
  }
}
