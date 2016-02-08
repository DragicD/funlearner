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
float figureRotation;

boolean keyHeld_TurnLeft;
boolean keyHeld_TurnRight;

void setup() { // setup() happens once at program start
  playerShip = loadImage("player.png");
  size(320 , 240);
}

void draw() { // draw() happens every frame (automatically)
  background(0,0,255);
  
  if(keyHeld_TurnLeft) {
    figureRotation -= 0.05;
  }
  if(keyHeld_TurnRight) {
    figureRotation += 0.05;
  }
  
  drawSpinningFigure();
}

void drawSpinningFigure()
{
  // pushMatrix and popMatrix surround translate (move) and
  // rotate (spin) calls. Such calls accumulate to affect
  // calls to image(), but popMatrix forgets/clears the
  // accumulated offsets so it won't affect later image() calls
  
  pushMatrix();
  translate(width/2,height/2);
  rotate(figureRotation);
  image(playerShip,-playerShip.width/2,-playerShip.height/2);
  popMatrix();
  
  // since this example only draws 1 image and the
  // pushMatrix/popMatrix resets after draw() anyhow, in this
  // particular program they're technically not necessary, but
  // I've included them here since they'll be essential as soon
  // as we begin drawing multiple images to the screen 
}

void keyPressed() { // called when any keyboard key goes down
  // since this gets called no matter which key got pressed,
  // we use if statements to match against which key it was
  // keyCode is for non-character keys, key is for letters/numbers
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = true;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = true;
  }
}

void keyReleased() { // called when any keyboard key rises
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = false;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = false;
  }
}

