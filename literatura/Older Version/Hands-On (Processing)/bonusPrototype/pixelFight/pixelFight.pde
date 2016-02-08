PImage viewLayer = new PImage();
PImage updateLayer = new PImage();
PImage boomLayer = new PImage();

int rcount=0;
int bcount=0;

float brand = 5;
float rrand = 5;

final int DIR_UP=0;
final int DIR_RIGHT=1;
final int DIR_DOWN=2;
final int DIR_LEFT=3;

int dir180(int fromDir) {
  fromDir += 2;
  if(fromDir > 3) {
    fromDir -=4;
  }
  return fromDir;
}

int adjustedMouseX() {
  return mouseX/2;
}
int adjustedMouseY() {
  return mouseY/2;
}

final int TYPE_SPACE=0;
final int TYPE_RED=1;
final int TYPE_BLUE=2;
final int TYPE_WALL=3;

final int VIEW_WIDTH = 800;
final int VIEW_HEIGHT = 600;
final int GAME_WIDTH = VIEW_WIDTH/2;
final int GAME_HEIGHT = VIEW_HEIGHT/2;

void setup() {
  size(VIEW_WIDTH, VIEW_HEIGHT);
  viewLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  updateLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);
  boomLayer = createImage(GAME_WIDTH, GAME_HEIGHT, ARGB);

  paintLayer(GAME_WIDTH/2, GAME_HEIGHT/2, GAME_WIDTH/2, TYPE_WALL);
}

void draw() {
  scale(2.0); // pixel doubling, 25% the calculations
  fill(0,0,0, 54);
  rect(0,0,GAME_WIDTH,GAME_HEIGHT);
  considerSurgeShift();
  clearBoomLayer();
  for (int i=0;i<8;i++) {
    battleSimStep();
  }
  boomLayer.updatePixels();
  image(viewLayer, 0, 0);
  image(boomLayer, 0, 0);

  int sum = rcount+bcount;
  float rperc = -1.0;
  if (sum != 0) {
    rperc = ((float)rcount)/((float)sum);
    int rpos = (int)(GAME_WIDTH*rperc);
    fill(100, 100, 255);
    rect(rpos, 0, GAME_WIDTH-rpos, 20);
    fill(255, 100, 100);
    rect(0, 0, rpos, 20);
  } 
  else {
    fill(100, 100, 100);
    rect(0, 0, GAME_WIDTH, 20);
  }
  textAlign(LEFT);
  fill(50, 0, 0);
  //text(rcount,15,35);
  if (rperc >= 0.0) {
    text(nf(rperc*100.0, 3, 1)+"%", 15, 15);
  } 
  else {
    text("---.-%", 15, 15);
  }
  textAlign(RIGHT);
  fill(0, 0, 50);
  //text(bcount,GAME_WIDTH-1-15,35);
  if (rperc >= 0.0) {
    text(nf((1.0-rperc)*100.0, 3, 1)+"%", GAME_WIDTH-1-15, 15);
  } 
  else {
    text("---.-%", GAME_WIDTH-1-15, 15);
  }
  
  textAlign(LEFT);
  fill(0,0,0);
  text("Q: hole  W: red  E: blue  R: wall", 15, GAME_HEIGHT-8);
}

void mousePressed() {
  paintLayer(adjustedMouseX(), adjustedMouseY(), 10, 0);
}

void keyPressed() {
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

void blastEffect(int atX, int atY,color col) {
  int rad = 1;
  
  int left=atX-rad;
  int right=atX+rad+1;
  int top=atY-rad;
  int bottom=atY+rad+1;

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

  for (int x=left;x<right;x++) {
    for (int y=top;y<bottom;y++) {
      int dest = x+y*viewLayer.width;
      viewLayer.pixels[dest] = type2color(type);
    }
  }
  viewLayer.updatePixels();
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
  color blankCol = color(0,0,0,0);
  for (int h=0;h<viewLayer.width*viewLayer.height;h++) {
    color wasCol = boomLayer.pixels[h];
    float wasAlpha = alpha(wasCol);
    if(wasAlpha > 0) {
      wasCol = color( red(wasCol),
                      green(wasCol),
                      blue(wasCol),
                      0.75*wasAlpha);
      boomLayer.pixels[h] = wasCol;
    }
  }
}

void battleSimStep() {
  viewLayer.loadPixels();
  //updateLayer.loadPixels();
  rcount = 0;
  bcount = 0;
  for (int h=0;h<viewLayer.width*viewLayer.height;h++) {
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

      destIdx = applyDirection(i,j,k, driftDir);
      if(destIdx<0) {
        continue;
      }
      comp = updateLayer.pixels[destIdx];      
      
      // double jump when hitting empty space
      // this spreads the battle faster over gaps
      if(color2type(comp) == TYPE_SPACE) {
        destIdx = applyDirection(i,j,k, driftDir);
        if(destIdx<0) {
          continue;
        }
        comp = updateLayer.pixels[destIdx];
        if(color2type(comp) == TYPE_SPACE) {
          destIdx = applyDirection(i,j,k, driftDir);
          if(destIdx<0) {
            continue;
          }
        }
      } else if(color2type(comp) == TYPE_WALL ||
                color2type(comp) == cType) {
        // if it's a wall or same col, try the other way
        driftDir = dir180(driftDir);
        destIdx = applyDirection(i,j,k, driftDir);
        if(destIdx<0) {
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
          blastEffect(j,k,color(0,255,255));
          updateLayer.pixels[i] = c;
          updateLayer.pixels[destIdx] = c;
        }
        break;
      case TYPE_BLUE:
        if (cType == TYPE_RED &&
          (random(7)<brand && pixelPower(i, updateLayer) >=
          pixelPower(destIdx, updateLayer)) ) {
          blastEffect(j,k,color(255,255,0));
          updateLayer.pixels[i] = c;
          updateLayer.pixels[destIdx] = c;
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

void considerSurgeShift() {
  if (randUpdatedCyc-- < 0) {
    boomLayer.filter(BLUR, 1);
    if (random(4)<2) {
      brand = random(4, 6);
    }
    if (random(4)<2) {
      rrand = random(4, 6);
    }
    randUpdatedCyc = (int)random(5, 15);
  }
}
