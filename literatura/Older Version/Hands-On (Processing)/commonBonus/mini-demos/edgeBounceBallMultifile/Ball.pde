int ballSize = 80;
int ballRadius = ballSize / 2;
int ballPositionX = 250;
int ballMoveX = 5;
int ballPositionY = 80;
int ballMoveY = 8;

void ballDraw() {
  ellipse(ballPositionX,ballPositionY,
          ballSize,ballSize);
}

void ballEdgeCheck() {
  int ballRightEdge = ballPositionX + ballRadius;
  if(ballRightEdge > width && ballMoveX > 0) {
    ballMoveX = -ballMoveX;
  }
  
  int ballLeftEdge = ballPositionX - ballRadius; 
  if(ballLeftEdge < 0 && ballMoveX < 0) {
    ballMoveX = -ballMoveX;
  }
  
  int ballBottomEdge = ballPositionY + ballRadius;
  if(ballBottomEdge > height && ballMoveY > 0) {
    ballMoveY = -ballMoveY;
  }
  
  int ballTopEdge = ballPositionY - ballRadius;
  if(ballTopEdge < 0 && ballMoveY < 0) {
    ballMoveY = -ballMoveY;
  }
}

void ballMove() {
  ballPositionX += ballMoveX;
  ballPositionY += ballMoveY;
}
