//// basically all files here are new or rearranged, so no //// per-line markings added
var paddle1Score = 0, paddle2Score = 0;
var paddle1Y = 250, paddle2Y = 250;

const PADDLE_HEIGHT = 80;
const PADDLE_THICKNESS = 10;

const PADDLE_COMPUTER_MOVE_SPEED = 9.0;

function paddlesDraw() {
  // draw a white rectangle to use as the left player's paddle
  colorRect(0, paddle1Y, PADDLE_THICKNESS, PADDLE_HEIGHT, 'white');

  // draw a white rectangle to use as the right player's paddle 
  colorRect(canvas.width-PADDLE_THICKNESS, paddle2Y,   
           PADDLE_THICKNESS, PADDLE_HEIGHT, 'white');
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