final int GRID_TILE_WIDTH = 46;
final int GRID_TILE_HEIGHT = GRID_TILE_WIDTH;

final int GRID_TYPE_SPACE = 0;
final int GRID_TYPE_WALL = 1;
final int GRID_TYPE_COIN = 2;
int totalCoinsInWorld = 0;
int coinsInWorld = 0;

int[][] worldGrid = { { 0, 2, 0, 0, 2, 0, 1, 1, 0 },
                      { 0, 1, 0, 0, 0, 0, 0, 1, 0 },
                      { 2, 1, 0, 1, 0, 1, 0, 0, 0 },
                      { 2, 1, 1, 1, 0, 0, 0, 2, 0 },
                      { 0, 0, 0, 0, 0, 0, 0, 1, 0 },
                      { 0, 1, 0, 1, 0, 1, 0, 0, 0 },
                      { 2, 1, 1, 0, 0, 0, 0, 2, 0 },
                      { 0, 0, 0, 0, 2, 0, 2, 0, 0 } };

void updateCoinCount() {
  coinsInWorld = 0;
  for(int row=0;row<worldGrid.length;row++) {
    for(int col=0;col<worldGrid[row].length;col++) {
      if(worldGrid[row][col] == GRID_TYPE_COIN) {
        coinsInWorld++;
      } // end of if worldGrid at coord
    } // end of for col
  } // end of for row
  totalCoinsInWorld = coinsInWorld;
} // end of void updateCoinCount

int whatIsUnderThisCoordinate(int someX,int someY) {
  int someTileRow = someY / GRID_TILE_HEIGHT;
  int someTileCol = someX / GRID_TILE_WIDTH;
  if(someY < 0) {
    return GRID_TYPE_WALL;
  }
  if(someX < 0) {
    return GRID_TYPE_WALL;
  }
  if(someTileRow >= worldGrid.length) {
    return GRID_TYPE_WALL;
  }
  if(someTileCol >= worldGrid[0].length) {
    return GRID_TYPE_WALL;
  }
  
  return worldGrid[someTileRow][someTileCol];
}

void changeTile(int someX,int someY,int changeTo) {
  int someTileRow = someY / GRID_TILE_HEIGHT;
  int someTileCol = someX / GRID_TILE_WIDTH;
  if(someY < 0) {
    return;
  }
  if(someX < 0) {
    return;
  }
  if(someTileRow >= worldGrid.length) {
    return;
  }
  if(someTileCol >= worldGrid[0].length) {
    return;
  }
  
  worldGrid[someTileRow][someTileCol] = changeTo;
}

void worldDrawGrid() {
  noStroke();
  for(int row=0;row<worldGrid.length;row++) {
    for(int col=0;col<worldGrid[row].length;col++) {
      switch(worldGrid[row][col]) {
        case GRID_TYPE_SPACE:
          fill(0,0,0);
          rect(col*GRID_TILE_WIDTH,
                row*GRID_TILE_HEIGHT,
                 GRID_TILE_WIDTH, GRID_TILE_HEIGHT);
          break;
        case GRID_TYPE_WALL:
          fill(0,255,0);
          rect(col*GRID_TILE_WIDTH,
                row*GRID_TILE_HEIGHT,
                 GRID_TILE_WIDTH, GRID_TILE_HEIGHT);
          break;
        case GRID_TYPE_COIN:
          fill(0,0,0);
          rect(col*GRID_TILE_WIDTH,
                row*GRID_TILE_HEIGHT,
                 GRID_TILE_WIDTH, GRID_TILE_HEIGHT);
          fill(255,255,0);
          ellipse(col*GRID_TILE_WIDTH+GRID_TILE_WIDTH/2,
                  row*GRID_TILE_HEIGHT+GRID_TILE_HEIGHT/2,
                  GRID_TILE_WIDTH,GRID_TILE_HEIGHT);
          break;
      }
    }
  }
}

