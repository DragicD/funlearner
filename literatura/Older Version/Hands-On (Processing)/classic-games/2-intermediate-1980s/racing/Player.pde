class Player {
  private final float PLAYER_TURN_RATE = 0.045;
  private final float DRIVE_POWER = 0.25;
  private final float MAX_SPEED = 3.0;
  private final float GROUNDSPEED_DECAY_MULT = 0.94;
  
  // if the player is driving slower than this, don't
  // let the car turn. This is to prevent the car from
  // turning in place, since automobiles can't do that.
  private final float MIN_TURN_SPEED = 0.3;

  private float startX, startY;
  
  private PImage myGraphic;
  private float x, y;
  private float speed;
  private float ang;

  Player(String graphicName) {
    myGraphic = loadImage(graphicName);
  }

  public void reset() {
    x = startX;
    y = startY;
    ang = -PI/2; // start by facing upward
  }

  private void gas(float directionScale) {
    speed += DRIVE_POWER * directionScale;
    if(speed > MAX_SPEED) {
      speed = MAX_SPEED;
    }
  }

  private void steerLeft() {
    if(abs(speed) > MIN_TURN_SPEED) {
      ang -= PLAYER_TURN_RATE;
    }
  }

  private void steerRight() {
    if(abs(speed) > MIN_TURN_SPEED) {
      ang += PLAYER_TURN_RATE;
    }
  }

  // generalized to use different P1 and P2 inputs
  public void considerKeyboardInput(boolean gasKey,
                boolean reverseKey,boolean turnLeft,
                boolean turnRight) {
    if(gasKey) {
      gas(1.0);
    }
    if(reverseKey) {
      gas(-0.3);
    }
    if(turnLeft) {
      steerLeft();
    }
    if(turnRight) {
      steerRight();
    }
  }

  public void updatePosition() {
    float newX = x + cos(ang) * speed;
    float newY = y + sin(ang) * speed;
    int tilePlayerHit = whatIsAtThisCoordinate(newX,newY);
    
    if(tilePlayerHit == TRACK_TYPE_PLAIN_ROAD) {
      x = newX;
      y = newY;
    } else if(tilePlayerHit == TRACK_TYPE_GOAL) {
      resetGame();
    }
    speed *= GROUNDSPEED_DECAY_MULT;
  }

  public void drawCar() {
    drawBitmapCenteredAtLocationWithRotation(myGraphic,x,y,ang);
  }
}

