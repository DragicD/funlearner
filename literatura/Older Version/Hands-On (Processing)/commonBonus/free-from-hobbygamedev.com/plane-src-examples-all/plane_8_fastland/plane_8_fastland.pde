PImage sky,land;
PImage bombImg;
PImage tankImg;
PImage planeImg;

ArrayList bombList;
ArrayList enemyList;

Plane pl = new Plane();

int enemySpawnTimer = 0;

int gravRefreshTimer=0; // tracks frequency of full soil gravity updates

PFont font;

float cameraOffsetX, cameraOffsetY;
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

final int WORLD_SIZE = 2352;
final int GRAV_OPT_UPDATE_FREQ = 55;  // refreshes all soil gravity heights after this # of cycles

int[] gravTop = new int[WORLD_SIZE];
int[] gravBot = new int[WORLD_SIZE];

void spawnStartEnemies() {
  int startEnemies = 12;
  for(int i=0;i<startEnemies;i++) {
    enemyList.add(new Enemy(int(random(WORLD_SIZE))));
  }
}

void debugDrawGrav() { // shows the land area that dirt gravity is currently calculated for
  tint(255,255,255);
  stroke(255,255,0,180);
  for(int i=0;i<WORLD_SIZE;i++) {
    line(i,gravTop[i]+landOffY,i,gravBot[i]+landOffY);
  }
}

// fully updates dirt gravity top and bottoms, from leftSide to rightSide
void gravOptUpdate(int leftSide, int rightSide) {
  int h;
  if(leftSide < 0) {
    leftSide = 0;
  }
  if(rightSide > WORLD_SIZE) {
    rightSide = WORLD_SIZE;
  }
  land.loadPixels(); // remember that this is needed for land.pixels[] to be up to date
  for(int i=leftSide;i<rightSide;i++) {
    for(h=0;h<land.height;h++) { // starting from the top
      if( alpha(land.pixels[i+h*WORLD_SIZE])>0 ) { // find the first non-transparent one
        gravTop[i]=h-1;
        break;
      }
    }
    gravBot[i]=gravTop[i];
    for(h=land.height-1;h>gravTop[i];h--) { // starting from the bottom
      if( alpha(land.pixels[i+h*WORLD_SIZE])<255 ) { // find the first non-solid one
        gravBot[i]=h;
        break;
      }
    }
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
  planeImg = loadImage("plane.png");
  
  font = loadFont("Monospaced-13.vlw");

  landOffY = land.height;
  
  gravOptUpdate(0,WORLD_SIZE); // update range program considers for dirt gravity
  
  bombList = new ArrayList();
  enemyList = new ArrayList();

  spawnStartEnemies();
  pl.respawn();

  frameRate(60); // setting higher than needed to make optimization more apparent
  // in later versions we'll cap this instead at 24 for consistency with low
  // and high performance machines
}

void landGravity() {
  land.loadPixels();
  for(int j=0;j<WORLD_SIZE;j++) {
    for(int k=gravBot[j];k>gravTop[j];k--) {
      int i = j+k*WORLD_SIZE;
      if(i<0 || i>=land.pixels.length-2*WORLD_SIZE-1) {
        continue;
      }
      color c = land.pixels[i];
      color comp = land.pixels[i+WORLD_SIZE];
      color comp2 = land.pixels[i+2*WORLD_SIZE];
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
      } else if(random(4)<1 && i+1+2*WORLD_SIZE < land.pixels.length) {
        comp = land.pixels[i-1+WORLD_SIZE];
        comp2 = land.pixels[i+1+WORLD_SIZE];
        
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
        if(random(2)<1 && i%WORLD_SIZE>=0) {
          if(ac>alpha(land.pixels[i+dx-1+dy*WORLD_SIZE])) {
            dx--;
          }
        }
        if(random(2)<1 && i%WORLD_SIZE<WORLD_SIZE) {
          if(ac>alpha(land.pixels[i+dx+1+dy*WORLD_SIZE])) {
            dx++;
          }
        }
      }
      
      float rv=red(land.pixels[i]);
      float gv=green(land.pixels[i]);
      float bv=blue(land.pixels[i]);
      if(j+dx-1>0 && j+dx+1<WORLD_SIZE) { // adjust tops to keep up with side drifting dirt
        if(gravTop[j+dx-1]>=k+dy) {
          gravTop[j+dx-1]=k+dy-1;
        }
        if(gravTop[j+dx]>=k+dy) {
          gravTop[j+dx]=k+dy-1;
        }
        if(gravTop[j+dx+1]>=k+dy) {
          gravTop[j+dx+1]=k+dy-1;
        }
      }
      land.pixels[i] = color(rv,gv,bv,0);
      land.pixels[i+dx+dy*WORLD_SIZE] = c;
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
    
    if(nx > 0 && nx < WORLD_SIZE-1) {
      int dest = nx+int(atY+d*sin(rang))*WORLD_SIZE;
      
      if(dest >= 0 && dest < land.pixels.length) {
        land.pixels[dest] = color(255,255,255,0);
      }
    }
  }
  
  land.updatePixels();
  
  // update local heights to account for the new damage
  gravOptUpdate(int(atX_f)-rad,int(atX_f)+rad);
}

int heightAt(int posX) {
  if(posX < 0) {
    posX = 0;
  }
  if(posX > WORLD_SIZE-1) {
    posX = WORLD_SIZE-1;
  }
  for(int h=0;h<land.height;h++) {
    if( alpha(land.pixels[posX+h*WORLD_SIZE])>0 ) {
      gravTop[posX]=h-1; // updates hightest relevant gravity point
      break;
    }
  }
  return gravTop[posX]+landOffY+1; // returns the stored point
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
    enemyList.add(new Enemy(WORLD_SIZE-2));
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
  cameraOffsetY = pl.pos.y-int(height*0.3);
  
  if(cameraOffsetY>0) {
    cameraOffsetY=0;
  }
  
  cameraOffsetX = pl.pos.x-int(width*0.4);
  
  if(cameraOffsetX>WORLD_SIZE-width-1) {
    cameraOffsetX=WORLD_SIZE-width-1;
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
  if(focused) {
    cameraPosition();
    
    // periodically, does a full refresh of soil height considerations
    if(gravRefreshTimer++>=GRAV_OPT_UPDATE_FREQ) {
      gravRefreshTimer=0;
      gravOptUpdate(0,WORLD_SIZE);
    }
    
    landGravity();
  
    image(sky,0,0);
  
    pushMatrix();
    translate(-cameraOffsetX,-cameraOffsetY);
  
    handleBombs(); 
    pl.handle();
    
    handleEnemies();
  
    image(land,0,landOffY);
    
    // this new function reveals the area being considered for dirt gravity
    // uncomment it to see the area being checked for land fall after blasts
    // note that drawing these yellow strips will slow framerate a bit!
    // debugDrawGrav(); // for demonstration purposes only! not intented for actual gameplay

    popMatrix();
  
    popMatrix();
    
    fill(0);
    textSize(13);
    textFont(font);
    textAlign(CENTER);
    if(pl.isAlive==false) { // player crashed plane?
      text("Spacebar to Reset Plane", width/2, height/2-18);
    } else {
      text(int(frameRate) + " fps", width/2, 18); // showing frames per second, as indicator of performance
    }

  } else {

    background(0);
    
    fill(255);
    textSize(13);
    textFont(font);
    textAlign(CENTER);
    
    text("Click in this area\nthen use arrow keys\nto control plane.\n\nSpacebar to attack.", width/2, height/2-38);
  }
}
