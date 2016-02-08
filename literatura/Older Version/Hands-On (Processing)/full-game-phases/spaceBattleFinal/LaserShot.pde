class LaserShot extends WrappingPosition {
  private final float SHOT_SPEED = 4.0;
  private final int SHOT_LIFE_CYCLES = 70;

  private int lifeCycles;
  private float xv, yv;
  private boolean shotFromUFO; // which team is this shot for?

  LaserShot(float fromX, float fromY, float fromXV, float fromYV, float fromAng, boolean fromUFO) {
    x = fromX;
    y = fromY;
    xv = fromXV + cos(fromAng) * SHOT_SPEED;
    yv = fromYV + sin(fromAng) * SHOT_SPEED;
    shotFromUFO = fromUFO;
    lifeCycles = SHOT_LIFE_CYCLES;
  }

  public boolean readyToRemove() {
    return lifeCycles <= 0;
  }

  void reset() {
    lifeCycles = 0; // instantly clear its life, will get removed next cycle
  }

  void updatePosition() {
    if (lifeCycles <= 0) {
      return; // only handle shot code when it's "live"
    }

    x += xv;
    y += yv;

    updateWrap();

    if (shotFromUFO) { // shot from UFO, check if hit player
      if (dist(x, y, p1.x, p1.y) < TARGET_RADIUS) {
        worldState.loseLife();
        reset(); // remove shot
      }
    } 
    else { // shot from player, check if hit any UFO
      for (int i=0;i<enemyList.size();i++) {
        UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
        if (dist(x, y, oneEnemy.x, oneEnemy.y) < TARGET_RADIUS) {
          oneEnemy.flagForRemoval();
          reset(); // remove shot
          break; // escape this for loop to avoid detecting multiple hits
        }
      }
    }

    lifeCycles--;
  }

  void drawShot() {
    rect(x-1, y-1, 3, 3);
  }
}

