float posX = 50;
float posY = 200;
float velX = 0.0;
float velY = 0.0;
final float GRAVITY = 0.4; 
final float JUMP = -10.0; 

float camScrollX = 0.0;

PImage bgImg;

boolean isOnGround() {
  return (posY >= height);
}

void setup() {
  size(640,480);
  bgImg = loadImage("land.png");
}

void updateCamPos() {
  float scrollSpeed = 1.4f;
  
  float gotoSpot = posX-(width/4); // player 25% from left
  // keep camera from scrolling out of bounds
  if(gotoSpot < 0) {
    gotoSpot = 0;
  }
  if(gotoSpot > bgImg.width-width) {
    gotoSpot = bgImg.width-width;
  }
  
  // have camera chase player position
  if(camScrollX < gotoSpot - scrollSpeed) {
    camScrollX += scrollSpeed;
  }
  if(camScrollX > gotoSpot + scrollSpeed) {
    camScrollX -= scrollSpeed;
  }
}

void draw() {
  updateCamPos();
  
  posX += velX;
  posY += velY;
  
  if(isOnGround()) { // friction
    velX *= 0.92;
    if(holdingLeft) { // no air control here, traction on ground
      velX = -2.5;
    }
    if(holdingRight) { // no air control here, traction on ground
      velX = 2.5;
    }
  }
  
  if(isOnGround()) { // on ground to jump
    posY = height;
    velY = 0.0; 
  } else {
    velY += GRAVITY;
  }
  
  // keep player inbounds:
  if(posX < 0) {
    posX = 0;
  }
  if(posX >= bgImg.width) {
    posX = bgImg.width;
  }
  
  image(bgImg,-camScrollX,0);
  rect(posX-20-camScrollX,posY-100,40,100);
}
