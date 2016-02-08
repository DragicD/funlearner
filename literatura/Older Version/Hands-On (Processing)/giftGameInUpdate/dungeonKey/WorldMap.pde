class World {
  static final int TILE_EMPTY = 0;
  static final int TILE_SOLID = 1;
  static final int TILE_KEY = 2;
  static final int TILE_DOOR = 3;
  static final int TILE_START = 4; // the player starts where this is placed
  static final int TILE_GOALBLOCK = 5;
  static final int TILE_TYPES = 6;

  PImage worldArt[] = new PImage[TILE_TYPES];
  
  static final int GRID_UNIT_SIZE = 45; // size, in pixels, of each world unit square

  static final int GRID_UNITS_WIDE = 28;
  static final int GRID_UNITS_TALL = 16;

  int[][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE]; // the game checks this one during play
  
  // the game copies this into worldGrid each reset, returning keys that have since been cleared
  int[][] start_Grid = { {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                         {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 5, 1, 0, 1},
                         {1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1},
                         {1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 3, 1, 0, 1},
                         {1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1},
                         {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1},
                         {1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 3, 1, 1, 1, 3, 1, 1, 1},
                         {1, 1, 0, 0, 1, 1, 2, 2, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
                         {1, 1, 1, 3, 0, 3, 2, 2, 1, 4, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1},
                         {1, 1, 1, 1, 1, 1, 2, 2, 1, 0, 4, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
                         {1, 0, 0, 2, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 3, 1, 1, 0, 0, 0, 1},
                         {1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 3, 1, 0, 0, 0, 1, 1, 3, 1, 1},
                         {1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
                         {1, 0, 1, 1, 1, 1, 1, 0, 3, 0, 3, 0, 0, 2, 0, 1, 0, 1, 1, 1, 1, 1, 0, 3, 0, 0, 0, 1},
                         {1, 2, 0, 0, 0, 2, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 2, 1, 0, 1, 0, 0, 0, 1},
                         {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} };
  // try changing numbers in that grid to make the level different! Look for the "static final int TILE_" lines
  // up above in this same file for a key of what each number corresponds to.

  World() { // this gets called when World is created.
  }
  
  public void loadWorldTileArt() {
     worldArt[TILE_EMPTY] = loadImage("ground.png");
     worldArt[TILE_SOLID] = loadImage("wall.png");
     worldArt[TILE_KEY] = loadImage("key.png");
     worldArt[TILE_DOOR] = loadImage("door.png");
     worldArt[TILE_GOALBLOCK] = loadImage("goal.png");
     // note we never see this next one, as immediatley while
     // loading the map grid when we find this we replace it with
     // a TILE_EMPTY and spawn/move the Player class entity there
     worldArt[TILE_START] = loadImage("warrior.png");
  }
  
  int worldSquareAt(PVector thisPosition) {
    float gridSpotX = thisPosition.x/GRID_UNIT_SIZE;
    float gridSpotY = thisPosition.y/GRID_UNIT_SIZE;
  
    // first a boundary check, to avoid looking outside the grid
    // if check goes out of bounds, treat it as a solid tile (wall)
    if(gridSpotX<0) {
      return TILE_SOLID; 
    }
    if(gridSpotX>=GRID_UNITS_WIDE) {
      return TILE_SOLID; 
    }
    if(gridSpotY<0) {
      return TILE_SOLID; 
    }
    if(gridSpotY>=GRID_UNITS_TALL) {
      return TILE_SOLID;
    }
    
    return worldGrid[int(gridSpotY)][int(gridSpotX)];
  }
  
  void setSquareAtToThis(PVector thisPosition, int newTile) {
    int gridSpotX = int(thisPosition.x/GRID_UNIT_SIZE);
    int gridSpotY = int(thisPosition.y/GRID_UNIT_SIZE);
  
    if(gridSpotX<0 || gridSpotX>=GRID_UNITS_WIDE || 
       gridSpotY<0 || gridSpotY>=GRID_UNITS_TALL) {
      return; // can't change grid units outside the grid
    }
    
    worldGrid[gridSpotY][gridSpotX] = newTile;
  }
  
  // these helper functions help us correct for the player moving into a world tile
  float topOfSquare(PVector thisPosition) {
    int thisY = int(thisPosition.y);
    thisY /= GRID_UNIT_SIZE;
    return float(thisY*GRID_UNIT_SIZE);
  }
  float bottomOfSquare(PVector thisPosition) {
    if(thisPosition.y<0) {
      return 0;
    }
    return topOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  float leftOfSquare(PVector thisPosition) {
    int thisX = int(thisPosition.x);
    thisX /= GRID_UNIT_SIZE;
    return float(thisX*GRID_UNIT_SIZE);
  }
  float rightOfSquare(PVector thisPosition) {
    if(thisPosition.x<0) {
      return 0;
    }
    return leftOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }
  
  void reload() {
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_START) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          thePlayer.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          thePlayer.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
  }
  
  void render() { // draw the world
    for(int i=0;i<GRID_UNITS_WIDE;i++) { // for each column
      int tileLeftXHere = i*GRID_UNIT_SIZE;
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) { // for each tile in that column
        int findTileHere = worldGrid[ii][i]; // check which tile type it is
        int tileTopYHere = ii*GRID_UNIT_SIZE;
        
        // draw ground under whatever specific tile type is here
        image(worldArt[ TILE_EMPTY ], tileLeftXHere,tileTopYHere);
        // then if it's not a ground tile, draw the key, door, etc.
        if(findTileHere != TILE_EMPTY) {
          image(worldArt[ findTileHere ], tileLeftXHere,tileTopYHere);
        }        
      }
    }
  }
}
