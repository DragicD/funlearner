// ball values
float ballX, ballY;
float ballSpeedX, ballSpeedY;

boolean brickHitYet = false; // one brick per each trip from back wall or paddle

boolean playerHasBall = true;

void ballReset()
{
  ballSpeedX = 2.0;
  ballSpeedY = 4.0;
  playerHasBall = true;
  lives--;
  if(lives < 0) {
    resetGame();
  }
}

void ballMovement()
{
  if(playerHasBall) {
    ballX = paddleX+10;
    ballY = PADDLE_Y-10;
    return;
  }
  
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  if(ballX <= 0.0 && ballSpeedX < 0.0) { // off left and going left
    ballSpeedX *= -1.0; // bounce horizontally
  }
  if(ballX >= SCREEN_W && ballSpeedX > 0.0) { // off right and going right
    ballSpeedX *= -1.0; // bounce horizontally
  }
  if(ballY <= 0.0) { // off top edge?
    brickHitYet = false; // let it hit bricks on the way down
    ballSpeedY *= -1.0; // bounce vertically
  }
  if(ballY >= SCREEN_H) { // off bottom edge?
    ballReset(); // reset ball position
  }
  
  /*
  // multi-line comment goes from slash-star to star-slash
  // when this is uncommented, holding the mouse button
  // lets you test brick removal faster by waggling the cursor
  // over the bricks, then let go of the button to hit it with
  // the paddle to test whether returning the shot resets bricks
  if(mousePressed) { // debug functionality
    ballX = mouseX;
    ballY = mouseY;  
  }*/
}

void ballHitCheck()
{
  // this part checks ball against brick
  if(brickHitYet == false && // disallow more than 1 brick per trip off back or paddle
     ballX >= BRICK_TOPLEFT_X &&
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
         bricksLeftInGame--;
         score += 100; // add points per brick
         ballSpeedY *= -1.0; // never horizontal flip, vertical only
         brickHitYet = true; // don't let it hit another brick til paddle or back wall
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
    
    brickHitYet = false; // let it hit a brick on the way up
    
    if(bricksLeftInGame == 0) {
      resetBricks();
    }
    
  }
}

void ballDraw()
{
  image(ball,ballX-ball.width/2,ballY-ball.height/2);
}

void ballMoveAndDraw()
{
  ballMovement();
  ballHitCheck();
  ballDraw();
}

