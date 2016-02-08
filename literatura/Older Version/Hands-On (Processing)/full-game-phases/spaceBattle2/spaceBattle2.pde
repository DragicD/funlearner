/* Hands-On Game Programming
 * By Chris DeLeon
 *
 * Commercial educational example. Do not distribute source.
 *
 * Feel free to use this code as a starting point or as scrap
 * parts to harvest from. Your compiled program using the
 * derivative code can be distributed, for free or commercially,
 * without any attribution or mention of Chris DeLeon.
 * (unless used for school - then make clear which work is yours!)
 */
 
PImage playerShip;
PImage ufoShip;

final float THRUST_FORCE = 0.1;
final float THRUST_DECAY_MULT = 0.99;
final float PLAYER_TURN_RATE = 0.025;

final float SHOT_SPEED = 4.0;
final int SHOT_LIFE_CYCLES = 70;

final float TARGET_RADIUS = 12.0;
final float ENEMY_MOVE_SPEED = 0.8;

float enemyX, enemyY;
float enemyMoveToX, enemyMoveToY;

int enemyShotLifeCycles = 0;
float enemyShotX, enemyShotY;
float enemyShotXV, enemyShotYV;

int playerShotLifeCycles = 0;
float playerShotX, playerShotY;
float playerShotXV, playerShotYV;

float playerX, playerY;
float playerXV, playerYV;
float playerAng;
boolean keyHeld_Thrust = false;
boolean keyHeld_TurnLeft = false;
boolean keyHeld_TurnRight = false;

void setup() { // setup() happens once at program start
  playerShip = loadImage("player.png");
  ufoShip = loadImage("ufo.png");
  size(800, 600);

  resetGame();
}

void draw() { // draw() happens every frame (automatically)
  updateAllPositions();
  drawAll();
}

void keyPressed() {
  if (keyCode == UP) {
    keyHeld_Thrust = true;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = true;
  }
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = true;
  }
  if (key == ' ') {
    if (playerShotLifeCycles <= 0) {
      playerShotX = playerX;
      playerShotY = playerY;
      playerShotXV = playerXV + cos(playerAng) * SHOT_SPEED;
      playerShotYV = playerYV + sin(playerAng) * SHOT_SPEED;
      playerShotLifeCycles = SHOT_LIFE_CYCLES;
    }
  }
}
void keyReleased() {
  if (keyCode == UP) {
    keyHeld_Thrust = false;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = false;
  }
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = false;
  }
  if (key == 'r') {
    resetGame();
  }
}

void resetPlayer()
{
  // reminder: only call this after setting size() so that width/height are valid
  playerX = width/2;

  playerY = height/2;
  playerXV = 0.0;
  playerYV = 0.0;
  playerAng = 0.0;
  playerShotLifeCycles = 0;
}

void resetEnemy()
{
  enemyX = width/4;
  enemyY = height/4;
  enemyMoveToX = enemyX;
  enemyMoveToY = enemyY;
  enemyShotLifeCycles = 0;
}

void resetGame()
{
  resetPlayer();
  resetEnemy();
}

void playerShotUpdatePosition() {
  playerShotX += playerShotXV;
  playerShotY += playerShotYV;

  // wrap shot if off screen edge
  if (playerShotX < 0) {
    playerShotX += width;
  }
  if (playerShotY < 0) {
    playerShotY += height;
  }
  if (playerShotX > width) {
    playerShotX -= width;
  }
  if (playerShotY > height) {
    playerShotY -= height;
  }

  if (dist(playerShotX, playerShotY, enemyX, enemyY) < TARGET_RADIUS) {
    resetEnemy();
    playerShotLifeCycles = 0;
  }

  playerShotLifeCycles--;
}

