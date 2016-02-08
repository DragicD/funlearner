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
final int HOW_MANY_UFOS_AT_START = 3;
final int PLAYER_START_LIVES = 4;

final int STAR_COUNT = 200;

// these are classes/objects, must initialize with "new" before use - see setup()
ScoreAndProgress worldState;
Player p1;
ArrayList enemyList;
ArrayList starPoints;

boolean onTitleScreen = true;

void setup() // setup() happens once at program start
{
  playerShip = loadImage("player.png");
  ufoShip = loadImage("ufo.png");
  size(800, 600);

  worldState = new ScoreAndProgress();
  worldState.loadSavedHighScore();

  p1 = new Player();

  enemyList = new ArrayList();

  createStarfield();

  resetGame();
}

void draw() { // draw() happens every frame (automatically)
  if (onTitleScreen) {
    worldState.showTitleScreen();

    if (keyPressed_Space) {
      onTitleScreen = false;
      resetGame();
    }
  } 
  else {
    checkForGameOverOrNextLevel();

    updateAllPositions();
    drawAll();
  }
  forgetPressedKeys(); // from keyHandling file
}

void resetShipPositions()
{
  p1.reset();
  
  enemyList.clear();
  int enemiesInThisLevel = HOW_MANY_UFOS_AT_START+(worldState.level()-1);
  for (int i=0;i<enemiesInThisLevel;i++) {
    enemyList.add( new UFO(width*(i+1)/(enemiesInThisLevel+1), height/10) );
  }

  for (int i=0;i<enemyList.size();i++) {
    UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
    oneEnemy.reset();
  }
}

void resetGame()
{
  worldState.reset();
  resetShipPositions();
}

void updateAllPositions()
{
  for (int i=enemyList.size()-1; i>=0; i--) { // note: backwards, for removal
    UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
    if ( oneEnemy.readyToRemove() ) {
      enemyList.remove(i);
    } 
    else {
      oneEnemy.updatePosition();
      oneEnemy.collisionCheck(p1);
    }
  }
  p1.updatePosition();
}

void createStarfield()
{
  starPoints = new ArrayList();
  for (int i=0; i<STAR_COUNT; i++) {
    starPoints.add( new PVector( random(width), random(height) ) );
  }
}

void drawStars()
{
  for (int i=0;i<starPoints.size();i++) {
    PVector oneStar = (PVector)starPoints.get(i);
    stroke(random(255), random(255), random(255));
    point(oneStar.x, oneStar.y);
  }
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
  drawStars();
  for (int i=0;i<enemyList.size();i++) {
    UFO oneEnemy = (UFO)enemyList.get(i); // get the UFO at that index
    oneEnemy.drawSaucerAndShot();
  }
  p1.drawRocketAndShot();
  worldState.display();
}

void checkForGameOverOrNextLevel() {
  worldState.handleStateChangeTimers();
}

