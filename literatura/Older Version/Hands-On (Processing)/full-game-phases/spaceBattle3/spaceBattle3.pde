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

void resetGame()
{
  resetPlayer();
  resetEnemy();
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

