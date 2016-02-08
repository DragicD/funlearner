class ParticleSet {
  static final int TYPE_GLOW = 0;
  static final int TYPE_SMOKE = 1;
  static final int TYPE_DEBRIS = 2;
  static final int TYPE_LIGHT = 3;
  static final int TYPE_TRAIL = 4;
  static final int TYPE_CANNON_TRAIL = 5;
  static final int TYPE_CLUMP = 6;
  final int P_TYPES = 7;
  static final int TYPE_FIRE = 7; // no bitmap used
  
  PImage[] pImg = new PImage[P_TYPES];
    
  final int P_MAX = 640;
  int pNum;
  Particle[] eachParticle = new Particle[P_MAX];
  
  ParticleSet() {
    pNum = 0;  
    for(int i=0;i<P_MAX;i++) {
      eachParticle[i] = new Particle();
    }
  }
  void setImg(int num, PImage thisImg) {
    pImg[num] = thisImg;
  }
  void spawn(float atX, float atY,int ntype, int num) {
    int lightHack=0;

    if(ntype==TYPE_LIGHT) {
      lightHack = num;
      num=1;
    }
    for(int i=0;i<num;i++) {
      if(pNum>=P_MAX) {
        return;
      }
      switch(ntype) {
        case TYPE_GLOW:
          eachParticle[pNum].maxLife=5+int(random(-2,1));
          eachParticle[pNum].xv=random(-8.4,8.4);
          eachParticle[pNum].yv=random(-8.4,3.5);
          break;
        case TYPE_SMOKE:
          eachParticle[pNum].maxLife=35+int(random(-10,5));
          eachParticle[pNum].xv=random(-2,2);
          eachParticle[pNum].yv=random(-1,0);
          break;
        case TYPE_DEBRIS:
          eachParticle[pNum].maxLife=60;
          eachParticle[pNum].xv=random(-5.5,5.5);
          eachParticle[pNum].yv=random(-10,1.4);
          break;
        case TYPE_LIGHT:
          eachParticle[pNum].maxLife=3+lightHack+int(random(-2,1));
          eachParticle[pNum].xv=0.0;
          eachParticle[pNum].yv=0.0;
          break;
        case TYPE_TRAIL:
          eachParticle[pNum].maxLife=8+int(random(-1,1));
          eachParticle[pNum].xv=random(-0.21,0.21);
          eachParticle[pNum].yv=random(-0.21,0.21);
          break;
        case TYPE_CANNON_TRAIL:
          eachParticle[pNum].maxLife=3+int(random(-1,1));
          eachParticle[pNum].xv=random(-0.21,0.21);
          eachParticle[pNum].yv=random(-0.21,0.21);
          break;
        case TYPE_FIRE:
          eachParticle[pNum].maxLife=150+int(random(-30,30));
          atX+=random(-11,11);
          if(random(1)<0.6) {
            continue;
          }
          eachParticle[pNum].xv=0.0;
          eachParticle[pNum].yv=8.0;
          break;
      }
      eachParticle[pNum].life=eachParticle[pNum].maxLife;
      eachParticle[pNum].type=ntype;
      eachParticle[pNum].x=atX;
      eachParticle[pNum].y=atY;
      eachParticle[pNum].ang=atan2(eachParticle[pNum].xv,eachParticle[pNum].yv);
      eachParticle[pNum].sc=1.0;
  
      pNum++;
    }
  }
  
  void spawnClump(float atX, float atY,int num,int rval, int gval, int bval) {
    for(int i=0;i<num;i++) {
      if(pNum>=P_MAX) {
        return;
      }
      eachParticle[pNum].xv=random(-2.1,2.1);
      eachParticle[pNum].yv=random(-4.2,-1.4);

      eachParticle[pNum].type=TYPE_CLUMP;
      eachParticle[pNum].x=atX+random(-1.75,1.75);
      eachParticle[pNum].y=atY+random(-5.6,-2.8);

      eachParticle[pNum].life=10000;

      // for land clump, treating these as red, green, and blue
      // which we'll then use to tint the pixel's color
      eachParticle[pNum].maxLife=int(rval*0.8);
      eachParticle[pNum].ang=int(gval*0.8);
      eachParticle[pNum].sc=int(bval*0.8);
  
      pNum++;
    }
  }
  void reduceFire() {
    for(int i=0;i<pNum;i++) {
      if(eachParticle[i].type==TYPE_FIRE) {
        if(random(1.0)<0.5) {
          eachParticle[i].life=eachParticle[i].life>>1;
        } else {
          eachParticle[i].life=eachParticle[i].life>>2;
        }
      }
    }
  }
  void removeAll() {
    pNum=0;
  }
  void handle(Boolean doingLights) {
    float fadeJunk=1.0;
    for(int i=0;i<pNum;i++) {
      
      if((doingLights && eachParticle[i].type!=TYPE_LIGHT) ||
         (doingLights==false && eachParticle[i].type==TYPE_LIGHT)) {
        continue;
      }
      
      eachParticle[i].life--;
      
      if(eachParticle[i].x<0 || eachParticle[i].x>WORLD_SIZE) {
        eachParticle[i].life=0;
      } else if((eachParticle[i].type==TYPE_CLUMP || eachParticle[i].type==TYPE_FIRE) && eachParticle[i].y>landOffY) {
        int landHeight = land.pixels.length/WORLD_SIZE;
        int h = heightAt(int(eachParticle[i].x));
        
        if(eachParticle[i].type==TYPE_CLUMP) {
          if(eachParticle[i].y>=landOffY+landHeight-1 || (eachParticle[i].y>=h && alpha(land.pixels[int(eachParticle[i].x)+int((eachParticle[i].y-landOffY)*WORLD_SIZE)])>=127.0)) {          
            drawSquare(int(eachParticle[i].x),h-1,3,eachParticle[i].maxLife,int(eachParticle[i].ang),int(eachParticle[i].sc));
            eachParticle[i].life=0;
          }
        } else {          
            eachParticle[i].y = h;
        }
      }
      
      if(eachParticle[i].life<=0) {
        pNum--;
        if(pNum>=0) {
          eachParticle[i].type=eachParticle[pNum].type;
          eachParticle[i].maxLife=eachParticle[pNum].maxLife;
          eachParticle[i].life=eachParticle[pNum].life;
          eachParticle[i].x=eachParticle[pNum].x;
          eachParticle[i].y=eachParticle[pNum].y;
          eachParticle[i].xv=eachParticle[pNum].xv;
          eachParticle[i].yv=eachParticle[pNum].yv;
          eachParticle[i].ang=eachParticle[pNum].ang;
          eachParticle[i].sc=eachParticle[pNum].sc;
          i--;
        }
        continue;
      }
      
      switch(eachParticle[i].type) {
        case TYPE_GLOW:
          eachParticle[i].ang = random(2*PI);
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          eachParticle[i].sc = fadeJunk;
          tint(255,120+(255-120)*fadeJunk,120,255);
          break;
        case TYPE_SMOKE:
          eachParticle[i].xv*=0.9;
          eachParticle[i].yv-=0.025;
          eachParticle[i].ang+=0.03;
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          eachParticle[i].sc = (1.0-fadeJunk)*1.15+0.6;
          tint(30,30,30,255*fadeJunk);
          break;
        case TYPE_DEBRIS:
          eachParticle[i].yv+=0.8;
          eachParticle[i].ang = atan2(eachParticle[i].yv,eachParticle[i].xv);
          tint(255,255,255,255);
          break;
        case TYPE_LIGHT:
          eachParticle[i].ang = random(2*PI);
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          eachParticle[i].sc = fadeJunk*2.5*(eachParticle[i].maxLife/7.5);
          tint(255,60+(255-80)*fadeJunk,80,165);
          break;
        case TYPE_TRAIL:
          eachParticle[i].yv-=0.03;
          eachParticle[i].ang = random(2*PI);
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          eachParticle[i].sc = (1.0-fadeJunk)*0.75+0.2;
          tint(80,80,80,255*fadeJunk);
          break;
        case TYPE_CLUMP:
          eachParticle[i].yv+=0.8;
          tint(eachParticle[i].maxLife,eachParticle[i].ang,eachParticle[i].sc,255);
          break;
        case TYPE_CANNON_TRAIL:
          eachParticle[i].yv-=0.03;
          eachParticle[i].ang = random(2*PI);
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          eachParticle[i].sc = (1.0-fadeJunk)*0.25+0.1;
          tint(30,30,30,255*fadeJunk);
          break;
        case TYPE_FIRE:
          fadeJunk = float(eachParticle[i].life)/float(eachParticle[i].maxLife);
          break;
      }
      
      eachParticle[i].x+=eachParticle[i].xv;
      eachParticle[i].y+=eachParticle[i].yv;
            
      pushMatrix();
      translate(eachParticle[i].x,eachParticle[i].y);
      if(eachParticle[i].type!=TYPE_CLUMP) {
        rotate(eachParticle[i].ang);
        scale(eachParticle[i].sc);
      } else {
        rotate(atan2(eachParticle[i].yv,eachParticle[i].xv));
      }
      if(eachParticle[i].type!=TYPE_FIRE) {
        image(pImg[eachParticle[i].type],-pImg[eachParticle[i].type].width*0.5,-pImg[eachParticle[i].type].height*0.5);
      } else if(random(1.0)<0.5) { // only drawing 50% of flames any given frame. Helps framerate, and has nice flicker look.
        if(random(1.0)<0.2) {
          shredHole(eachParticle[i].x+random(-5,5),eachParticle[i].y+random(-5,2),7,0); // kill nearby, no terrain damage
        }
        if(random(1.0)<0.5) {
          stroke(255,0,0,160);
        } else {
          stroke(255,130,0,160);
        }
        fadeJunk = (fadeJunk+1.0)*0.5;
        line(random(-8,8),random(-25,-16)*fadeJunk,random(-4,4),random(2,3));
      }
      popMatrix();
    }
    tint(255,255,255,255);
  }
}
