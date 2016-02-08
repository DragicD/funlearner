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
final int HOW_MANY_UFOS = 4;

int playerScore;
int enemyScore;

Player p1;
ArrayList enemyList;

void setup() // setup() happens once at program start
{
  playerShip = loadImage("player.png");
  ufoShip = loadImage("ufo.png");
  size(800, 600);

  p1 = new Player();

  resetGame();
}

void draw() { // draw() happens every frame (automatically)
  updateAllPositions();
  drawAll();

  forgetPressedKeys(); // from keyHandling file
}

void resetGame()
{
  playerScore = 0;
  enemyScore = 0;

  p1.reset();
  enemyList = new ArrayList();
  for(int i=0;i<HOW_MANY_UFOS;i++) {
    enemyList.add( new UFO(width*(i+1)/(HOW_MANY_UFOS+1), height/10) );
  }
}

void updateAllPositions()
{
  for (int i=0;i<enemyList.size();i++) {
    UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
    oneEnemy.updatePosition();
  }
  p1.updatePosition();
}
void clearScreen()
{
  fill(0,0,0); // color to black
  noStroke();
  rect(0,0,width,height); // wipe whole screen
}

void drawScores()
{
  textAlign(LEFT);
  text("Player: "+playerScore, width/10, 15);
  textAlign(RIGHT);
  text("Enemies: "+enemyScore, width*9/10, 15);
}

void drawAll()
{
  clearScreen();
  for (int i=0;i<enemyList.size();i++) {
    UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
    oneEnemy.drawSaucerAndShot();
  }
  p1.drawRocketAndShot();
  drawScores();
}

