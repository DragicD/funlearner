import ddf.minim.*;
Minim minim;
AudioPlayer music;
AudioSample sndBombBigHit, sndBombDrop, sndBombHit, sndBombletHit,
            sndBulletDirt, sndBulletDirt2, sndClusterSplit, sndCrash,
            sndGua8, sndBlast, sndDie, sndDie2, sndDie3, sndDie4,
            sndEng1, sndEng2, sndEng3, sndNapalm, sndRocketHit, sndEmpty;

PImage sky,land,bombletImg,bombImg,clusterImg,missileImg,napalmImg,loadingImg;
PImage debrisImg,smokeImg,glowImg,clumpImg;
PImage tankImg,guyImg,guy_2_Img,heliImg,planeImg;

Boolean gameStarted = false;

int gravRefreshTimer=0;
int enemySpawnTimer=0;

PFont font;

float cameraOffsetX,cameraOffsetY;
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
Boolean paused = false;

final boolean SHOW_DEBUG = false; // setting to true displays land optimization visualization
final int WORLD_SIZE = 2352;
final int GRAV_OPT_UPDATE_FREQ = 55;

int[] gravTop = new int[WORLD_SIZE];
int[] gravBot = new int[WORLD_SIZE];

ArrayList bombList,enemyList;
ParticleSet pfx = new ParticleSet();
Plane pl = new Plane();

int heightAt(int posX) {
  if(posX < 0) {
    posX = 0;
  }
  if(posX > WORLD_SIZE-1) {
    posX = WORLD_SIZE-1;
  }
  for(int h=0;h<land.height;h++) {
    if( alpha(land.pixels[posX+h*WORLD_SIZE])>0 ) {
      gravTop[posX]=h-1;
      break;
    }
  }
  return gravTop[posX]+landOffY+1;
}

int startEnemySpawnX() {
  return int(WORLD_SIZE/2+random(WORLD_SIZE/2)-5);
}

void resetGame() {
  land = loadImage("land.gif");
  
  landOffY = land.height;

  gravOptUpdate(0,WORLD_SIZE);
  for (int i = bombList.size()-1; i >= 0; i--) { 
    bombList.remove(i);
  }
  for (int i = enemyList.size()-1; i >= 0; i--) { 
    enemyList.remove(i);
  }
  pfx.removeAll();
  pl.respawn();
  
  int startEnemies = 10+int(random(25));
  for(int i=0;i<startEnemies;i++) {
    int posX = startEnemySpawnX();
    switch(int(random(10))) {
      case 0: 
      case 1: 
        enemyList.add(new Enemy(posX,tankImg));
        break;
      case 2: 
      case 3: 
        enemyList.add(new Enemy(posX,heliImg));
        break;
      default: 
        enemyList.add(new Enemy(posX,guyImg));
        break;
    }
  }  
}

void debugDrawGrav() {
  tint(255,255,255);
  stroke(255,255,0,180);
  for(int i=0;i<WORLD_SIZE;i++) {
    line(i,gravTop[i]+landOffY,i,gravBot[i]+landOffY);
  }
}

void gravOptUpdate(int leftSide, int rightSide) {
  int h;
  if(leftSide < 0) {
    leftSide = 0;
  }
  if(rightSide > WORLD_SIZE) {
    rightSide = WORLD_SIZE;
  }
  land.loadPixels();
  for(int i=leftSide;i<rightSide;i++) {
    for(h=0;h<land.height;h++) {
      if( alpha(land.pixels[i+h*WORLD_SIZE])>0 ) {
        gravTop[i]=h-1;
        break;
      }
    }
    gravBot[i]=gravTop[i];
    for(h=land.height-1;h>gravTop[i];h--) {
      if( alpha(land.pixels[i+h*WORLD_SIZE])<255 ) {
        gravBot[i]=h;
        break;
      }
    }
  }
}

