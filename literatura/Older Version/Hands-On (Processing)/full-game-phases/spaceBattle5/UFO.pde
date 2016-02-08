class UFO {
  final float MOVE_SPEED = 0.8;
  final float ENEMY_SHOT_INACCURACY = 0.5; // note: angle in radians
  final int ENEMY_RELOAD_CYCLES_MIN = 50;
  final int ENEMY_RELOAD_CYCLES_MAX = 150;

  float initialX, initialY; // save to respawn it here, unique per ship
  float x, y;
  float moveToX, moveToY;
  int reloadCycleTimer;

  ArrayList enemyShots;

  UFO(float startAtX, float startAtY) {
    initialX = startAtX;
    initialY = startAtY;
    enemyShots = new ArrayList();
    reset();
  }

  void resetRandomStartPosition() {
    initialX = random(width*0.1, width*0.9);
    reset();
  }

  void reset() {
    x = initialX;
    y = initialY;
    moveToX = x;
    moveToY = y;
    enemyShots.clear();
    newReloadTime();
  }

  void decrementReloadCycleTimer() {
    reloadCycleTimer--;
  }

  boolean readyToFire() {
    return reloadCycleTimer < 0;
  }

  void newReloadTime() {
    reloadCycleTimer += random(ENEMY_RELOAD_CYCLES_MIN, ENEMY_RELOAD_CYCLES_MAX);
  }

  void updatePosition() {
    if (x < moveToX - MOVE_SPEED) {
      x += MOVE_SPEED;
    } 
    else if (x > moveToX + MOVE_SPEED) {
      x -= MOVE_SPEED;
    } 
    else {
      moveToX = random(width);
    }

    if (y < moveToY - MOVE_SPEED) {
      y += MOVE_SPEED;
    } 
    else if (y > moveToY + MOVE_SPEED) {
      y -= MOVE_SPEED;
    } 
    else {
      moveToY = random(height);
    }

    decrementReloadCycleTimer();
    if ( readyToFire() ) {
      newReloadTime();

      float angToPlayer = atan2(p1.y-y, p1.x-x);

      // making it inaccurate. Without this next line it's straight on
      angToPlayer += random(-(ENEMY_SHOT_INACCURACY*0.5), (ENEMY_SHOT_INACCURACY*0.5));

      LaserShot newShot = new LaserShot(x, y, 0.0, 0.0, angToPlayer, true);
      enemyShots.add( newShot );
    }

    // we go through this for loop backwards since we're removing entries while iterating
    // if we removed an entry while iterating forward, we'd skip an entry (!)
    for (int i=enemyShots.size()-1; i>=0; i--) { // for each shot...
      LaserShot oneShot = (LaserShot)enemyShots.get(i); // get the shot at that index
      if (oneShot.readyToRemove()) {
        enemyShots.remove(i);
      } 
      else {
        oneShot.updatePosition(); // handle logic for that shot
      }
    }
  }

  void drawSaucerAndShot() {
    pushMatrix();
    translate(x, y);
    image(ufoShip,-ufoShip.width/2,-ufoShip.height/2);
    popMatrix();

    for (int i=0; i<enemyShots.size(); i++) { // for each shot...
      LaserShot oneShot = (LaserShot)enemyShots.get(i); // get the shot at that index
      oneShot.drawShot(); // handle drawing for that shot
    }
  }
}

