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
  image(paddle,paddleX-PADDLE_WIDTH/2,
               PADDLE_Y-PADDLE_HEIGHT/2);
}

void paddleMoveAndDraw()
{
  paddleMovement();
  paddleDraw();
}
