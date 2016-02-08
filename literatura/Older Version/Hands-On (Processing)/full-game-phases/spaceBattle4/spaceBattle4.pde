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

final float TARGET_RADIUS = 12.0;

Player p1;
UFO enemy;

void setup() // setup() happens once at program start
{
  playerShip = loadImage("player.png");
  ufoShip = loadImage("ufo.png");
  size(800, 600);

  p1 = new Player();
  enemy = new UFO();

  resetGame();
}

void draw() { // draw() happens every frame (automatically)
  updateAllPositions();
  drawAll();

  forgetPressedKeys(); // from keyHandling file
}

void resetGame()
{
  p1.reset();
  enemy.reset();
}

void updateAllPositions()
{
  enemy.updatePosition();
  p1.updatePosition();
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
  enemy.drawSaucerAndShot();
  p1.drawRocketAndShot();
}