void setup() {
  System.gc();
  
  size(717,509);
  
  cameraOffsetX=0;
  cameraOffsetY=0;
  sky = loadImage("bg.jpg");
  bombImg = loadImage("bomb.png");
  clusterImg = loadImage("cluster.png");
  bombletImg = loadImage("bomblet.png");
  missileImg = loadImage("missile.png");
  napalmImg = loadImage("napalm.png");

  loadingImg = loadImage("loading.gif");
  
  debrisImg = loadImage("debris.png");
  smokeImg = loadImage("smoke.png");
  glowImg = loadImage("glow.png");
  clumpImg = loadImage("clump.png");

  tankImg = loadImage("tank.png");
  guyImg = loadImage("guy.png");
  guy_2_Img = loadImage("guy2.png");
  heliImg = loadImage("heli.png");
  planeImg = loadImage("plane.png");
  
  bombList = new ArrayList();
  enemyList = new ArrayList();

  minim = new Minim(this);
  music = minim.loadFile("CoolHardFacts.mp3", 1024);
  music.loop();
  int buffersize = 256;
  sndBombBigHit = minim.loadSample("bombbighit.wav", buffersize);
  sndBombDrop = minim.loadSample("bombdrop.wav", buffersize);
  sndBombHit = minim.loadSample("bombhit.wav", buffersize);
  sndBombletHit = minim.loadSample("bomblethit.wav", buffersize);
  sndBulletDirt = minim.loadSample("bulletdirt.wav", buffersize);
  sndBulletDirt2 = minim.loadSample("bulletdirt2.wav", buffersize);
  sndClusterSplit = minim.loadSample("clustersplit.wav", buffersize);
  sndCrash = minim.loadSample("crash.wav", buffersize);
  sndGua8 = minim.loadSample("gua8.wav", buffersize);
  sndBlast = minim.loadSample("gunblast.wav", buffersize);
  sndDie = minim.loadSample("guydie.wav", buffersize);
  sndDie2 = minim.loadSample("guydie2.wav", buffersize);
  sndDie3 = minim.loadSample("guydie3.wav", buffersize);
  sndDie4 = minim.loadSample("guydie4.wav", buffersize);
  sndEng1 = minim.loadSample("engine1.wav", buffersize);
  sndEng2 = minim.loadSample("engine2.wav", buffersize);
  sndEng3 = minim.loadSample("engine3.wav", buffersize);
  sndNapalm = minim.loadSample("napalm.wav", buffersize);
  sndRocketHit = minim.loadSample("rockethit.wav", buffersize);
  sndEmpty = minim.loadSample("empty.wav", buffersize);

  resetGame();
  
  font = loadFont("Monospaced-13.vlw");
  
  pfx.setImg(ParticleSet.TYPE_GLOW,glowImg);
  pfx.setImg(ParticleSet.TYPE_SMOKE,smokeImg);
  pfx.setImg(ParticleSet.TYPE_DEBRIS,debrisImg);  
  pfx.setImg(ParticleSet.TYPE_LIGHT,glowImg);
  pfx.setImg(ParticleSet.TYPE_TRAIL,smokeImg);
  pfx.setImg(ParticleSet.TYPE_CANNON_TRAIL,smokeImg);
  pfx.setImg(ParticleSet.TYPE_CLUMP,clumpImg);
  
  shakeAmt = 0.0;

  background(0);
  
  frameRate(24);
}

void landGravity() {
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
      if(j+dx-1>0 && j+dx+1<WORLD_SIZE) {
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
}

void drawSquare(int atX,int atY,int rad,int rv,int gv,int bv) {
  int l = atX-rad;
  int r = atX+rad;
  int t = atY-rad-landOffY;
  int b = atY+rad-landOffY;
  if(l<0) {
    l=0;
  }
  if(r>=WORLD_SIZE) {
    r=WORLD_SIZE-1;
  }
  if(t<0) {
    t=0;
  }
  if(b>=land.height) {
    b=land.height-1;
  }
  for(int i=l;i<r+1;i++) {
    for(int ii=t;ii<b+1;ii++) {
      
      if(random(3)<1.5) {
        land.pixels[i+ii*WORLD_SIZE] = color(rv,gv,bv,0);
        continue;
      }
      
      float trv=rv+random(-10,10);
      float tgv=gv+random(-10,10);
      float tbv=bv+random(-10,10);
      if(rv<0) rv=0;
      else if(rv>255) rv=255;
      if(gv<0) gv=0;
      else if(gv>255) gv=255;
      if(bv<0) bv=0;
      else if(bv>255) bv=255;
      
      land.pixels[i+ii*WORLD_SIZE] = color(trv,tgv,tbv,255);
    }
  }
  for(int i=atX-rad;i<atX+rad;i++) {
    if(i>0 && i<WORLD_SIZE) {
      if(gravTop[i]>=atY-landOffY-rad) {
        gravTop[i]=atY-landOffY-rad-1;
      }
      if(gravBot[i]<atY-landOffY+rad) {
        gravBot[i]=atY-landOffY+rad+1;
      }
    }
  }
}

void shredHole(float atX_f,float atY_f,int rad,int count) {
  int atX=int(atX_f);
  int atY=int(atY_f)-landOffY;
  
  for (int i = enemyList.size()-1; i >= 0; i--) { 
    Enemy enemy = (Enemy) enemyList.get(i);
    if(enemy.pos.dist(new PVector(atX_f,atY_f))<rad*0.7) {
      switch(enemy.type) {
        case Enemy.TYPE_TANK:
          sndBombHit.trigger();
          break;
        case Enemy.TYPE_GUY:
          switch(int(random(4))) {
            case 0:
              sndDie.trigger();
              break;
            case 1:
              sndDie2.trigger();
              break;
            case 2:
              sndDie3.trigger();
              break;
            case 3:
              sndDie4.trigger();
              break;
          }
          break;
        case Enemy.TYPE_HELI:
          sndBombHit.trigger();
          break;
      }
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
        float rv=red(land.pixels[dest]);
        float gv=green(land.pixels[dest]);
        float bv=blue(land.pixels[dest]);
        land.pixels[dest] = color(rv,gv,bv,0);
      }
    }
  }

  gravOptUpdate(int(atX_f)-rad,int(atX_f)+rad);
}

