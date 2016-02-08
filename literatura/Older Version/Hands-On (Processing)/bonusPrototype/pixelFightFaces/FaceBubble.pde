PImage face2 = new PImage();

ArrayList confFace = new ArrayList();

void loadFaces() {
  PImage tempImg;

  confFace = new ArrayList();
  tempImg = loadImage("worried.png");
  confFace.add(tempImg);
  tempImg = loadImage("normal.png");
  confFace.add(tempImg);
  tempImg = loadImage("evil.png");
  confFace.add(tempImg);
}

int redFaceCycle;
int blueFaceCycle;
final int FACE_COUNT = 4;

class FaceBubble {
  float x,y;
  
  float wanderX,wanderY;
  int wanderRethink;
  int myConf = 0;
  
  int teamType;
  Boolean removeMe;
  float oscTilt;
  
  FaceBubble(float atX, float atY, int idx) {
    x = atX;
    y = atY;
    if(teamType==TYPE_RED) {
      redFaceCycle++;
    } else {
      blueFaceCycle++;
    }
    myConf = 2;

    teamType = idx;
    removeMe = false;
  }
  
  void drawMe() {
    PImage useFace;
    
    pushMatrix();
    translate(x,y);
    float ang = sin(oscTilt) * 0.4f;
    rotate(ang);
    useFace = (PImage)confFace.get(myConf);
    oscTilt += 0.03f+0.04f*(myConf);
    scale(0.85f);
    translate(-(useFace.width>>1),-(useFace.height>>1));
    image(useFace,0,0);
    popMatrix();
    
    int typeAt;
    int matchScore = 0;
    int leftScore = 0;
    int rightScore = 0;
    int upScore = 0;
    int downScore = 0;
    for(int inc=8;inc < (useFace.width>>1); inc += 5) {
      typeAt = safeGetPixelAt(x-inc,y);
      if(typeAt == teamType) {
        matchScore++;
        leftScore++;
      }
      typeAt = safeGetPixelAt(x-inc,y-inc);
      if(typeAt == teamType) {
        matchScore++;
        leftScore++;
        upScore++;
      }
      typeAt = safeGetPixelAt(x-inc,y+inc);
      if(typeAt == teamType) {
        matchScore++;
        leftScore++;
        downScore++;
      }
      typeAt = safeGetPixelAt(x+inc,y);
      if(typeAt == teamType) {
        matchScore++;
        rightScore++;
      }
      typeAt = safeGetPixelAt(x+inc,y-inc);
      if(typeAt == teamType) {
        matchScore++;
        rightScore++;
        upScore++;
      }
      typeAt = safeGetPixelAt(x+inc,y+inc);
      if(typeAt == teamType) {
        matchScore++;
        rightScore++;
        downScore++;
      }
      typeAt = safeGetPixelAt(x,y-inc);
      if(typeAt == teamType) {
        matchScore++;
        upScore++;
      }
      typeAt = safeGetPixelAt(x,y+inc);
      if(typeAt == teamType) {
        matchScore++;
        downScore++;
      }
    }
    
    typeAt = safeGetPixelAt(x,y);
    if(typeAt == teamType) {
      matchScore++;
    }
    
    final int PUSH_CAP = 13;
    boolean forced = false;
    if(leftScore<PUSH_CAP) {
      wanderRethink--;
      x+=PUSH_CAP-leftScore;
      forced = true;
    }
    if(rightScore<PUSH_CAP) {
      wanderRethink--;
      x-=PUSH_CAP-rightScore;
      forced = true;
    }
    if(upScore<PUSH_CAP) {
      wanderRethink--;
      y+=PUSH_CAP-upScore;
      forced = true;
    }
    if(downScore<PUSH_CAP) {
      wanderRethink--;
      y-=PUSH_CAP-downScore;
      forced = true;
    }
    if(forced == false) {
      // wander
      wanderRethink--;
      if(wanderRethink<0) {
        
        if(random(10) < 6) {
          switch(teamType) {
            case TYPE_RED:
              myConf = rfaceconf;
              break;
            case TYPE_BLUE:
            default:
              myConf = bfaceconf;
              break;
          }
        } else {
          myConf = (int)random(3);
        }
        
        wanderRethink = (int)random(20,45);
        float rang = random(0,2.0f*PI);
        float movespeed = random(2.0f,4.0f);
        movespeed *= (1.0f+((float)myConf)*0.7f);
        wanderX = movespeed*sin(rang);
        wanderY = movespeed*cos(rang);
      }
      x+=wanderX;
      y+=wanderY;
    }

    if(matchScore < 13) {
      removeMe = true;
    }    
  }
}
