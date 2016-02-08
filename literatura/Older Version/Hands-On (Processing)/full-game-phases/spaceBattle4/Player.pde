class Player {
  final float TURN_RATE = 0.025;
  final float THRUST_FORCE = 0.1;
  final float THRUST_DECAY_MULT = 0.99;

  LaserShot myShot;

  float x, y;
  float xv, yv;
  float ang;

  Player() {
    myShot = new LaserShot();
  }

  void reset() {
    // reminder: only call this after setting size() so that width/height are valid
    x = width/2;
    y = height/2;
    xv = 0.0;
    yv = 0.0;
    ang = 0.0;
    myShot.reset();
  }

  void thrust() {
    xv += cos(ang) * THRUST_FORCE;
    yv += sin(ang) * THRUST_FORCE;
  }

  void turnLeft() {
    ang -= TURN_RATE;
  }

  void turnRight() {
    ang += TURN_RATE;
  }

  void shoot() {
    myShot.fireIfAble(x, y, xv, yv, ang, false);
  }

  void considerKeyboardInput() {
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

  void updatePosition() {
    considerKeyboardInput(); // important!

    x += xv;
    y += yv;
    xv *= THRUST_DECAY_MULT;
    yv *= THRUST_DECAY_MULT;

    // wrap player if off screen edge
    if (x < 0) {
      x += width;
    }
    if (y < 0) {
      y += height;
    }
    if (x > width) {
      x -= width;
    }
    if (y > height) {
      y -= height;
    }

    myShot.updatePosition();
  }

  void drawRocketAndShot() {
    pushMatrix();
    translate(x, y);
    rotate(ang);
    image(playerShip,-playerShip.width/2,-playerShip.height/2);
    popMatrix();

    myShot.drawIfActive();
  }
}

