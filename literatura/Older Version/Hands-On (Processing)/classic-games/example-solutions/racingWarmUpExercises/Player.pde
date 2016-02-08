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
  private int playerSlotNumber;
  
  public void UpdateTimeOfDayGraphic() {
    if(themeSet == THEME_SET_DAY) {
      myGraphic = loadImage("player"+playerSlotNumber+"_day.png");
    } else {
      myGraphic = loadImage("player"+playerSlotNumber+"_night.png");
    }
  }

  Player(int whichPlayer) {
    playerSlotNumber = whichPlayer;
    UpdateTimeOfDayGraphic();
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
  
  private boolean canITurn() {
    if(abs(speed) <= MIN_TURN_SPEED) {
      return false;
    }
    
    int tilePlayerIsOn = whatIsAtThisCoordinate(x,y);
    boolean isNotOnOil = (tilePlayerIsOn != TRACK_TYPE_OIL);
    
    return isNotOnOil;
  }

  private void steerLeft() {
    if( canITurn() ) {
      ang -= PLAYER_TURN_RATE;
    }
  }

  private void steerRight() {
    if( canITurn() ) {
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
    int tilePlayerIsOn = whatIsAtThisCoordinate(x,y);
    boolean isOnGrass = (tilePlayerIsOn == TRACK_TYPE_GRASS);
    boolean isOnOil = (tilePlayerIsOn == TRACK_TYPE_OIL);
    float speedThisFrame = speed;
    
    if(isOnGrass) {
      speedThisFrame *= 0.2;
    }
    
    float newX = x + cos(ang) * speedThisFrame;
    float newY = y + sin(ang) * speedThisFrame;
    int tilePlayerHit = whatIsAtThisCoordinate(newX,newY);
    
    if( canDriveOverTileType(tilePlayerHit) ) {
      x = newX;
      y = newY;
    } else if(tilePlayerHit == TRACK_TYPE_GOAL) {
      resetGame();
    }
    if(isOnOil == false) {
      speed *= GROUNDSPEED_DECAY_MULT;
    }
  }
  
  private boolean canDriveOverTileType(int thisType) {
    return thisType == TRACK_TYPE_PLAIN_ROAD ||
           thisType == TRACK_TYPE_GRASS ||
           thisType == TRACK_TYPE_OIL;
  }

  public void drawCar() {
    drawBitmapCenteredAtLocationWithRotation(myGraphic,x,y,ang);
  }
}

