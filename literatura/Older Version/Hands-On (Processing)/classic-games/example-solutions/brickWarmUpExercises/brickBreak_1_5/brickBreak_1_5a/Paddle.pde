// paddle values
final int PADDLE_WIDTH = 60;
final float PADDLE_Y = SCREEN_H * 0.9;
final float PADDLE_HEIGHT = 10.0;
float paddleX;

void paddleMovement()
{
  paddleX = mouseX;
}

void paddleDraw()
{
  fill(255,255,0); // set fill color to yellow; applies until fill() set otherwise
  // rect takes 4 args: left x, top y, width, height
  rect(paddleX-PADDLE_WIDTH/2,
       PADDLE_Y-PADDLE_HEIGHT/2,
       PADDLE_WIDTH,PADDLE_HEIGHT);
}

void paddleMoveAndDraw()
{
  paddleMovement();
  paddleDraw();
}
