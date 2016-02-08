var paddle1Score = 0, paddle2Score = 0;
var paddle1Y = 250, paddle2Y = 250;

const PADDLE_HEIGHT = 100; //// changed to match vertical size of paddle graphic
const PADDLE_THICKNESS = 10;

const PADDLE_COMPUTER_MOVE_SPEED = 9.0;

function paddlesDraw() {
  drawBitmapPositionedByTopLeftCorner(paddleLeftPic, 0.0, paddle1Y); ////

  drawBitmapPositionedByTopLeftCorner(paddleRightPic, ////
                                      canvas.width-paddleRightPic.width, paddle2Y); ////
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