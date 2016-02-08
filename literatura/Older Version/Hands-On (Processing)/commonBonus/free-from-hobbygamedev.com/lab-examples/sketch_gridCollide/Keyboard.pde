boolean holdRight = false;
boolean holdLeft = false;
boolean holdUp = false;
boolean holdDown = false;

void keyPressed() {
  if(keyCode == RIGHT) {
    holdRight = true;
  }
  if(keyCode == LEFT) {
    holdLeft = true;
  }
  if(keyCode == UP) {
    holdUp = true;
  }
  if(keyCode == DOWN) {
    holdDown = true;
  }
}

void keyReleased() {
  if(keyCode == RIGHT) {
    holdRight = false;
  }
  if(keyCode == LEFT) {
    holdLeft = false;
  }
  if(keyCode == UP) {
    holdUp = false;
  }
  if(keyCode == DOWN) {
    holdDown = false;
  }
}

void handleKeyStates() {
  int pxWas = playerX;
  int pyWas = playerY;
  
  if(holdRight) {
    playerX++;
  }
  if(holdLeft) {
    playerX--;
  }
  if(holdUp) {
    playerY--;
  }
  if(holdDown) {
    playerY++;
  }
  
  int tileUnderPlayer =
        whatIsUnderThisCoordinate(playerX,playerY);
  
  if(tileUnderPlayer == GRID_TYPE_WALL) {
    playerX = pxWas;
    playerY = pyWas;
  } else if(tileUnderPlayer == GRID_TYPE_COIN) {
    changeTile(playerX,playerY,GRID_TYPE_SPACE);
    coinsInWorld--;
  }
} // end of void handleKeyStates()


