final int TRACK_TILE_WIDTH = 40;
final int TRACK_TILE_HEIGHT = TRACK_TILE_WIDTH; // i.e. also 40

final int TRACK_TYPE_PLAIN_ROAD = 0;
final int TRACK_TYPE_GOAL = 1;
final int TRACK_TYPE_P1_START = 2;
final int TRACK_TYPE_P2_START = 3;
final int TRACK_TYPE_WALL = 4;

int[][] worldGrid = { { 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4 },
                      { 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 4, 4 },
                      { 4, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4 },
                      { 4, 0, 0, 0, 4, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0 },
                      { 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
                      { 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
                      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 1, 0, 0 },
                      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                      { 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                      { 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0 },
                      { 4, 4, 4, 0, 0, 0, 0, 4, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0 },
                      { 4, 4, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
                      { 4, 4, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4 }};

void loadMapLayout() {
  for(int row=0;row<worldGrid.length;row++) {
    for(int col=0;col<worldGrid[row].length;col++) {
      if(worldGrid[row][col] == TRACK_TYPE_P1_START) {
        p1.x = col * TRACK_TILE_WIDTH + 0.5 * TRACK_TILE_WIDTH;
        p1.y =  row * TRACK_TILE_HEIGHT + 0.5 * TRACK_TILE_HEIGHT;
        worldGrid[row][col] = TRACK_TYPE_PLAIN_ROAD;
      }
      if(worldGrid[row][col] == TRACK_TYPE_P2_START) {
        p2.x = col * TRACK_TILE_WIDTH + 0.5 * TRACK_TILE_WIDTH;
        p2.y =  row * TRACK_TILE_HEIGHT + 0.5 * TRACK_TILE_HEIGHT;
        worldGrid[row][col] = TRACK_TYPE_PLAIN_ROAD;
      }
    }
  }
}

void worldDrawGrid() {
  for(int row=0;row<worldGrid.length;row++) {
    int tileTL_pixelY = row*TRACK_TILE_HEIGHT;
    for(int col=0;col<worldGrid[row].length;col++) {
      int tileTL_pixelX = col*TRACK_TILE_WIDTH;
      switch(worldGrid[row][col]) {
        case TRACK_TYPE_PLAIN_ROAD:
          fill(200,200,200);
          break;
        case TRACK_TYPE_GOAL:
          fill(255,255,0);
          break;
        case TRACK_TYPE_WALL:
          fill(0,0,255);
          break;
        default: // unexpceted tile type, mark it bright red
          fill(255,0,0);
          break;
      } // end of switch
      rect(tileTL_pixelX,tileTL_pixelY,TRACK_TILE_WIDTH,TRACK_TILE_HEIGHT);
    } // end of for col
  } // end of for row
} // end of function worldDrawGrid

