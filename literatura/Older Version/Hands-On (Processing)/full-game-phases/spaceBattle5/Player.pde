class Player {
  final float TURN_RATE = 0.025;
  final float THRUST_FORCE = 0.1;
  final float THRUST_DECAY_MULT = 0.99;

  ArrayList allShots;

  float x, y;
  float xv, yv;
  float ang;

  Player() {
    allShots = new ArrayList();
  }

  void reset() {
    // reminder: only call this after setting size() so that width/height are valid
    x = random(width*0.1, width*0.9); // randomize to avoid consecutive hits
    y = height*3/4;
    xv = 0.0;
    yv = 0.0;
    ang = -PI/2; // start by facing upward
    allShots.clear();
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
    LaserShot newShot = new LaserShot(x, y, xv, yv, ang, false);
    allShots.add( newShot );
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

    // we go through this for loop backwards since we're removing entries while iterating
    // if we removed an entry while iterating forward, we'd skip an entry (!)
    for (int i=allShots.size()-1; i>=0; i--) { // for each shot...
      LaserShot oneShot = (LaserShot)allShots.get(i); // get the shot at that index
      if (oneShot.readyToRemove()) {
        allShots.remove(i);
      } 
      else {
        oneShot.updatePosition(); // handle logic for that shot
      }
    }
  }

  void drawRocketAndShot() {
    pushMatrix();
    translate(x, y);
    rotate(ang);
    image(playerShip,-playerShip.width/2,-playerShip.height/2);
    popMatrix();

    for (int i=0; i<allShots.size(); i++) { // for each shot...
      LaserShot oneShot = (LaserShot)allShots.get(i); // get the shot at that index
      oneShot.drawShot(); // handle drawing for that shot
    }
  }
}

