import ddf.minim.*;
Minim minim;
AudioPlayer music;
AudioSample sndBigBlast, sndBang1, sndBang2, 
            sndBang3, sndBang4;

boolean debugShowBias;

ArrayList fbList = new ArrayList();

final float GAME_SCALE = 2.0f; // pixel doubling, 25% the calculations

PImage viewLayer = new PImage();
PImage updateLayer = new PImage();
PImage boomLayer = new PImage();
PImage biasLayer = new PImage();

int rcount=0;
int bcount=0;

float brand = 5;
float rrand = 5;
int bfaceconf = 0;
int rfaceconf = 0;

final int DIR_UP=0;
final int DIR_RIGHT=1;
final int DIR_DOWN=2;
final int DIR_LEFT=3;

int dir180(int fromDir) {
  fromDir += 2;
  if (fromDir > 3) {
    fromDir -=4;
  }
  return fromDir;
}

int adjustedMouseX() {
  return (int)(mouseX/GAME_SCALE);
}
int adjustedMouseY() {
  return (int)(mouseY/GAME_SCALE);
}

final int TYPE_SPACE=0;
final int TYPE_RED=1;
final int TYPE_BLUE=2;
final int TYPE_WALL=3;

final int VIEW_WIDTH = 800;
final int VIEW_HEIGHT = 600;
final int GAME_WIDTH = VIEW_WIDTH/2;
final int GAME_HEIGHT = VIEW_HEIGHT/2;

int biasErodeUpdate;
final int BIAS_ERODE_FREQ = 10;

void setup() {
  size(VIEW_WIDTH, VIEW_HEIGHT);
  viewLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  updateLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  boomLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  biasLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  noStroke();

  int buffersize = 256;
  minim = new Minim(this);
  sndBigBlast = minim.loadSample("bigblast.wav", buffersize);
  sndBang1 = minim.loadSample("bang1.wav", buffersize);
  sndBang2 = minim.loadSample("bang2.wav", buffersize);
  sndBang3 = minim.loadSample("bang3.wav", buffersize);
  sndBang4 = minim.loadSample("bang4.wav", buffersize);

  loadFaces();

  paintLayer(GAME_WIDTH/2, GAME_HEIGHT/2, GAME_WIDTH/2, TYPE_WALL);
}

void draw() {
  keyTake();
  //background(0);
  pushMatrix();
  scale(GAME_SCALE);
  fill(0, 0, 0, 54);
  rect(0, 0, GAME_WIDTH, GAME_HEIGHT);
  considerTideShift();

  int battleSteps = (int)random(4, 7);
  for (int i=0;i< battleSteps;i++) {
    battleSimStep();
  }
  boomLayer.updatePixels();
    
  clearBoomLayer();
  image(viewLayer, 0, 0);
  image(boomLayer, 0, 0);
  if(debugShowBias) {
    tint(255,255,255,100);
    image(biasLayer, 0, 0);
  }
  popMatrix();
  biasErodeUpdate--;
  float erodeAng = random(2.0f*PI)
         /*2.0f*PI*((float)biasErodeUpdate)/
                   ((float)BIAS_ERODE_FREQ)*/;
  if(biasErodeUpdate<0) {
    biasErodeUpdate = BIAS_ERODE_FREQ;
    biasLayer.filter(ERODE);
    biasLayer.filter(BLUR,1);
  }
  biasLayer.loadPixels();
  for(int i=fbList.size()-1;i>=0;i--) {
    FaceBubble eachFB = (FaceBubble)fbList.get(i);
    eachFB.drawMe();
    float randDist = random(10,25);
    paintBias((int)(eachFB.x/GAME_SCALE+
              randDist*sin(erodeAng)),
              (int)(eachFB.y/GAME_SCALE+
              randDist*cos(erodeAng)),
              (int)((eachFB.teamType == TYPE_RED ?
                (brand - rrand) : 
                (rrand - brand))+1+eachFB.myConf)*4,eachFB.teamType);

    if(eachFB.removeMe) {
      fbList.remove(i);
    }
  }
  biasLayer.updatePixels();

  pushMatrix();
  scale(GAME_SCALE);
  drawUI();
  popMatrix();
}

