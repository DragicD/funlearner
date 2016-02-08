class UFO extends ArmedSpaceCraft {
  private final float MOVE_SPEED = 0.8;
  private final float ENEMY_SHOT_INACCURACY = 0.7; // note: angle in radians
  private final int ENEMY_RELOAD_CYCLES_MIN = 50;
  private final int ENEMY_RELOAD_CYCLES_MAX = 150;

  private float initialX, initialY; // save to respawn it here, unique per ship
  private float moveToX, moveToY;
  private int reloadCycleTimer;
  private boolean flaggedForRemoval;

  UFO(float startAtX, float startAtY) {
    super();
    initialX = startAtX;
    initialY = startAtY;
    reset();
  }

  public boolean readyToRemove() {
    return flaggedForRemoval;
  }

  public void flagForRemoval() {
    if (flaggedForRemoval == false) { // avoid accidentally scoring twice
      flaggedForRemoval = true;
      worldState.incrementScore(100);
    }
  }

  public void reset() {
    super.reset();
    x = initialX;
    y = initialY;
    moveToX = x;
    moveToY = y;
    newReloadTime();
    flaggedForRemoval = false;
  }

  private void decrementReloadCycleTimer() {
    reloadCycleTimer--;
  }

  private boolean readyToFire() {
    return reloadCycleTimer < 0;
  }

  private void newReloadTime() {
    reloadCycleTimer = (int)random(ENEMY_RELOAD_CYCLES_MIN, ENEMY_RELOAD_CYCLES_MAX);
  }

  public void updatePosition() {
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
      angToPlayer += random(-(ENEMY_SHOT_INACCURACY*0.5), 
      (ENEMY_SHOT_INACCURACY*0.5));

      LaserShot newShot = new LaserShot(x, y, 0.0, 0.0, angToPlayer, true);
      myShots.add( newShot );
    }

    updateShots();
  }

  public void collisionCheck(Player thisPlayer) {
    float shipDist = dist(thisPlayer.x, thisPlayer.y, x, y);

    // if this enemy ship collides with the player ship, remove both
    if (shipDist <= TARGET_RADIUS*2.0) {
      worldState.loseLife();
      flagForRemoval();
    }
  }

  public void drawSaucerAndShot() {
    pushMatrix();
    translate(x, y);
    translate(-ufoShip.width/2,-ufoShip.height/2);
    image(ufoShip,0,0);
    popMatrix();
    stroke(255,0,0);
    fill(255,0,0);
    drawShots();
  }
}

