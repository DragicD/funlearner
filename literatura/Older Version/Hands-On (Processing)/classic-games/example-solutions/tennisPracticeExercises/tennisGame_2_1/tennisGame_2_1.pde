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
 
boolean reflectInsteadOfAim = false;

// tuning values to simplify tweaks to ball speed increase
float AI_PADDLE_MOVE_SPEED = 9.5;
float BALL_REFLECT_Y_SPEED_PROPORTION = 0.18; 

// ball values
float ballX = 100, ballY = 100;
float ballSpeedX = 6.0, ballSpeedY = 4.0;
float ballSpeedMult = 1.0; // increases during play
float BALL_SPEED_MULT_INC = 0.1; // incease per hit
float BALL_SPEED_MULT_MAX = 2.25; // keep speed sane

// paddle values
float paddle1Y = 100.0, paddle2Y = 100.0;
float PADDLE_HEIGHT = 100.0;

// score values
int scoreP1 = 0, scoreP2 = 0;
int PLAY_TIL_SCORE = 3;

void setup() { // setup() happens once at program start
 size(800,600);
 
 // by default text() calls left align, but this next call
 // means all text() calls in the program will center text
 textAlign(CENTER);
}

void draw() { // draw() happens every frame (automatically)
  // erase what the previous frame drew
  fill(0,0,0); // set fill color to black
  rect(0,0,width,height); // then wipe the screen with the black
  
  fill(255,255,255); // set fill to white for remaining graphics
  
  // note that background(0); achieves the same effect as the
  // above without altering the fill color for later calls.
  // though convenient it also hides what's going on, so I've
  // opted to use the above approach to be more explicit.
  
  drawNet();
  
  if(scoreP1 >= PLAY_TIL_SCORE)  {
    text("Player 1 Wins!\nClick to restart",
         width/2,height/2);
    resetUponNextClick();
  } else if(scoreP2 >= PLAY_TIL_SCORE)  {
    text("Player 2 Wins!\nClick to restart",
         width/2,height/2);
     resetUponNextClick();
  } else { // neither player has enough points, keep playing
    moveAndDrawPlayerPaddle();
    
    moveAndDrawComputerPaddle();
    
    moveAndDrawBall();
  }
  
  // display scores
  text(scoreP1,width/2-10,15);
  text(scoreP2,width/2+10,15);
  
  // check the ball against the screen edges
  boundsAndPaddleCheck();
}

void moveAndDrawPlayerPaddle() {
  paddle1Y = mouseY - (PADDLE_HEIGHT/2);
  rect(0,paddle1Y,10,PADDLE_HEIGHT);
}

void moveAndDrawComputerPaddle() {
  float AItargetY = ballY- (PADDLE_HEIGHT/2);
  
  if(paddle2Y < AItargetY-35.0) {
     paddle2Y += AI_PADDLE_MOVE_SPEED;
  }
  else if(paddle2Y > AItargetY+35.0) {
     paddle2Y -= AI_PADDLE_MOVE_SPEED;
  }
  
  rect(width-11,paddle2Y,10,PADDLE_HEIGHT);
}

void moveAndDrawBall() {
  // move and draw ball
  ballX += ballSpeedX * ballSpeedMult;
  ballY += ballSpeedY * ballSpeedMult;

  ellipse(ballX,ballY,20,20);
}

void ballReset() {
  // reverse ball heading, so whoever scored a point serves
  ballSpeedX = -ballSpeedX;
  ballSpeedY = 0.0;
  
  ballSpeedMult = 1.0; // slow back down start speed
  
  // center ball on screen
  ballX = width/2;
  ballY = height/2;
}

void ballSpeedUp() {
  ballSpeedMult += BALL_SPEED_MULT_INC;
  if(ballSpeedMult > BALL_SPEED_MULT_MAX) {
    ballSpeedMult = BALL_SPEED_MULT_MAX;
  }
}

// bounce ball off top/bottom edges and paddles
void boundsAndPaddleCheck() {
  if(ballX > width) { // ball went past right edge
    
    // if ball is below top of p2 paddle and above bottom...
    if(ballY > paddle2Y &&
       ballY < paddle2Y+PADDLE_HEIGHT) {
      // then p2 hit the ball, so flip its horizontal heading
      ballSpeedX = -ballSpeedX;
      ballSpeedUp();

      if(reflectInsteadOfAim == false) {
      // and set y speed based on distance from paddle center
        float deltaY = ballY-(paddle2Y+PADDLE_HEIGHT/2);
        ballSpeedY = deltaY * BALL_REFLECT_Y_SPEED_PROPORTION;
      }
    } else { // otherwise player 1 scored
      scoreP1++;
      ballReset();
    }
  }
  
  if(ballX < 0) { // ball went past left edge
  
    // if ball is below top of p1 paddle and above bottom...
    if(ballY > paddle1Y &&
       ballY < paddle1Y+PADDLE_HEIGHT)
    {
      // then p1 hit the ball, so flip its horizontal heading
      ballSpeedX = -ballSpeedX;
      ballSpeedUp();
      
      if(reflectInsteadOfAim == false) {
      // and set y speed based on distance from paddle center
        float deltaY = ballY-(paddle1Y+PADDLE_HEIGHT/2);
        ballSpeedY = deltaY * BALL_REFLECT_Y_SPEED_PROPORTION;
      }
    } else { // otherwise player 2 scored
      scoreP2++;
      ballReset();
    }
  }
  
  if(ballY > height) { // ball bouncing off bottom
    ballSpeedY = -ballSpeedY;
  }
  if(ballY < 0) { // ball bouncing off top
    ballSpeedY = -ballSpeedY;
  }
}

// draws the dashed line down the middle
void drawNet() {
  // the for loop drawing the dashed line, spatially, can be
  // read, "starting at the top of the screen, as long as
  // we're still above the bottom of the screen, draw a
  // 2x20 pixel rectangle at every 40 pixel interval"
  for(int i=0;i<height;i+=40) {
    rect(width/2-1,i,2,20);
  }
}

// called when either player has enough points to have won
void resetUponNextClick() {
  if(mousePressed) { // true only when mouse button is down
    scoreP1 = scoreP2 = 0; // reset scores
    ballReset(); // reset the ball
  }
}

