class Player {
  final float PLAYER_TURN_RATE = 0.045;

  final float DRIVE_POWER = 0.25;
  final float MAX_SPEED = 3.0;
  final float GROUNDSPEED_DECAY_MULT = 0.94;

  final float MIN_TURN_SPEED = 0.3;

  float x, y, ang;
  float speed;
  PImage myGraphic;

  Player(String thisImage) {
    myGraphic = loadImage(thisImage);

    x = random(width);
    y = random(height);
  }
  
  void updatePosition() {
    x += cos(ang) * speed;
    y += sin(ang) * speed;
  
    speed *= GROUNDSPEED_DECAY_MULT;
  }


  void gas(float directionScale) {
    speed += DRIVE_POWER * directionScale;
    if (speed > MAX_SPEED) {
      speed = MAX_SPEED;
    }
  }

  void steerLeft() {
    if (abs(speed) > MIN_TURN_SPEED) {
      ang -= PLAYER_TURN_RATE;
    }
  }

  void steerRight() {
    if (abs(speed) > MIN_TURN_SPEED) {
      ang += PLAYER_TURN_RATE;
    }
  }

  void considerKeyboardInput(boolean gasKey, 
          boolean reverseKey, boolean turnLeft, 
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

  void drawCar() {
    drawBitmapCenteredAtLocationWithRotation(myGraphic, x, y, ang);
  }
}

