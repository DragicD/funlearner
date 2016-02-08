var paddle1Score = 0, paddle2Score = 0;
var paddle1Y = 250, paddle2Y = 250;

const PADDLE_DIST_FROM_EDGE = 120;
const PADDLE_HEIGHT = 100;
//// note: to reference BALL_SPEED_MAX on the next line, paddle.js needs to be after ball.js in HTML
const PADDLE_THICKNESS = BALL_SPEED_MAX+2; // greater than BALL_SPEED_MAX to avoid skipping paddle ////

const PADDLE_COMPUTER_MOVE_SPEED = 9.0;

function paddlesDraw() {
  drawBitmapPositionedByTopLeftCorner(paddleLeftPic, PADDLE_DIST_FROM_EDGE, paddle1Y); ////

  drawBitmapPositionedByTopLeftCorner(paddleRightPic, 
                   canvas.width-paddleRightPic.width-PADDLE_DIST_FROM_EDGE, paddle2Y); ////
}

function moveComputerPaddle() {
  var paddle2Center = paddle2Y + (PADDLE_HEIGHT/2);
  const AI_SIT_STILL_MARGIN = 35;
  var topChaseLine = paddle2Center - AI_SIT_STILL_MARGIN;
  var bottomChaseLine = paddle2Center + AI_SIT_STILL_MARGIN;
    
  if(ballY < topChaseLine) {
     paddle2Y -= PADDLE_COMPUTER_MOVE_SPEED;
  }
  else if(ballY > bottomChaseLine) {
     paddle2Y += PADDLE_COMPUTER_MOVE_SPEED;
  }
}