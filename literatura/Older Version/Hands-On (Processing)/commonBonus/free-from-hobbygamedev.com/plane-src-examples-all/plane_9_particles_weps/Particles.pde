class Particles {
  static final int TYPE_GLOW = 0;
  static final int TYPE_SMOKE = 1;
  static final int TYPE_DEBRIS = 2;
  static final int TYPE_LIGHT = 3;
  static final int TYPE_TRAIL = 4;
  static final int TYPE_CANNON_TRAIL = 5;
  final int P_TYPES = 6;
  static final int TYPE_FIRE = 6; // no bitmap used
  
  PImage[] pImg = new PImage[P_TYPES];
    
  final int P_MAX = 640;
  int pNum;
  int[] type = new int[P_MAX];
  int[] life = new int[P_MAX];
  int[] maxLife = new int[P_MAX];
  float[] x = new float[P_MAX];
  float[] y = new float[P_MAX];
  float[] xv = new float[P_MAX];
  float[] yv = new float[P_MAX];
  float[] ang = new float[P_MAX];
  float[] sc = new float[P_MAX];
  
  Particles() {
    pNum = 0;    
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
          maxLife[pNum]=5+int(random(-2,1));
          xv[pNum]=random(-8.4,8.4);
          yv[pNum]=random(-8.4,3.5);
          break;
        case TYPE_SMOKE:
          maxLife[pNum]=35+int(random(-10,5));
          xv[pNum]=random(-2,2);
          yv[pNum]=random(-1,0);
          break;
        case TYPE_DEBRIS:
          maxLife[pNum]=60;
          xv[pNum]=random(-5.5,5.5);
          yv[pNum]=random(-10,1.4);
          break;
        case TYPE_LIGHT:
          maxLife[pNum]=3+lightHack+int(random(-2,1));
          xv[pNum]=0.0;
          yv[pNum]=0.0;
          break;
        case TYPE_TRAIL:
          maxLife[pNum]=8+int(random(-1,1));
          xv[pNum]=random(-0.21,0.21);
          yv[pNum]=random(-0.21,0.21);
          break;
        case TYPE_CANNON_TRAIL:
          maxLife[pNum]=3+int(random(-1,1));
          xv[pNum]=random(-0.21,0.21);
          yv[pNum]=random(-0.21,0.21);
          break;
        case TYPE_FIRE:
          maxLife[pNum]=150+int(random(-30,30));
          atX+=random(-11,11);
          if(random(1)<0.6) {
            continue;
          }
          xv[pNum]=0.0;
          yv[pNum]=8.0;
          break;
      }
      life[pNum]=maxLife[pNum];
      type[pNum]=ntype;
      x[pNum]=atX;
      y[pNum]=atY;
      ang[pNum]=atan2(xv[pNum],yv[pNum]);
      sc[pNum]=1.0;
  
      pNum++;
    }
  }
  
  void removeAll() {
    pNum=0;
  }
  void handle(Boolean doingLights) {
    float fadeJunk=1.0;
    for(int i=0;i<pNum;i++) {
      
      if((doingLights && type[i]!=TYPE_LIGHT) ||
         (doingLights==false && type[i]==TYPE_LIGHT)) {
        continue;
      }
      
      life[i]--;
      
      if(x[i]<0 || x[i]>WORLD_SIZE) {
        life[i]=0;
      } else if(type[i]==TYPE_FIRE && y[i]>landOffY) {
        int landHeight = land.pixels.length/WORLD_SIZE;
        
        y[i] = heightAt(int(x[i]));
      }
      
      if(life[i]<=0) {
        pNum--;
        if(pNum>=0) {
          type[i]=type[pNum];
          maxLife[i]=maxLife[pNum];
          life[i]=life[pNum];
          x[i]=x[pNum];
          y[i]=y[pNum];
          xv[i]=xv[pNum];
          yv[i]=yv[pNum];
          ang[i]=ang[pNum];
          sc[i]=sc[pNum];
          i--;
        }
        continue;
      }
      
      switch(type[i]) {
        case TYPE_GLOW:
          ang[i] = random(2*PI);
          fadeJunk = float(life[i])/float(maxLife[i]);
          sc[i] = fadeJunk;
          tint(255,120+(255-120)*fadeJunk,120,255);
          break;
        case TYPE_SMOKE:
          xv[i]*=0.9;
          yv[i]-=0.025;
          ang[i]+=0.03;
          fadeJunk = float(life[i])/float(maxLife[i]);
          sc[i] = (1.0-fadeJunk)*1.15+0.6;
          tint(30,30,30,255*fadeJunk);
          break;
        case TYPE_DEBRIS:
          yv[i]+=0.8;
          ang[i] = atan2(yv[i],xv[i]);
          tint(255,255,255,255);
          break;
        case TYPE_LIGHT:
          ang[i] = random(2*PI);
          fadeJunk = float(life[i])/float(maxLife[i]);
          sc[i] = fadeJunk*2.5*(maxLife[i]/7.5);
          tint(255,60+(255-80)*fadeJunk,80,165);
          break;
        case TYPE_TRAIL:
          yv[i]-=0.03;
          ang[i] = random(2*PI);
          fadeJunk = float(life[i])/float(maxLife[i]);
          sc[i] = (1.0-fadeJunk)*0.75+0.2;
          tint(80,80,80,255*fadeJunk);
          break;
        case TYPE_CANNON_TRAIL:
          yv[i]-=0.03;
          ang[i] = random(2*PI);
          fadeJunk = float(life[i])/float(maxLife[i]);
          sc[i] = (1.0-fadeJunk)*0.25+0.1;
          tint(30,30,30,255*fadeJunk);
          break;
        case TYPE_FIRE:
          fadeJunk = float(life[i])/float(maxLife[i]);
          break;
      }
      
      x[i]+=xv[i];
      y[i]+=yv[i];
            
      pushMatrix();
      translate(x[i],y[i]);
      rotate(ang[i]);
      scale(sc[i]);
      
      if(type[i]!=TYPE_FIRE) {
        image(pImg[type[i]],-pImg[type[i]].width*0.5,-pImg[type[i]].height*0.5);
      } else if(random(1)<0.5) { // only drawing 50% of flames any given frame. Helps framerate, and has nice flicker look.
        if(random(1)<0.2) {
          shredHole(x[i]+random(-5,5),y[i]+random(-5,2),7,0); // kill nearby, no terrain damage
        }
        if(random(1)<0.5) {
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
