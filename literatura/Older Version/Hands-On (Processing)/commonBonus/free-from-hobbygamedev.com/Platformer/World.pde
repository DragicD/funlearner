/* Example Code for Platformer
 * By Chris DeLeon
 * 
 * For more free resources about hobby videogame development, check out:
 * http://www.hobbygamedev.com/
 * 
 * Project compiles in Processing - see Processing.org for more information!
 */

class World {
  int coinsInStage; // when we load a level, we count how many coins are in the level
  int coinRotateTimer; // number cycles, and is used to give coins a simple spinning effect

  static final int TILE_EMPTY = 0;
  static final int TILE_SOLID = 1;
  static final int TILE_COIN = 2;
  static final int TILE_KILLBLOCK = 3;
  static final int TILE_START = 4; // the player starts where this is placed
  
  static final int GRID_UNIT_SIZE = 60; // size, in pixels, of each world unit square
  // if the above number becomes too small, how the player's wall bumping is detected may need to be updated

  // these next 2 numbers need to match the dimensions of the example level grid below
  static final int GRID_UNITS_WIDE = 28;
  static final int GRID_UNITS_TALL = 8;

  int[][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE]; // the game checks this one during play
  
  // the game copies this into worldGrid each reset, returning coins that have since been cleared
  int[][] start_Grid = { {2, 0, 2, 0, 0, 0, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0},
                         {0, 2, 0, 0, 0, 0, 2, 2, 1, 4, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 0},
                         {2, 0, 2, 0, 4, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0},
                         {0, 0, 0, 2, 1, 2, 0, 0, 2, 2, 2, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2, 3, 1, 0},
                         {1, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 2, 0, 1, 3},
                         {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 3, 1, 0, 0, 0, 2, 0, 1, 3},
                         {3, 2, 0, 0, 1, 3, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 3},
                         {3, 2, 0, 1, 1, 3, 1, 3, 3, 3, 1, 3, 2, 1, 3, 1, 3, 2, 0, 0, 0, 0, 1, 2, 1, 2, 1, 3} };
  // try changing numbers in that grid to make the level different! Look for the "static final int TILE_" lines
  // up above in this same file for a key of what each number corresponds to.

  World() { // this gets called when World is created.
    coinRotateTimer = 0; // initializing coinRotateTimer to a reasonable start value.
  }
  
  // returns what type of tile is at a given pixel coordinate
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
  
  // changes the tile at a given pixel coordinate to be a new tile type
  // currently used to replace TILE_COIN tiles with TILE_EMPTY tiles once collected
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
    coinsInStage = 0; // we count them while copying in level data
    
    for(int i=0;i<GRID_UNITS_WIDE;i++) {
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) {
        if(start_Grid[ii][i] == TILE_START) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot
  
          // then update the player spot to the center of that tile
          thePlayer.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          thePlayer.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else {
          if(start_Grid[ii][i]==TILE_COIN) {
            coinsInStage++;
          }
          worldGrid[ii][i] = start_Grid[ii][i];
        }
      }
    }
  }
  
  void render() { // draw the world
    
    // these next few lines cycle a number we use to make it look like coins are spinning
    coinRotateTimer--;
    if(coinRotateTimer<-GRID_UNIT_SIZE/3) {
      coinRotateTimer = GRID_UNIT_SIZE/3;
    }
    
    for(int i=0;i<GRID_UNITS_WIDE;i++) { // for each column
      for(int ii=0;ii<GRID_UNITS_TALL;ii++) { // for each tile in that column
        switch(worldGrid[ii][i]) { // check which tile type it is
          case TILE_SOLID:
            stroke(40); // faint dark outline. set to 0 (black) to remove entirely.
            fill(0); // black
            break;
          case TILE_KILLBLOCK:
            stroke(255,0,0); // red outline, blends in with the red fill
            fill(255,0,0); // black
            break;
          default:
            stroke(245); // faint light outline. set to 255 (white) to remove entirely.
            fill(255); // white
            break;
        }
        // then draw a rectangle
        rect(i*GRID_UNIT_SIZE,ii*GRID_UNIT_SIZE, // x,y of top left corner to draw rectangle
             GRID_UNIT_SIZE-1,GRID_UNIT_SIZE-1); // width, height of rectangle
        
        if(worldGrid[ii][i]==TILE_COIN) { // if it's a coin, draw the coin
          stroke(0); // black outline
          // when we give 3 arguments, it's RGB instead of brightness
          fill(255,255,0); // yellow
          ellipse(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2),ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), // center of grid spot
                  abs(coinRotateTimer),GRID_UNIT_SIZE/2); // spin size wide, 1/2 height of box tall
        }
      }
    }
  }
}
