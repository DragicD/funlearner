class LaserShot {
  final float SHOT_SPEED = 4.0;
  final int SHOT_LIFE_CYCLES = 70;

  int lifeCycles;
  float x, y;
  float xv, yv;
  boolean shotFromUFO;

  LaserShot() {
    lifeCycles = 0; // when this is 0 the rest don't matter anyhow
  }

  void fireIfAble(float fromX, float fromY, float fromXV, float fromYV, float fromAng, boolean fromUFO) {
    if (isInUse() == false) {
      x = fromX;
      y = fromY;
      xv = fromXV + cos(fromAng) * SHOT_SPEED;
      yv = fromYV + sin(fromAng) * SHOT_SPEED;
      shotFromUFO = fromUFO;
      lifeCycles = SHOT_LIFE_CYCLES;
    }
  }

  boolean isInUse() {
    return lifeCycles > 0;
  }

  void reset() {
    lifeCycles = 0;
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
        reset(); // shot
      }
    } 
    else { // shot from player, check if hit UFO
      if (dist(x, y, enemy.x, enemy.y) < TARGET_RADIUS) {
        enemy.reset();
        reset(); // shot
      }
    }

    lifeCycles--;
  }

  void drawIfActive() {
    if (lifeCycles > 0) {
      fill(255,255,255);
      rect(x-1, y-1, 3, 3);
    }
  }
}

