class UFO {
  final float MOVE_SPEED = 0.8;
  final float ENEMY_SHOT_INACCURACY = 0.5; // note: angle in radians

  float x, y;
  float moveToX, moveToY;

  LaserShot enemyShot;

  UFO() {
    enemyShot = new LaserShot();
  }

  void reset() {
    x = width/4;
    y = height/4;
    moveToX = x;
    moveToY = y;
    enemyShot.reset();
  }

  boolean fireFrequencyIfAble() {
    return ( random(150) < 3 );
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

    if ( fireFrequencyIfAble() ) {
      float angToPlayer = atan2(p1.y-y, p1.x-x);

      // making it inaccurate. Without this next line it's straight on
      angToPlayer += random(-(ENEMY_SHOT_INACCURACY*0.5), (ENEMY_SHOT_INACCURACY*0.5));

      enemyShot.fireIfAble(x, y, 0.0, 0.0, angToPlayer, true);
    }

    enemyShot.updatePosition();
  }

  void drawSaucerAndShot() {
    pushMatrix();
    translate(x, y);
    image(ufoShip,-ufoShip.width/2,-ufoShip.height/2);
    popMatrix();

    enemyShot.drawIfActive();
  }
}

