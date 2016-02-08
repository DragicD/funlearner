class LaserShot {
  final float SHOT_SPEED = 4.0;
  final int SHOT_LIFE_CYCLES = 70;

  int lifeCycles;
  float x, y;
  float xv, yv;
  boolean shotFromUFO;

  LaserShot(float fromX, float fromY, float fromXV, float fromYV, float fromAng, boolean fromUFO) {
    x = fromX;
    y = fromY;
    xv = fromXV + cos(fromAng) * SHOT_SPEED;
    yv = fromYV + sin(fromAng) * SHOT_SPEED;
    shotFromUFO = fromUFO;
    lifeCycles = SHOT_LIFE_CYCLES;
  }

  boolean readyToRemove() {
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

    // wrap shot if off screen edge
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

    if (shotFromUFO) { // shot from UFO, check if hit player
      if (dist(x, y, p1.x, p1.y) < TARGET_RADIUS) {
        p1.reset();
        reset(); // remove shot
        enemyScore++;
      }
    } 
    else { // shot from player, check if hit any UFO
      for (int i=0;i<enemyList.size();i++) {
        UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
        if (dist(x, y, oneEnemy.x, oneEnemy.y) < TARGET_RADIUS) {
          oneEnemy.resetRandomStartPosition();
          reset(); // remove shot
          playerScore++;
          break; // escape this for loop to avoid detecting multiple hits
        }
      }
    }

    lifeCycles--;
  }

  void drawShot() {
    fill(255,255,255);
    rect(x-1, y-1, 3, 3);
  }
}

