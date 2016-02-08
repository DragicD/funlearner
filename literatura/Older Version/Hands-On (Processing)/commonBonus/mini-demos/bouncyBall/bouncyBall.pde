float ballX=500;
float ballY=200;
float ballSpeedX=-2;
float ballSpeedY=-2;

void setup ()
{
  size(800, 600);
}
void draw()
{
  fill(0, 0, 0);
  rect(0, 0, 800, 600);
  fill(255, 255, 0);
  ellipse(ballX, ballY, 30, 30);
  ballX=ballX+ballSpeedX;
  if (ballX<0)
  {
    ballSpeedX=2;
  }
  if (ballX>800)
  {
    ballSpeedX=-10;
  }
  
  ballSpeedY = ballSpeedY + 0.2;
  ballY=ballY+ballSpeedY;
  if (ballY<0)
  {
    ballSpeedY=-ballSpeedY;
  }
  if (ballY>600)
  {
    ballSpeedY=-ballSpeedY;
  }
}  

