final int TRACK_TILE_WIDTH = 40;
final int TRACK_TILE_HEIGHT = TRACK_TILE_WIDTH;

final int TRACK_TYPE_PLAIN_ROAD = 0;
final int TRACK_TYPE_GOAL = 1;
final int TRACK_TYPE_P1_START = 2;
final int TRACK_TYPE_P2_START = 3;
final int TRACK_TYPE_WALL = 4;
final int TRACK_TYPE_TREE_WALL = 5;
final int TRACK_TYPE_FLAG_WALL = 6;
final int TRACK_TYPE_GRASS = 7;
final int TRACK_TYPE_OIL = 8;

PImage trackRoad;
PImage trackGoal;
PImage trackWall;
PImage trackTreeWall;
PImage trackFlagWall;
PImage trackGrass;
PImage trackOil;

int[][] worldGrid = new int[15][20];

final int THEME_SET_DAY = 0;
final int THEME_SET_NIGHT = 1;
int themeSet = THEME_SET_DAY;

void loadMapImages() {
  String themeWord = "";
  if(themeSet == THEME_SET_DAY) {
    themeWord = "_day";
  } else {
    themeWord = "_night";
  }
  // images are looked for in the data/ folder of this sketch
  trackRoad = loadImage("track_road"+themeWord+".png");
  trackGoal = loadImage("track_goal"+themeWord+".png");
  trackWall = loadImage("track_wall"+themeWord+".png");
  trackTreeWall = loadImage("track_treeWall"+themeWord+".png");
  trackFlagWall = loadImage("track_flagWall"+themeWord+".png");
  trackGrass = loadImage("track_grass"+themeWord+".png");
  trackOil = loadImage("track_oil"+themeWord+".png");
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
        case TRACK_TYPE_GRASS:
          useThisTileImage = trackGrass;
          break;
        case TRACK_TYPE_OIL:
          useThisTileImage = trackOil;
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

