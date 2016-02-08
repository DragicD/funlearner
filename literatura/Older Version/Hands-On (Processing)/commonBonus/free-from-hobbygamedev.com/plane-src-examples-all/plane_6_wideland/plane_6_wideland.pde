PImage sky,land;
PImage bombImg;
PImage tankImg;

ArrayList bombList;
ArrayList enemyList;

int enemySpawnTimer = 0;

float cameraOffsetX;
float shakeAmt;
int landOffY;

void spawnStartEnemies() {
  int startEnemies = 12;
  for(int i=0;i<startEnemies;i++) {
    enemyList.add(new Enemy(int(random(land.width))));
  }
}

void setup() {
  size(717,509);
  
  cameraOffsetX = 0; // camera starts at far left
  shakeAmt = 0.0; // zero shake until bombs go off

  sky = loadImage("bg.jpg");
  land = loadImage("land.gif");
  bombImg = loadImage("bomb.png");
  tankImg = loadImage("tank.png");

  landOffY = land.height; // only using land on the bottom half of the window
  
  bombList = new ArrayList();
  enemyList = new ArrayList();

  spawnStartEnemies();

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
  return land.height+landOffY; // account for displacement of land bitmap
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
  if(mouseX < 0.15*width) { // mouse on left 15% of window?
    cameraOffsetX -= 10.0; // slide camera left
  }
  if(mouseX > 0.85*width) { // mouse on right 15% of window?
    cameraOffsetX += 10.0; // slide camera right
  }
  
  // keep the camera position over the land
  if(cameraOffsetX>land.width-width-1) {
    cameraOffsetX=land.width-width-1;
  }
  if(cameraOffsetX<0) {
    cameraOffsetX=0;
  }
  
  float rang = radians(random(360)); // random angle for shake direction
  pushMatrix(); // the following positioning change applies until we popMatrix()
  translate(abs(sin(rang)*shakeAmt),abs(cos(rang)*shakeAmt));

  shakeAmt *= 0.35; // decrease shake each frame  
}


void mousePressed() {
  bombList.add(new Bomb());
}

void draw() {
  cameraPosition();
  
  landGravity();

  image(sky,0,0);

  pushMatrix(); // the following positioning change applies until we popMatrix()
  translate(-cameraOffsetX,0.0);

  handleBombs(); 
  handleEnemies();

  image(land,0,landOffY);

  popMatrix(); // undo camera offset adjustment

  popMatrix(); // undo explosive shake adjustment
}