void drawUI() {
  int sum = rcount+bcount;
  float rperc = -1.0;
  if (sum != 0) {
    rperc = ((float)rcount)/((float)sum);
    int rpos = (int)(GAME_WIDTH*rperc);
    fill(100, 100, 255);
    rect(rpos, 0, GAME_WIDTH-rpos, 20);
    fill(255, 50, 50);
    rect(0, 0, rpos, 20);
  } 
  else {
    fill(100, 100, 100);
    rect(0, 0, GAME_WIDTH, 20);
  }
  textAlign(LEFT);
  fill(50, 0, 0);
  text(rcount, 15, 35);
  if (rperc >= 0.0) {
    text(nf(rperc*100.0, 3, 1)+"%", 15, 15);
  } 
  else {
    text("---.-%", 15, 15);
  }
  textAlign(RIGHT);
  fill(0, 0, 50);
  text(bcount, GAME_WIDTH-1-15, 35);
  if (rperc >= 0.0) {
    text(nf((1.0-rperc)*100.0, 3, 1)+"%", GAME_WIDTH-1-15, 15);
  } 
  else {
    text("---.-%", GAME_WIDTH-1-15, 15);
  }

  textAlign(LEFT);
  fill(0,0,0);
  text("(hold+drag any) Q: hole  W: red  E: blue  R: wall  D: face forces", 5, GAME_HEIGHT-8);
}

void mouseDragged() {
  paintLayer(adjustedMouseX(), adjustedMouseY(), 10, 0);
}

void mousePressed() {
  paintLayer(adjustedMouseX(), adjustedMouseY(), 15, 0);
}

void boom(int atX, int atY, color col) {
  if (random(20)<2) {
    sndBigBlast.trigger();
  }
  paintLayer(atX, atY, 6, TYPE_SPACE);
  paintLayer(atX, atY, 3, color2type(col));

  for (int i=0;i<25;i++) {
    float rang = random(2*PI);
    float d = random(0, 7);
    blastEffect((int)(atX+sin(rang)*d), 
    (int)(atY+cos(rang)*d), col);
  }
}

void blastEffect(int atX, int atY, color col) {
  int rad = 1;

  int left=atX-rad;
  int right=atX+rad+1;
  int top=atY-rad;
  int bottom=atY+rad+1;

  // we want to make sure that the left, right, top, and bottom are within the image dimensions
  if (left < 0) {
    left = 0;
  }
  if (right > viewLayer.width-1) {
    right = viewLayer.width-1;
  }
  if (top < 0) {
    top = 0;
  }
  if (bottom > viewLayer.height-1) {
    bottom = viewLayer.height-1;
  }

  if (atX < 0) {
    atX = 0;
  }
  if (atY < 0) {
    atY = 0;
  }
  if (atX > viewLayer.width-1) {
    atX = viewLayer.width-1;
  }
  if (atY > viewLayer.height-1) {
    atY = viewLayer.height-1;
  }

  int dest;
  for (int x=left;x<right;x++) {
    dest = x+atY*viewLayer.width;
    boomLayer.pixels[dest] = col;
  }
  for (int y=top;y<bottom;y++) {
    dest = atX+y*viewLayer.width;
    boomLayer.pixels[dest] = col;
  }
}

int safeGetPixelAt(float atX,float atY) {
  int safeX=(int)(atX/GAME_SCALE),
      safeY=(int)(atY/GAME_SCALE);
  if(safeX < 0) {
    safeX = 0;
  }
  if(safeX >= viewLayer.width) {
    safeX = viewLayer.width-1;
  }
  if(safeY < 0) {
    safeY = 0;
  }
  if(safeY >= viewLayer.height) {
    safeY = viewLayer.height-1;
  }
  int dest = safeX+safeY*viewLayer.width;
  return color2type( viewLayer.pixels[dest] );
}

void paintLayer(int atX, int atY, int rad, int type) {
  viewLayer.loadPixels();
  int left=atX-rad;
  int right=atX+rad;
  int top=atY-rad;
  int bottom=atY+rad;

  // we want to make sure that the left, right, top, and bottom are within the image dimensions
  if (left < 0) {
    left = 0;
  }
  if (right >= viewLayer.width) {
    right = viewLayer.width-1;
  }
  if (top < 0) {
    top = 0;
  }
  if (bottom >= viewLayer.height) {
    bottom = viewLayer.height-1;
  }

  int colPaint = type2color(type);
  for (int x=left;x<right;x++) {
    for (int y=top;y<bottom;y++) {
      int dest = x+y*viewLayer.width;
      viewLayer.pixels[dest] = colPaint;
    }
  }
  viewLayer.updatePixels();
}

void paintBias(int atX, int atY, int rad, int type) {
  int left=atX-rad;
  int right=atX+rad;
  int top=atY-rad;
  int bottom=atY+rad;

  // we want to make sure that the left, right, top, and bottom are within the image dimensions
  if (left < 0) {
    left = 0;
  }
  if (right >= viewLayer.width) {
    right = viewLayer.width-1;
  }
  if (top < 0) {
    top = 0;
  }
  if (bottom >= viewLayer.height) {
    bottom = viewLayer.height-1;
  }

  int colPaint = type2color(type);
  for (int x=left;x<right;x++) {
    for (int y=top;y<bottom;y++) {
      int dest = x+y*viewLayer.width;
      biasLayer.pixels[dest] = colPaint;
    }
  }
}

