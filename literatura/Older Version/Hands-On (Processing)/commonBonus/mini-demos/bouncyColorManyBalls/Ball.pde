class Ball {
  float ballX, ballY;
  float ballXV, ballYV;
  int ballDimension;
  int ballRadius;
  color myCol;

  Ball(int startX, int startY, int startXV,
       int startYV,int startDimension) {
       ballX = startX;
       ballY = startY;
       ballXV = (float)startXV;
       ballYV = (float)startYV;
       ballDimension = startDimension;
       ballRadius = ballDimension/2;
       myCol = color( random(255),
                      random(255),
                      random(255) );
  }  

  void drawAndMoveBall() {
    ballX += ballXV;
    ballY += ballYV;

    if (ballX+ballRadius > width) {
      if(ballXV > 0) {
        ballXV = -ballXV;
      }
    }
    if (ballX-ballRadius < 0) {
      if(ballXV < 0) {
        ballXV = -ballXV;
      }
    }
    if (ballY+ballRadius > height) {
      if(ballYV > 0) {
        ballYV = -ballYV;
        ballYV *= 0.97; // dampen speed upon bounce
      }
    }
    if (ballY-ballRadius < 0) {
      if(ballYV < 0) {
        ballYV = -ballYV;
      }
    }
    ballYV += 0.2; // gravity power
    fill(myCol);
    ellipse(ballX, ballY, ballDimension, ballDimension);
  }
  
}

