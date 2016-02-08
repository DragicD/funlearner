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

PImage img_bg;
PImage img_infantry;
PImage img_infantry_off;
PImage img_infantry_heavy;
PImage img_infantry_heavy_off;

final int UNITS_IN_NEW_BATTLE = 120;

ArrayList units = new ArrayList();
ArrayList selectedUnits = new ArrayList();
Unit newSelection = null;
boolean showHelp = true;

int playerArmyUnitsAlive;
int enemyArmyUnitsAlive;

void setup() { // setup() happens once at program start
  size(640,480);

  img_bg = loadImage("grass.jpg");
  img_infantry = loadImage("robot.png");
  img_infantry_off = loadImage("robot-off.png");
  img_infantry_heavy = loadImage("robot-heavy.png");
  img_infantry_heavy_off = loadImage("robot-heavy-off.png");
  
  resetUnits();
  resetMouseLasso();
}

void drawBackgroundToErasePreviousState() {
  image(img_bg,0,0);
}

void draw() { // draw() happens every frame (automatically)
  drawBackgroundToErasePreviousState();
  
  // drawing dead in earlier pass so they never get drawn
  // on top of / over the living units. As a minor optimization
  // we could keep a separate ArrayList to move dead unis to,
  // but at this protoype scale that's not really necessary
  noStroke(); // turning off stroke for dead units
  for(int i=0;i<units.size();i++) {
    Unit eachUnit = (Unit)units.get(i);
    if(eachUnit.isDead) {
      eachUnit.drawDead();
    }
  }
  
  // clear count of living units, will recount while updating units
  playerArmyUnitsAlive = 0;
  enemyArmyUnitsAlive = 0;

  for(int i=0;i<units.size();i++) {
    Unit eachUnit = (Unit)units.get(i);
    if(eachUnit.isDead==false) {
      eachUnit.moveMe();
      eachUnit.drawMe();
      
      // updating tally of how many are alive on each team
      if(eachUnit.playerTeam) {
        playerArmyUnitsAlive++;
      } else {
        enemyArmyUnitsAlive++;
      }
    }
  }

  // NOTE: this next loop is not through all units, but
  // is only through the currently SELECTED units
  // backward loop, so that we can remove safely as we iterate
  for(int i=selectedUnits.size()-1;i>=0;i--) {
    Unit eachUnit = (Unit)selectedUnits.get(i);
    if(eachUnit.isDead) {
      selectedUnits.remove(i);
    } else {
      eachUnit.showSelectionBox();
      eachUnit.showHealth();
    }
  }
  
  drawMouse();
    
  interfaceDisplay();
}

void interfaceDisplay() {
  fill(255,255,255);
  if(showHelp) {
    text("Click/drag to lasso select\n"+
       "Lasso empty area to deselect\n"+
       "While player units are selected:\n"+
       "1. click on empty area to move\n"+
       "2. click on an enemy to attack\n"+
       "(Press 'H' to hide this text!)",width-210,15);
  } else {
    text("Press 'H' to toggle help text",width-210,15);
  }
       
  text("PLAYER: " + playerArmyUnitsAlive +
       "  /  ENEMY: " + enemyArmyUnitsAlive,5,height-5);
  if(playerArmyUnitsAlive==0) {
    text("ENEMY WON! (PRESS SPACE TO RESET)",5,height-20);
  } else if(enemyArmyUnitsAlive==0) {
    text("YOU WON! (PRESS SPACE TO RESET)",5,height-20);
  }
}

void resetUnits() {
  units.clear();
  selectedUnits.clear();
  for(int i=0;i<UNITS_IN_NEW_BATTLE;i++) {
    units.add( new Unit() );
  }
}

void keyPressed() { // called when any key gets pressed
  if(key == ' ') {
    if(playerArmyUnitsAlive==0 || enemyArmyUnitsAlive==0) {
      resetUnits();
    }
  }
  if(key == 'h' || key == 'H') {
    showHelp = !showHelp;
  }
}