color type2color(int theType) {
  switch(theType) {
  case TYPE_SPACE:
    return color(0, 0, 0, 0);
  case TYPE_RED:
    return color(255, 0, 0, 255);
  case TYPE_BLUE:
    return color(50, 50, 255, 255);      
  case TYPE_WALL:
  default:
    return color(0, 255, 0, 255);
  }
}

int color2type(color theCol) {
  if ( alpha(theCol) == 0 ) {
    return TYPE_SPACE;
  }
  if ( red(theCol) == 255 ) {
    return TYPE_RED;
  }
  if ( blue(theCol) == 255 ) {
    return TYPE_BLUE;
  }
  if ( green(theCol) == 255 ) {
    return TYPE_WALL;
  }
  return -1;
}

int rangeCap(int idx, PImage bmp) {
  if (idx < 0) {
    return 0;
  } 
  else if (idx >= bmp.width-1) {
    return bmp.width-1;
  } 
  else {
    return idx;
  }
}

int pixelPower(int idx, PImage bmp) {
  int pow = 0;
  color here = bmp.pixels[idx];
  if (bmp.pixels[rangeCap(idx-bmp.width, bmp)] == here) {
    pow++;
  }

  if (bmp.pixels[rangeCap(idx+bmp.width, bmp)] == here) {
    pow++;
  }

  if (bmp.pixels[rangeCap(idx-1, bmp)] == here) {
    pow++;
  }
  if (bmp.pixels[rangeCap(idx+1, bmp)] == here) {
    pow++;
  }
  color bias;
  if(red(here) > blue(here)) {
    bias = biasLayer.pixels[idx];
    if(red(bias) > 80 && red(bias) > blue(bias)) {
      pow++;
    }
  }
  if(blue(here) > red(here)) {
    bias = biasLayer.pixels[idx];
    if(blue(bias) > 80 && blue(bias) > red(bias)) {
      pow++;
    }
  }
  return pow;
}

int applyDirection(int i, int j, int k, int driftDir) {
  int destIdx;
  switch(driftDir) {
  case DIR_UP:
    if (k<=1) {
      return -1;
    } 
    else {
      destIdx = i-viewLayer.width;
    }
    break;
  case DIR_RIGHT:
    if (j>=viewLayer.width-2) {
      return -1;
    } 
    else {
      destIdx = i+1;
    }
    break;
  case DIR_DOWN:
    if (k>=viewLayer.height-2) {
      return -1;
    } 
    else {
      destIdx = i+viewLayer.width;
    }
    break;
  case DIR_LEFT:
  default:
    if (j<=1) {
      return -1;
    } 
    else {
      destIdx = i-1;
    }
    break;
  }
  return destIdx;
}

void clearBoomLayer() {
  color blankCol = color(0, 0, 0, 0);
  for (int h=0;h<viewLayer.width*viewLayer.height;h++) {
    color wasCol = boomLayer.pixels[h];
    float wasAlpha = alpha(wasCol);
    if (wasAlpha > 0) {
      wasCol = color( red(wasCol), 
      green(wasCol), 
      blue(wasCol), 
      0.8*wasAlpha);
      boomLayer.pixels[h] = wasCol;
    }
  }
}

