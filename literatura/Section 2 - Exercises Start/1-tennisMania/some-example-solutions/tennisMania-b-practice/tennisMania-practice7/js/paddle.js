var paddle1Score = 0, paddle2Score = 0;
var paddle1Y = 250, paddle2Y = 250;

const PADDLE_DIST_FROM_EDGE = 120;
const PADDLE_HEIGHT = 100;
const PADDLE_THICKNESS = BALL_SPEED_MAX+2; // greater than BALL_SPEED_MAX to avoid skipping paddle

const PADDLE_COMPUTER_MOVE_SPEED = 9.0;

const PADDLE_TWO_PLAYER_KEYBOARD_MOVE_SPEED = 18.0;

function paddlesDraw() {
  drawBitmapPositionedByTopLeftCorner(paddleLeftPic, PADDLE_DIST_FROM_EDGE, paddle1Y);

  drawBitmapPositionedByTopLeftCorner(paddleRightPic, 
                   canvas.width-paddleRightPic.width-PADDLE_DIST_FROM_EDGE, paddle2Y);
}

function twoPlayerKeyControls() {
  if(leftPlayerKeyHeld_Up) {
    paddle1Y -= PADDLE_TWO_PLAYER_KEYBOARD_MOVE_SPEED;
    if(paddle1Y < 0) {
      paddle1Y = 0;
    }
  }
  if(leftPlayerKeyHeld_Down) {
    paddle1Y += PADDLE_TWO_PLAYER_KEYBOARD_MOVE_SPEED;
    if(paddle1Y >= canvas.height-paddleLeftPic.height) {
      paddle1Y = canvas.height-paddleLeftPic.height;
    }
  }
  if(rightPlayerKeyHeld_Up) {
    paddle2Y -= PADDLE_TWO_PLAYER_KEYBOARD_MOVE_SPEED;
    if(paddle2Y < 0) {
      paddle2Y = 0;
    }
  }
  if(rightPlayerKeyHeld_Down) {
    paddle2Y += PADDLE_TWO_PLAYER_KEYBOARD_MOVE_SPEED;
    if(paddle2Y >= canvas.height-paddleRightPic.height) {
      paddle2Y = canvas.height-paddleRightPic.height;
    }
  }
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