void playerUpdatePosition() {
  if (keyHeld_Thrust) {
    playerXV += cos(playerAng) * THRUST_FORCE;
    playerYV += sin(playerAng) * THRUST_FORCE;
  }
  if (keyHeld_TurnLeft) {
    playerAng -= PLAYER_TURN_RATE;
  }
  if (keyHeld_TurnRight) {
    playerAng += PLAYER_TURN_RATE;
  }

  playerX += playerXV;
  playerY += playerYV;
  playerXV *= THRUST_DECAY_MULT;
  playerYV *= THRUST_DECAY_MULT;

  // wrap player if off screen edge
  if (playerX < 0) {
    playerX += width;
  }
  if (playerY < 0) {
    playerY += height;
  }
  if (playerX > width) {
    playerX -= width;
  }
  if (playerY > height) {
    playerY -= height;
  }
}

void enemyShotUpdatePosition() {
  enemyShotX += enemyShotXV;
  enemyShotY += enemyShotYV;

  // wrap shot if off screen edge
  if (enemyShotX < 0) {
    enemyShotX += width;
  }
  if (enemyShotY < 0) {
    enemyShotY += height;
  }
  if (enemyShotX > width) {
    enemyShotX -= width;
  }
  if (enemyShotY > height) {
    enemyShotY -= height;
  }

  if (dist(enemyShotX, enemyShotY, playerX, playerY) < TARGET_RADIUS) {
    resetPlayer();
    enemyShotLifeCycles = 0;
  }

  enemyShotLifeCycles--;
}

void enemyUpdatePosition()
{
  if (enemyX < enemyMoveToX - ENEMY_MOVE_SPEED) {
    enemyX += ENEMY_MOVE_SPEED;
  } 
  else if (enemyX > enemyMoveToX + ENEMY_MOVE_SPEED) {
    enemyX -= ENEMY_MOVE_SPEED;
  } 
  else {
    enemyMoveToX = random(width);
  }

  if (enemyY < enemyMoveToY - ENEMY_MOVE_SPEED) {
    enemyY += ENEMY_MOVE_SPEED;
  } 
  else if (enemyY > enemyMoveToY + ENEMY_MOVE_SPEED) {
    enemyY -= ENEMY_MOVE_SPEED;
  } 
  else {
    enemyMoveToY = random(height);
  }

  if (enemyShotLifeCycles <= 0 && random(150)<3) {
    enemyShotX = enemyX;
    enemyShotY = enemyY;
    float angTo = atan2(playerY-enemyY, playerX-enemyX);
    enemyShotXV = cos(angTo) * SHOT_SPEED + random(-2.0, 2.0);
    enemyShotYV = sin(angTo) * SHOT_SPEED + random(-2.0, 2.0);
    enemyShotLifeCycles = SHOT_LIFE_CYCLES;
  }
}

void updateAllPositions()
{
  if (enemyShotLifeCycles > 0) {
    enemyShotUpdatePosition();
  }
  enemyUpdatePosition();

  if (playerShotLifeCycles > 0) {
    playerShotUpdatePosition();
  }
  playerUpdatePosition();
}

void drawPlayer()
{
  pushMatrix();
  translate(playerX, playerY);
  rotate(playerAng);
  image(playerShip,-playerShip.width/2,-playerShip.height/2);
  popMatrix();
}

void drawEnemy()
{
  pushMatrix();
  translate(enemyX, enemyY);
  image(ufoShip,-ufoShip.width/2,-ufoShip.height/2);
  popMatrix();
}

void drawPlayerShot()
{
  fill(255,255,255);
  rect(playerShotX-1, playerShotY-1, 3, 3);
}

void drawEnemyShot()
{
  fill(255,255,255);
  rect(enemyShotX-1, enemyShotY-1, 3, 3);
}

void clearScreen()
{
  fill(0,0,0); // color to black
  noStroke();
  rect(0,0,width,height); // wipe whole screen
}

void drawAll()
{
  clearScreen();
  if (playerShotLifeCycles > 0) {
    drawPlayerShot();
  }
  if (enemyShotLifeCycles > 0) {
    drawEnemyShot();
  }  
  drawEnemy();
  drawPlayer();
}

