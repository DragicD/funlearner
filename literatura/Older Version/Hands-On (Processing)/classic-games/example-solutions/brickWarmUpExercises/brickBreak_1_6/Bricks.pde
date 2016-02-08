// brick values
final float BRICK_W = 60.0;
final float BRICK_H = 20.0;
final float BRICK_GAP = 1.0;
final int BRICK_COLS = 10;
final int BRICK_ROWS = 10;
final float BRICK_TOPLEFT_X = (SCREEN_W-BRICK_W*BRICK_COLS)*0.5;
final float BRICK_TOPLEFT_Y = 20.0;
int[][] brickGrid = new int[BRICK_ROWS][BRICK_COLS];
int bricksLeftInGame;

void resetBricks()
{
  for(int row = 0; row < BRICK_ROWS; row++) {
    for(int col = 0; col < BRICK_COLS; col++) {
      brickGrid[row][col] = 1;
    }
  }
  bricksLeftInGame = BRICK_ROWS*BRICK_COLS;
}

void drawBricks()
{
  fill(255,0,255);
  for(int row = 0; row < BRICK_ROWS; row++) {
    for(int col = 0; col < BRICK_COLS; col++) {
      if( brickGrid[row][col] == 1 ) {
        rect(BRICK_TOPLEFT_X + col*BRICK_W,
             BRICK_TOPLEFT_Y + row*BRICK_H,
             BRICK_W - BRICK_GAP,
             BRICK_H - BRICK_GAP);
      }
    }
  }
}

