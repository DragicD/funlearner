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

int score = 0;

// screen dimensions (used to derive paddle & brick positions)
final int SCREEN_W = 640;
final int SCREEN_H = 480;

void setup() // setup() happens once at program start
{
  size(SCREEN_W,SCREEN_H);
  
  resetBricks(); // fills the grid of bricks
  ballReset(); //
  
  noStroke(); // no outline on the shapes
}

void draw() // draw() happens every frame (automatically)
{
  fill(0,0,50);
  rect(0,0,SCREEN_W,SCREEN_H);
  
  drawBricks();
  paddleMoveAndDraw();
  ballMoveAndDraw();
  
  fill(255,255,255);
  text(score,15,15);
}

