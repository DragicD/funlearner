class Player {
  final float PLAYER_TURN_RATE = 0.045;
  
  float x,y,ang;
  PImage myGraphic;
  
  Player(String thisImage) {
    myGraphic = loadImage(thisImage);
    
    x = random(width);
    y = random(height);
  }
  
  void considerKeyboardInput(boolean gasKey,
                boolean reverseKey, boolean turnLeft,
                boolean turnRight) {
    if(turnLeft) {
      ang -= PLAYER_TURN_RATE;
    }
    if(turnRight) {
      ang += PLAYER_TURN_RATE;
    }
  }
  
  void drawCar() {
    drawBitmapCenteredAtLocationWithRotation(
        myGraphic, x,y, ang);
  }
}
