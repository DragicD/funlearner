float ballX, ballY;
float ballXV, ballYV;
float ballDiameter = 30;

final float FRICTION = 0.97;

void resetBall() {
  ballX=ballY=100;
  ballXV=ballYV=0.0;
}

void checkIfGoalMade() {
  if( dist(goalX,goalY, ballX,ballY) < ballDiameter*0.5+
                                       goalDiameter*0.5 ) {
    resetAll();
  }
}

void bounceIfLeavingScreen() {
  float ballRadius = ballDiameter*0.5;
  
  if(ballX > width-ballRadius) {
    ballXV = -abs(ballXV);
  }
  if(ballX < ballRadius) {
    ballXV = abs(ballXV);
  }
  if(ballY > height-ballRadius) {
    ballYV = -abs(ballYV);
  }
  if(ballY < ballRadius) {
    ballYV = abs(ballYV);
  }
}

void drawAndMoveBall() {
  checkIfGoalMade();
  
  bounceIfLeavingScreen();
  
  ballX += ballXV;
  ballY += ballYV;
  
  ballXV *= FRICTION;
  ballYV *= FRICTION;
  
  fill(255,255,255);
  ellipse(ballX, ballY, ballDiameter,ballDiameter);
}