void handleProjectiles() {
  for (int i = bombList.size()-1; i >= 0; i--) { 
    Bomb bomb = (Bomb) bombList.get(i);
    
    for(int j=0;j<(bomb.type==Bomb.TYPE_CANNON ? 10 : 1);j++) {
      bomb.handle();
      if (bomb.finished()) {
        bombList.remove(i);
        break;
      }
    }
  }
}

void handleEnemies() {
  if(enemySpawnTimer--<0) {
    enemySpawnTimer=30+int(random(30));
    switch(int(random(10))) {
      case 0: 
      case 1: 
        enemyList.add(new Enemy(WORLD_SIZE,tankImg));
        break;
      case 2: 
      case 3: 
        enemyList.add(new Enemy(WORLD_SIZE,heliImg));
        break;
      default: 
        enemyList.add(new Enemy(WORLD_SIZE,guyImg));
        break;
    }
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
  if (keyCode == TAB) {
    resetGame();    
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

void mousePressed() {
  if(gameStarted==false) {
    gameStarted = true;
  }
}

void draw() {
  if(focused==false || gameStarted==false) {
    tint(120,120,120);
    image(loadingImg,0,0);
    fill(255);
    textSize(13);
    textFont(font);
    
    textAlign(CENTER);
    text("Click in this area\nto unpause action.\n\nUse keys to fly and attack.\n(See top-right for controls.)", width/2, height-88);
  } else {
    tint(255,255,255);
    cameraPosition();
    
    image(sky,0,0);
    
    pushMatrix();
    translate(-cameraOffsetX,-cameraOffsetY);
      
    if(gravRefreshTimer++>=GRAV_OPT_UPDATE_FREQ) {
      gravRefreshTimer=0;
      gravOptUpdate(0,WORLD_SIZE);
    }
    
    land.loadPixels();    
    landGravity();
    handleProjectiles();
  
    pfx.handle(false);
  
    pl.handle();
  
    land.updatePixels();
    
    image(land,0,landOffY);
  
    if(SHOW_DEBUG) {
      debugDrawGrav();
    }
  
    handleEnemies();
    
    pfx.handle(true);  
    popMatrix(); // undo camera movement
    
    popMatrix(); // undo explosive shake
  }
  
  textSize(13);
  textFont(font);
  if(focused && gameStarted) {
    fill(0);
    if(pl.isAlive) {
      int displaySpeed = int(pl.speed*100);
      int originalMin = 375;
      int originalMax = 1224;
      int accurateMin = 138;
      int accurateMax = 453;
      displaySpeed = (accurateMax-accurateMin)*(displaySpeed-originalMin)/(originalMax-originalMin)+accurateMin;
      textAlign(LEFT);
      text("(Sp)Gun:" + (pl.ammo_gun) + "\n(A) Bomb:" + (pl.ammo_bomb) +"\n(S) Cluster:" + (pl.ammo_cluster) + "\n(D) Fire:" + (pl.ammo_fire) + "\n(F) Rocket:" + (pl.ammo_missile), 10, 20);

      textAlign(CENTER);
      text("HobbyGameDev Plane Demo\n"+displaySpeed + " mph\n" + int(pl.alt) + " ft", width/2, 20);
      textAlign(RIGHT);
      text("Left/Right - Throttle\nUp/Down - Pitch\nA,S,D,F - Bombs\nSpace - Cannon\nTab - Reset", width-10, 20);
    } else {
      textAlign(CENTER);
      text("Press SPACE to Reset Plane\nOr TAB to Reset Everything", width/2, height/2-25);
    }
  } else {
    fill(255);
    textAlign(LEFT);
    text("(Spacebar) Auto Cannon\n(A Key) Bomb\n(S Key) Cluster\n(D Key) Fire Bomb\n(F Key) Guided Rocket", 10, 20);
    textAlign(CENTER);
    text("HobbyGameDev Plane Demo\nNotgame by Chris DeLeon\nMusic by Kevin MacLeod\nNo winning or losing.\nJust playing.", width/2, 20);
    textAlign(RIGHT);
    text("Left/Right - Throttle\nUp/Down - Pitch\nA,S,D,F - Bombs\nSpace - Cannon\nTab - Reset", width-10, 20);
  }
}

void stop() {
  music.close();
  sndBombBigHit.close();
  sndBombDrop.close();
  sndBombHit.close();
  sndBombletHit.close();
  sndBulletDirt.close();
  sndBulletDirt2.close();
  sndClusterSplit.close();
  sndCrash.close();
  sndGua8.close();
  sndBlast.close();
  sndDie.close();
  sndDie2.close();
  sndDie3.close();
  sndDie4.close();
  sndEng1.close();
  sndEng2.close();
  sndEng3.close();
  sndNapalm.close();
  sndRocketHit.close();
  sndEmpty.close();
  
  minim.stop();

  super.stop();
}
