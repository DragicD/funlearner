class actor {
  final float PLAYER_SPEED = 2.0; 
  final int PLAYER_WIDTH = 20; 
  float playerX,playerY;
  boolean iAmAI;
  int AIMoveDir;
  int AICyclesTilDirChange;
  
  void resetMe() {
    playerX = playerY = 100;
  }
  
  actor(boolean useAI) {
    iAmAI = useAI;
    resetMe();
  }
  
  void moveMe() {
    float wasX = playerX;
    float wasY = playerY;
    float speedNow = PLAYER_SPEED;
    
    switch(underHere((int)playerX,(int)playerY)) {
      case UNDER_TYPE_RED:
        speedNow *= 0.25;
        break;
      case UNDER_TYPE_GREEN:
        speedNow *= 3.0;
        break;
      case UNDER_TYPE_BLUE:
        resetMe();
        return; // note: not break, quitting move call here
    }
    
    if(iAmAI) {
      AICyclesTilDirChange--;
      if(AICyclesTilDirChange < 0) {
        AICyclesTilDirChange = 20+(int)random(50);
        AIMoveDir = (int)random(8);
      }
      switch(AIMoveDir) {
        case 0:
          playerX -= speedNow;
          break;
        case 1:
          playerX -= speedNow;
          playerY -= speedNow;
          break;
        case 2:
          playerY -= speedNow;
          break;
        case 3:
          playerX += speedNow;
          playerY -= speedNow;
          break;
        case 4:
          playerX += speedNow;
          break;
        case 5:
          playerX += speedNow;
          playerY += speedNow;
          break;
        case 6:
          playerY += speedNow;
          break;
        case 7:
          playerX -= speedNow;
          playerY += speedNow;
          break;
      }
    } else { // player, check keyboard instead
      if(holdLeft) {
        playerX -= speedNow;
      }
      if(holdRight) {
        playerX += speedNow;
      }
      if(holdUp) {
        playerY -= speedNow;
      }
      if(holdDown) {
        playerY += speedNow;
      }
    }
    
    switch(underHere((int)playerX,(int)playerY)) {
      case UNDER_TYPE_BLACK:
        playerX = wasX;
        playerY = wasY;
        break;
    }
    stayInBounds();
  }
  
  void stayInBounds() {
    if(playerX < 0) {
      playerX = 0;
    }
    if(playerY < 0) {
      playerY = 0;
    }
    if(playerX >= width) {
      playerX = width-1;
    }
    if(playerY >= height) {
      playerY = height-1;
    }
  }
  
  void drawMe() {
    if(iAmAI) {
      fill(255,0,255);
    } else {
      fill(0,255,255);
    }
    ellipse(playerX,playerY,
        PLAYER_WIDTH,PLAYER_WIDTH);
  }
}