void battleSimStep() {
  viewLayer.loadPixels();
  //updateLayer.loadPixels();
  rcount = 0;
  bcount = 0;
  for (int h=0;h<viewLayer.width*20;h++) {
    updateLayer.pixels[h] = viewLayer.pixels[h] = type2color(TYPE_WALL);
  }
  for (int h=20;h<viewLayer.width*viewLayer.height;h++) {
    updateLayer.pixels[h] = viewLayer.pixels[h];
  }

  int js, ji;
  int ks, ki;
  if (random(2) < 1) {
    js = 0;
    ji = 1;
  } 
  else {
    js = viewLayer.width-1;
    ji = -1;
  }
  if (random(2) < 1) {
    ks = 0;
    ki = 1;
  } 
  else {
    ks = viewLayer.height-1;
    ki = -1;
  }

  for (int j=js;j>=0 && j<viewLayer.width;j+=ji) {
    for (int k=ks;k>=0 && k<viewLayer.height;k+=ki) {
      int i = j+k*viewLayer.width;

      color c = viewLayer.pixels[i];
      color comp;

      int cType = color2type(c);
      switch(cType) {
      case TYPE_SPACE:
      case TYPE_WALL:
        continue;
      case TYPE_RED:
        rcount++;
        break;
      case TYPE_BLUE:
        bcount++;
        break;
      }
      int driftDir = (int)random(4);
      int destIdx;

      destIdx = applyDirection(i, j, k, driftDir);
      if (destIdx<0) {
        continue;
      }
      comp = updateLayer.pixels[destIdx];      

      // double jump when hitting empty space
      // this spreads the battle faster over gaps
      if (color2type(comp) == TYPE_SPACE) {
        destIdx = applyDirection(i, j, k, driftDir);
        if (destIdx<0) {
          continue;
        }
        comp = updateLayer.pixels[destIdx];
        if (color2type(comp) == TYPE_SPACE) {
          destIdx = applyDirection(i, j, k, driftDir);
          if (destIdx<0) {
            continue;
          }
        }
      } 
      else if (color2type(comp) == TYPE_WALL ||
        color2type(comp) == cType) {
        // if it's a wall or same col, try the other way
        driftDir = dir180(driftDir);
        destIdx = applyDirection(i, j, k, driftDir);
        if (destIdx<0) {
          continue;
        }
      }

      comp = updateLayer.pixels[destIdx];      

      switch(color2type(comp)) {
      case TYPE_SPACE:
        updateLayer.pixels[i] = comp;
        updateLayer.pixels[destIdx] = c;
        break;
      case TYPE_RED:
        if (cType == TYPE_BLUE &&
          (random(7)<rrand && pixelPower(i, updateLayer) >=
          pixelPower(destIdx, updateLayer)) ) {
          blastEffect(j, k, color(0, 255, 255));
          updateLayer.pixels[i] = c;
          updateLayer.pixels[destIdx] = c;

          if (random(40)<2) {
            switch(int(random(5))) {
            case 0:
              sndBang1.trigger();
              break;
            case 1:
              sndBang2.trigger();
              break;
            case 2:
              sndBang3.trigger();
              break;
            case 3:
              sndBang4.trigger();
              break;
            }
          }

          if (random(800) < 2) {
            boom(j, k, c);
          }
        }
        break;
      case TYPE_BLUE:
        if (cType == TYPE_RED &&
          (random(7)<brand && pixelPower(i, updateLayer) >=
          pixelPower(destIdx, updateLayer)) ) {
          blastEffect(j, k, color(255, 255, 0));
          updateLayer.pixels[i] = c;
          updateLayer.pixels[destIdx] = c;
          if (random(800) < 2) {
            boom(j, k, c);
          }
        }
        break;      
      case TYPE_WALL:
        continue;
      }
    }
  }

  for (int h=0;h<viewLayer.width*viewLayer.height;h++) {
    viewLayer.pixels[h] = updateLayer.pixels[h];
  }
  viewLayer.updatePixels();
}

int randUpdatedCyc = 0;

void considerTideShift() {
  int redNum=0;
  int blueNum=0;
  for(int i=fbList.size()-1;i>=0;i--) {
    FaceBubble eachFB = (FaceBubble)fbList.get(i);
    if(eachFB.teamType == TYPE_RED) {
      redNum++;
    }
    if(eachFB.teamType == TYPE_BLUE) {
      blueNum++;
    }
  }
  
  if (randUpdatedCyc-- < 0) {
    boomLayer.filter(BLUR, 1);
    if (random(4)<2) {
      brand = 3+(redNum-blueNum)*0.25+random(3);
    }
    if (random(4)<2) {
      rrand = 3+(blueNum-redNum)*0.25+random(3);
    }
    if(brand > rrand) {
      bfaceconf = 0;
      rfaceconf = 2;
    } else if(brand < rrand) {
      bfaceconf = 2;
      rfaceconf = 0;
    } else {
      bfaceconf = 1;
      rfaceconf = 1;
    }
    randUpdatedCyc = (int)random(13, 30);
  }
}

void keyPressed() {
  switch(key) {
    case 'w':
      fbList.add( new FaceBubble(mouseX,mouseY,TYPE_RED) );
      break;
    case 'e':
      fbList.add( new FaceBubble(mouseX,mouseY,TYPE_BLUE) );
      break;
    case 's':
      saveFrame();
      break;
    case 'd':
      debugShowBias = !debugShowBias;
      if(debugShowBias == false) {
        tint(255,255,255,255);
      }
      break;
  }
}

void keyTake() {
  if (keyPressed) {
    switch(key) {
    case 'q':
      paintLayer(adjustedMouseX(), adjustedMouseY(), 40, TYPE_SPACE);
      break;
    case 'w':
      paintLayer(adjustedMouseX(), adjustedMouseY(), 25, TYPE_RED);
      break;
    case 'e':
      paintLayer(adjustedMouseX(), adjustedMouseY(), 25, TYPE_BLUE);
      break;
    case 'r':
      paintLayer(adjustedMouseX(), adjustedMouseY(), 60, TYPE_WALL);
      break;
    }
  }
}
