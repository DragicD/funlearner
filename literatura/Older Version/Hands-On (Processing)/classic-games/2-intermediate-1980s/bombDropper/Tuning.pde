// player tuning 
final int EXTRA_LIVES_POINTS = 1000; // at multiples, an extra paddle is earned
final int PADDLE_SPACING = 35;
final int MAX_SCORE = 999999;

// levels stop getting harder and stay the same after this one:
final int LEVEL_DIFFICULTY_CAP = 7; // the 8th level (first level is 0)

// bomb tuning
final float BOMB_FALLSPEED_BASE = 2.0;
final int BOMB_DROPFREQ_MIN = 40;
final int BOMB_DROPFREQ_MAX = 60;
final int DEATH_SEQUENCE_DELAY = 2; // pause per explosion frame during death sequence
final float CHANGE_PER_LEVEL_SPEED_BOMB = 1.0;
final int CHANGE_PER_LEVEL_FREQ_BOMB = 24;
final int BOMB_DROPFREQ_CAP = 9;
final float ODD_LEVEL_BOMB_FREQ_MULT = 0.7;

// badguy/"evil" tuning
final float EVIL_SPEED_X_CAP = 16.0;
final float EVIL_SPEED_X_BASE = 2.5;
final int EVIL_CHANGEDIR_FREQ_MIN = 25;
final int EVIL_CHANGEDIR_FREQ_MAX = 150;
final int EVIL_DROP_STUN_TIME = 3; // how long evil stalls to drop an attack
final float EVIL_CHANGE_PER_LEVEL_SPEED = 2.0;

// function here will enforce the level tuning cap before calling helper
// functions in the Bomb and Evil files to update their respective tuning
void updateDifficultyTuning() {
  int roundNumForCalc = roundNum;
  
  if(roundNumForCalc >= LEVEL_DIFFICULTY_CAP) {
    roundNumForCalc = LEVEL_DIFFICULTY_CAP;
  }

  evilLevelTuning(roundNumForCalc);
  bombLevelTuning(roundNumForCalc);
}

// how man bombs will be dropped on any given round
int bombsPerThisRound() {
  int bombsInLevel; // how many to drop before winning this level
  if(roundNum < 5) {
      bombsInLevel = (roundNum+1)*10;
  } else switch(roundNum) {
    case 5:
      bombsInLevel = 75;
      break;
    case 6:
      bombsInLevel = 100;
      break;
    default:
      bombsInLevel = 150; // max amount, 8th level and above
      break;
  }
  if(roundHandicap) {
    bombsInLevel /= 2;
  }
  return bombsInLevel;
}

// how many points a bomb is worth (currently a function of level number)
int pointsPerBombThisRound() {
  return (roundNum+1);
}
