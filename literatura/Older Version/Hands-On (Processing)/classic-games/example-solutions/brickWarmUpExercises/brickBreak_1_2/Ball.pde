// ball values
float ballX, ballY;
float ballSpeedX, ballSpeedY;

void ballReset()
{
  ballX = SCREEN_W/2;
  ballY = SCREEN_H*0.7;
  ballSpeedX = 2.0;
  ballSpeedY = 4.0;
  score = 0;
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
         
         score += 100; // add points per brick
         
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

