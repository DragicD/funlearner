final int TRACK_TILE_WIDTH = 40;
final int TRACK_TILE_HEIGHT = TRACK_TILE_WIDTH; // i.e. also 40

final int TRACK_TYPE_PLAIN_ROAD = 0;
final int TRACK_TYPE_GOAL = 1;
final int TRACK_TYPE_P1_START = 2;
final int TRACK_TYPE_P2_START = 3;
final int TRACK_TYPE_WALL = 4;

int[][] worldGrid = new int[15][20];

void loadMapLayout() {
  String lines[] = loadStrings("gameTrack.txt"); // added
  
  for(int row=0;row<worldGrid.length;row++) {
    String chunks[] = split(lines[row], ','); // added
    
    for(int col=0;col<worldGrid[row].length;col++) {
      worldGrid[row][col] = int(trim(chunks[col])); // added
      
      if(worldGrid[row][col] == TRACK_TYPE_P1_START) {
        p1.startX = col * TRACK_TILE_WIDTH + 0.5 * TRACK_TILE_WIDTH;
        p1.startY =  row * TRACK_TILE_HEIGHT + 0.5 * TRACK_TILE_HEIGHT;
        worldGrid[row][col] = TRACK_TYPE_PLAIN_ROAD;
      }
      if(worldGrid[row][col] == TRACK_TYPE_P2_START) {
        p2.startX = col * TRACK_TILE_WIDTH + 0.5 * TRACK_TILE_WIDTH;
        p2.startY =  row * TRACK_TILE_HEIGHT + 0.5 * TRACK_TILE_HEIGHT;
        worldGrid[row][col] = TRACK_TYPE_PLAIN_ROAD;
      }
    }
  }
}

int whatIsAtThisCoordinate(float someX,float someY) {
  int someTileRow = (int)(someY / TRACK_TILE_HEIGHT);
  int someTileCol = (int)(someX / TRACK_TILE_WIDTH);
  
  return worldGrid[someTileRow][someTileCol];
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

