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
final int START_LIVES = 3;
int lives = START_LIVES;

// screen dimensions (used to derive paddle & brick positions)
final int SCREEN_W = 640;
final int SCREEN_H = 480;

PImage ball, bg, brick, paddle, lifeIcon;

void setup() // setup() happens once at program start
{
  size(SCREEN_W,SCREEN_H);
  
  ball = loadImage("ball.png");
  bg = loadImage("bg.jpg");
  brick = loadImage("brick.png");
  paddle = loadImage("paddle.png");
  lifeIcon = loadImage("life.png");
  
  ballReset();
  resetGame();
  
  noStroke(); // no outline on the shapes
}

void draw() // draw() happens every frame (automatically)
{
  image(bg,0,0);
  
  drawBricks();
  paddleMoveAndDraw();
  ballMoveAndDraw();
  
  fill(255,255,255);
  text(score,15,15);
  for(int i=0;i<lives;i++) {
    image(lifeIcon, width-50+i*(lifeIcon.width+2),5);
  }
  // text(bricksLeftInGame,width/2,15); // debugging
}

void resetGame()
{
  score = 0;
  lives = START_LIVES;
  resetBricks();
}
