boolean holdingLeft = false;
boolean holdingRight = false;

void keyPressed() {
  if(keyCode == LEFT) {
    holdingLeft = true;
  }
  if(keyCode == RIGHT) {
    holdingRight = true;
  }
  if(key == ' ' && isOnGround()) {
    velY += JUMP;
  }
}

void keyReleased() {
  if(keyCode == LEFT) {
    holdingLeft = false;
  }
  if(keyCode == RIGHT) {
    holdingRight = false;
  }
}

