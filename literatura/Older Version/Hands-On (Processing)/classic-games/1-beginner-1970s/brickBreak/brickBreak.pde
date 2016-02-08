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

// screen dimensions (used to derive paddle & brick positions)
final int SCREEN_W = 640;
final int SCREEN_H = 480;

// ball values
float ballX, ballY;
float ballSpeedX, ballSpeedY;

// paddle values
final int PADDLE_WIDTH = 60;
final float PADDLE_Y = SCREEN_H * 0.9;
final float PADDLE_HEIGHT = 10.0;
float paddleX;

// brick values
final float BRICK_W = 60.0;
final float BRICK_H = 20.0;
final float BRICK_GAP = 1.0;
final int BRICK_COLS = 10;
final int BRICK_ROWS = 10;
final float BRICK_TOPLEFT_X = (SCREEN_W-BRICK_W*BRICK_COLS)*0.5;
final float BRICK_TOPLEFT_Y = 20.0;
int[][] brickGrid = new int[BRICK_ROWS][BRICK_COLS];
int bricksLeftInGame;

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
}

void resetBricks()
{
  for(int row = 0; row < BRICK_ROWS; row++) {
    for(int col = 0; col < BRICK_COLS; col++) {
      brickGrid[row][col] = 1;
    }
  }
}

void drawBricks()
{
  bricksLeftInGame = 0;
  
  fill(255,0,255);
  for(int row = 0; row < BRICK_ROWS; row++) {
    for(int col = 0; col < BRICK_COLS; col++) {
      if( brickGrid[row][col] == 1 ) {
        bricksLeftInGame++;
        rect(BRICK_TOPLEFT_X + col*BRICK_W,
             BRICK_TOPLEFT_Y + row*BRICK_H,
             BRICK_W - BRICK_GAP,
             BRICK_H - BRICK_GAP);
      } // end of if brick found
    } // end of for col
  } // end of for row
} // end of drawBricks

void ballReset()
{
  ballX = SCREEN_W/2;
  ballY = SCREEN_H*0.7;
  ballSpeedX = 2.0;
  ballSpeedY = 4.0;
}

void ballMovement()
{
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  if(ballX <= 0.0 || ballX >= SCREEN_W) { // off left or right edge?
    ballSpeedX *= -1.0; // bounce horizontally
  }
  if(ballY <= 0.0) { // off top edge?
    ballSpeedY *= -1.0; // bounce vertically
  }
  if(ballY >= SCREEN_H) { // off bottom edge?
    ballReset(); // reset ball position
  }
}

void ballHitCheck()
{
  // this part checks ball against brick
  if(ballX >= BRICK_TOPLEFT_X &&
     ballX < BRICK_TOPLEFT_X + BRICK_W * BRICK_COLS &&
     ballY >= BRICK_TOPLEFT_Y &&
     ballY < BRICK_TOPLEFT_Y + BRICK_H * BRICK_ROWS) {
       // being in this if means the ball is someplace a brick could be
       int hitCol = (int) ((ballX - BRICK_TOPLEFT_X) / BRICK_W);
       int hitRow = (int) ((ballY - BRICK_TOPLEFT_Y) / BRICK_H);
       
       // hitCol and hitRow are how many bricks in from the left and top
       // the ball's current position falls within
       
       if( brickGrid[hitRow][hitCol] == 1 ) { // brick still there?
         brickGrid[hitRow][hitCol] = 0; // then clear the brick
         
         /*
         Next we'll compute where the ball was previously by subtracting
         its speed, and which brick row/col corresponds to that position.
         If the ball's previous position was in a different column we
         reflect it horizontally, if it was in a different row we reflect
         it vertically. There are more robust ways to determine how the
         ball should reflect, but this is a relatively easy one to think
         through. See the exercises for other ways to handle this.
         */
         
         float prevBallX = ballX - ballSpeedX;
         float prevBallY = ballY - ballSpeedY;
         int prevCol,prevRow;

         if( prevBallX < BRICK_TOPLEFT_X ) {
           prevCol = -1;
         } else {
           prevCol = (int) ((prevBallX - BRICK_TOPLEFT_X) / BRICK_W);
         }
         
         if( prevBallY < BRICK_TOPLEFT_Y ) {
           prevRow = -1;
         } else {
           prevRow = (int) ((prevBallY - BRICK_TOPLEFT_Y) / BRICK_H);
         }
         
         if(prevCol != hitCol) {
           ballSpeedX *= -1.0;
         }
         if(prevRow != hitRow) {
           ballSpeedY *= -1.0;
         }
       }
   }
  
  // this part checks ball against paddle
  if(ballX >= paddleX-PADDLE_WIDTH/2 && // ball is right of paddle left edge
     ballX <= paddleX+PADDLE_WIDTH/2 && // ball is left of paddle right edge
     ballY >= PADDLE_Y-PADDLE_HEIGHT/2 && // ball is below paddle top edge
     ballY <= PADDLE_Y+PADDLE_HEIGHT/2 && // ball is above paddle bottom edge
     ballSpeedY >= 0.0) { // ball is moving downward (avoids wiggling caught in middle)
    
    float distanceFromPaddleMiddle = (ballX-paddleX);
    float percentageFromMiddle = distanceFromPaddleMiddle/(PADDLE_WIDTH/2);
    float maxLateralSpeed = 4.0;
    ballSpeedX = percentageFromMiddle * maxLateralSpeed;
    ballSpeedY *= -1.0; // reverse ball vertical speed
    
    if(bricksLeftInGame == 0) {
      resetBricks();
    }
    
  }
}

void ballDraw()
{
  fill(0,255,0); // set fill color to green; applies until fill() set otherwise
  ellipse(ballX,ballY,10,10); // ellipse takes 4 args: center x,center y,width,height
}

void ballMoveAndDraw()
{
  ballMovement();
  ballHitCheck();
  ballDraw();
}

void paddleMovement()
{
  paddleX = mouseX;
}

void paddleDraw()
{
  fill(255,255,0); // set fill color to yellow; applies until fill() set otherwise
  // rect takes 4 args: left x, top y, width, height
  rect(paddleX-PADDLE_WIDTH/2,
       PADDLE_Y-PADDLE_HEIGHT/2,
       PADDLE_WIDTH,PADDLE_HEIGHT);
}

void paddleMoveAndDraw()
{
  paddleMovement();
  paddleDraw();
}

