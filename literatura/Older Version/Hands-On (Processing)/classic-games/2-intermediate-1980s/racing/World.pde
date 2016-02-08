final int TRACK_TILE_WIDTH = 40;
final int TRACK_TILE_HEIGHT = TRACK_TILE_WIDTH;

final int TRACK_TYPE_PLAIN_ROAD = 0;
final int TRACK_TYPE_GOAL = 1;
final int TRACK_TYPE_P1_START = 2;
final int TRACK_TYPE_P2_START = 3;
final int TRACK_TYPE_WALL = 4;
final int TRACK_TYPE_TREE_WALL = 5;
final int TRACK_TYPE_FLAG_WALL = 6;

PImage trackRoad;
PImage trackGoal;
PImage trackWall;
PImage trackTreeWall;
PImage trackFlagWall;

int[][] worldGrid = new int[15][20];

void loadMapImages() {
  // images are looked for in the data/ folder of this sketch
  trackRoad = loadImage("track_road.png");
  trackGoal = loadImage("track_goal.png");
  trackWall = loadImage("track_wall.png");
  trackTreeWall = loadImage("track_treeWall.png");
  trackFlagWall = loadImage("track_flagWall.png");
}

void loadMapLayout() {
  String lines[] = loadStrings("gameTrack.txt");
  
  for(int row=0; row<lines.length; row++) {
    String chunks[] = split(lines[row], ',');
    for(int col=0; col<chunks.length; col++) {
      worldGrid[row][col] = int(trim(chunks[col]));
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
  PImage useThisTileImage;
  for(int row=0;row<worldGrid.length;row++) {
    int tileTL_pixelY = row*TRACK_TILE_HEIGHT;
    for(int col=0;col<worldGrid[row].length;col++) {
      int tileTL_pixelX = col*TRACK_TILE_WIDTH;
      switch(worldGrid[row][col]) {
        case TRACK_TYPE_PLAIN_ROAD:
          useThisTileImage = trackRoad;
          break;
        case TRACK_TYPE_GOAL:
          useThisTileImage = trackGoal;
          break;
        case TRACK_TYPE_WALL:
          useThisTileImage = trackWall;
          break;
        case TRACK_TYPE_TREE_WALL:
          useThisTileImage = trackTreeWall;
          break;
        case TRACK_TYPE_FLAG_WALL:
          useThisTileImage = trackFlagWall;
          break;
        default: // error, invalid number, show which tile and quit map draw
          fill(255,0,0);
          rect(tileTL_pixelX,tileTL_pixelY,TRACK_TILE_WIDTH,TRACK_TILE_HEIGHT);
          return; // return instead of a break, to bail out of this whole function
      } // end of switch
      image(useThisTileImage,tileTL_pixelX,tileTL_pixelY);
    } // end of for col
  } // end of for row
} // end of function worldDrawGrid

