class ScoreAndProgress {
  private final int WAIT_CYCLES_FOR_NEXT_LEVEL = 200;
  private final int WAIT_CYCLES_FOR_GAME_OVER = 300;
  private final int DECOR_BOX_SIZE = 40;

  private int livesLeft;
  private int scoreNow;
  private int onLevel;
  private int highScore;

  private int advanceLevelCycles;
  private int resetGameCycles;
  
  private boolean savedScore=false;

  public void reset() {
    livesLeft = PLAYER_START_LIVES;
    scoreNow = 0;
    onLevel = 1;
    savedScore = false;
    advanceLevelCycles = 0;
    resetGameCycles = 0;
  }
  
  void clearSavedHighScore() {
    highScore = 0;
    saveCurrentHighScore();
  }
  
  void saveCurrentHighScore() {
    String[] justTheHighScore = { ""+highScore };
    saveStrings("highScore.txt", justTheHighScore);
  }
  
  void loadSavedHighScore() {
    String[] getPreviousHighScore = loadStrings("highScore.txt");
    highScore = int(getPreviousHighScore[0]);
  }

  int titleLightCycle = 255;

  void showTitleScreen() {
    background(0);
    stroke(0); // otherwise on return box borders show residue from in-game stroke use

    int i, blockIntensity;

    titleLightCycle+=4;

    for (i=0; i<height; i+=DECOR_BOX_SIZE) {
      blockIntensity = (titleLightCycle-i/2)%255;
      fill( 0, blockIntensity, 0 );
      // left row:
      rect(0, height-i-DECOR_BOX_SIZE, DECOR_BOX_SIZE, DECOR_BOX_SIZE);  

      fill( 0, blockIntensity, blockIntensity );
      // right row:
      rect(width-DECOR_BOX_SIZE, i, DECOR_BOX_SIZE, DECOR_BOX_SIZE);
    }

    for (i=0; i<width; i += DECOR_BOX_SIZE) {
      blockIntensity = (titleLightCycle-i/2)%255;
      fill( blockIntensity, 0, 0 );
      // top row:
      rect(i, 0, DECOR_BOX_SIZE, DECOR_BOX_SIZE);  

      fill( blockIntensity, blockIntensity, 0 );
      // bottom row:
      rect(width-i-DECOR_BOX_SIZE, height-DECOR_BOX_SIZE, 
      DECOR_BOX_SIZE, DECOR_BOX_SIZE);
    }

    textAlign(CENTER);

    fill(255, 255, 0);
    text("WELCOME TO SPACE BATTLE!!", width/2, height/2-80);

    fill(255, 255, 255);

    if (highScore > 0) {
      if(savedScore == false) {
        saveCurrentHighScore();
        savedScore = true;
      }
      text("High Score: "+ highScore, width/2, height-10-DECOR_BOX_SIZE);
    }

    textAlign(LEFT);
    text("\n\nARROW KEYS: TURN AND THRUST\nSPACEBAR: SHOOT\n\n"+
      "DEFEAT ALL UFOS TO ADVANCE\n\nPRESS SPACE TO BEGIN!\n"+
      (highScore > 0 ? "(OR PRESS R TO RESET HIGH SCORE)" : ""),
      width/2-100, height/2-60);
  }

  public void incrementScore(int byAmt) {
    scoreNow += byAmt;

    // classic example of why scoreNow should be private and accessed only by this
    // increment function: to ensure that every time it's changed, we compare it
    // against highScore to see whether to update highScore. Otherwise we'd need
    // to do it every frame (wasteful) or remember to do it every place we increment
    // the score for defeating an enemy, getting a level completion bonus, etc.
    if (highScore < scoreNow) {
      highScore = scoreNow;
    }
  }

  public void handleStateChangeTimers() {
    if (resetGameCycles > 0) {
      resetGameCycles--;
      if (resetGameCycles == 0) {
        onTitleScreen = true;
      }
    } 
    else if ( isOutOfLives() ) {
      resetGameCycles = WAIT_CYCLES_FOR_GAME_OVER;
    }
    else if (advanceLevelCycles > 0) { // don't consider level update if game over
      advanceLevelCycles--;
      if (advanceLevelCycles == 0) {
        incrementLevel();
        resetShipPositions();
      }
    } 
    else if (enemyList.size() == 0) {
      advanceLevelCycles = WAIT_CYCLES_FOR_NEXT_LEVEL;
    }
  }

  public boolean isOutOfLives() {
    return (livesLeft < 0);
  }

  public int level() {
    return onLevel;
  }

  private int levelBonusAmt() {
    return 500*onLevel;
  }

  public void incrementLevel() {
    incrementScore( levelBonusAmt() ); // level completion bonus
    onLevel++;
  }

  public void loseLife() {
    p1.resetRandomStartPosition(); // random position, so won't lose many lives at once
    livesLeft--;
  }

  void display()
  {
    fill(255, 255, 255); // force text color to white for UI
    textAlign(LEFT);
    text("Lives: "+(livesLeft >= 0 ? livesLeft : "0"), width/10, 15); // don't show -1

    textAlign(CENTER);
    text("Score: "+scoreNow, width/2, 15);
    boolean highScoreHolder = (highScore == scoreNow && scoreNow > 0);
    if (highScoreHolder) {
      fill(255, 255, 0); // special color for high score font
    }
    text("High Score: "+ highScore + (highScoreHolder ? " (YOU!)" : ""), width/2, height-5);
    if (highScoreHolder) {
      fill(255, 255, 255); // restore font color back to white
    }

    if (resetGameCycles > 0) {
      text("GAME OVER\nYOUR SCORE: " + scoreNow + "\nRESTARTING...", width/2, height/2);
    } 
    else if (advanceLevelCycles > 0) {
      text("LEVEL "+onLevel+" COMPLETE!!\nBONUS POINTS: "+levelBonusAmt(), width/2, height/2);
    }

    textAlign(RIGHT);
    text("Level: "+onLevel, width*9/10, 15);
  }
}

