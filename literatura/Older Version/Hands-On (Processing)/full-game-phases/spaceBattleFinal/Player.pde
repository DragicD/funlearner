class Player extends ArmedSpaceCraft {
  private final int PLAYER_SHOTS_AT_ONCE_LIMIT = 3;
  
  private final float TURN_RATE = 0.025;
  private final float THRUST_FORCE = 0.1;
  private final float THRUST_DECAY_MULT = 0.99;

  private float xv, yv;
  private float ang;

  Player() {
    super();
  }

  public void resetRandomStartPosition() {
    reset();
    x = random(width*0.1, width*0.9);
  }

  public void reset() {
    super.reset();

    // reminder: only call this after setting size() so that width/height are valid
    x = width/2;
    y = height*3/4;
    xv = 0.0;
    yv = 0.0;
    ang = -PI/2; // start by facing upward
  }

  private void thrust() {
    xv += cos(ang) * THRUST_FORCE;
    yv += sin(ang) * THRUST_FORCE;
  }

  private void turnLeft() {
    ang -= TURN_RATE;
  }

  private void turnRight() {
    ang += TURN_RATE;
  }

  private void shoot() {
    LaserShot newShot = new LaserShot(x, y, xv, yv, ang, false);
    if(myShots.size() < PLAYER_SHOTS_AT_ONCE_LIMIT) {
      myShots.add( newShot );
    }
  }

  private void considerKeyboardInput() {
    // note: keyHandling file updates these based on press/release
    if (keyHeld_Thrust) {
      thrust();
    }
    if (keyHeld_TurnLeft) {
      turnLeft();
    }
    if (keyHeld_TurnRight) {
      turnRight();
    }
    if (keyPressed_Space) {
      shoot();
    }
  }

  public void updatePosition() {
    if ( worldState.isOutOfLives() ) {
      return; // if player is defeated, don't move or draw it or its shots
    }

    considerKeyboardInput(); // important!

    x += xv;
    y += yv;
    updateWrap();
    xv *= THRUST_DECAY_MULT;
    yv *= THRUST_DECAY_MULT;
    updateShots();
  }

  public void drawRocketAndShot() {
    if ( worldState.isOutOfLives() ) {
      return; // if player is defeated, don't move or draw it or its shots
    }

    pushMatrix();
    translate(x, y);
    rotate(ang);
    if (keyHeld_Thrust) {
      stroke(255, 255, 0); // different color for thruster
      float randThrustSize = random(2.0, 12.0);
      line(-10.0, -6.0, -10.0-randThrustSize, 0.0);
      line(-10.0, 6.0, -10.0-randThrustSize, 0.0);
    }    

    translate(-playerShip.width/2,-playerShip.height/2);
    image(playerShip,0,0);   
    popMatrix();
    stroke(0,255,0);
    fill(0,255,0);
    drawShots();
  }
}

