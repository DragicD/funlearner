// references to sound effect files
AudioSample sndBombBurst, sndBucketCatch, sndBucketLoss,
            sndDropFuse, sndExtraLife;

// font(s)
PFont scoreFont; // corresponding file made by menu: Tools->Create Font...

// static images
PImage backgroundImg, bottomImg;

// set to true when between rounds, use to display message and pause action
Boolean waitingForClickToBegin = true;

// array of all bombs that are currently active
ArrayList bombSet = new ArrayList();

// per level tuned variables
float bombFall;
int bombFreqAdjustment;
int bombDelay = 0;
int AIReverseDelay = 0;
int dropStun = 0;
int roundNum = 0;

// round stats
int bombsThrownThisRound = 0;
int bombsCaughtThisRound = 0;
int bombsCaught = 0;

// toggling true activates the bomb explosion and screen flash events
Boolean deathSequence = false;
int deathSequenceDelay;

int score;
int scoreGivenLivesFor;
Boolean roundHandicap = false;

