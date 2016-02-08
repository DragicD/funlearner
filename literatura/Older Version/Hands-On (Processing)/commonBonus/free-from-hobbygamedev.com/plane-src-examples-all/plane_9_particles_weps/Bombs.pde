
class Bomb {
  PImage myImg;
  PVector pos,v;
  int type;
  Boolean isAlive;
  
  static final int TYPE_BOMB = 0;
  static final int TYPE_MISSILE = 1;
  static final int TYPE_BOMBLET = 2;
  static final int TYPE_CANNON = 3;
  static final int TYPE_CLUSTER = 4;
  static final int TYPE_NAPALM = 5;

  static final float CLUSTER_SAFE_DIST = 42;
  static final float CLUSTER_HEIGHT = 140;
  
  void commonInit(PImage useImg) {
    isAlive = true;
    pos = new PVector(pl.pos.x, pl.pos.y);
    myImg = useImg;

    if(myImg==bombImg) {
      type = TYPE_BOMB;
    } else if(myImg==bombletImg) {
      type = TYPE_BOMBLET;
    } else if(myImg==missileImg) {
      type = TYPE_MISSILE;
    } else if(myImg==clusterImg) {
      type = TYPE_CLUSTER;
    } else if(myImg==napalmImg) {
      type = TYPE_NAPALM;
    } else {
      type = TYPE_CANNON;
    }
    
    switch(type) {
      case TYPE_BOMBLET:
        v = new PVector(0.0,0.0); // gets updated afterward in special bomblet constructor
        break;
      case TYPE_BOMB:
      case TYPE_CLUSTER:
      case TYPE_NAPALM:
        v = new PVector(pl.v.x,pl.v.y);
        break;
      case TYPE_MISSILE:
        v = new PVector(cos(pl.ang)*8.4,sin(pl.ang)*8.4);
        v.add(v);
        break;
      case TYPE_CANNON:
        v = new PVector(cos(pl.ang)*8.4,sin(pl.ang)*8.4);
        v.mult(random(1.2,2.8));
        pos.add(v);
        pos.add(v);
        pos.add(v);
        break;
    }
  }
  Bomb(PImage useImg) {
    commonInit(useImg);
  }
  
  Bomb(PImage useImg,Bomb fromBomb) { // for bomblets
    commonInit(useImg);
    pos.x = fromBomb.pos.x;
    pos.y = fromBomb.pos.y;
    v.x = fromBomb.v.x+random(-7,7);
    v.y = random(-0.7,2.1);
  }
  
  void handle() {
    int h=0,bx=int(pos.x);
    
    if(bx<0 || bx>=WORLD_SIZE) {
      isAlive = false;
      return;
    }
    
    h = heightAt(bx);
    
    switch(type) {
      case TYPE_BOMB:
        if(v.mag()<4.2 || v.y<0) {
          v.y += 1.0;
        } else {
          v.x *= 0.6;
        }
        break;
      case TYPE_BOMBLET:
      case TYPE_CLUSTER:
        if(v.mag()<12.6 || v.y<0) {
          v.y += 1.0;
        } else {
          v.x *= 0.9;
        }
        break;
      case TYPE_NAPALM:
        v.y += 0.56;
        break;
      case TYPE_MISSILE:
        pfx.spawn(pos.x, pos.y,Particles.TYPE_TRAIL, 1);
        if(v.mag()<14.0) {
          v.add(v);
        }
        break;
      case TYPE_CANNON:
        pfx.spawn(pos.x, pos.y,Particles.TYPE_CANNON_TRAIL, 1);
        break;
    }
    
    pos.add(v);
    int alphaTrap;
        
    if(type==TYPE_MISSILE) {
      PVector lookAhead = new PVector(pos.x,pos.y);
      lookAhead.add(v);
      lookAhead.add(v);
      for (int i = enemyList.size()-1; i >= 0; i--) { 
        Enemy enemy = (Enemy) enemyList.get(i);
        if(enemy.pos.dist(lookAhead)<84) {
          float speed = v.mag();
          PVector diff = new PVector(enemy.pos.x,enemy.pos.y);
          diff.sub(pos);
          diff.normalize();
          diff.mult(speed);
          v.x = v.x*0.75+0.25*diff.x;
          v.y = v.y*0.75+0.25*diff.y;
        }
      }
    }
    
    if(pos.x < 0 || pos.x >= WORLD_SIZE ||
       pos.y < cameraOffsetY) {
      isAlive = false;
    } else if (type==TYPE_CLUSTER && pos.y >= h-CLUSTER_HEIGHT && pos.y >= pl.pos.y+CLUSTER_SAFE_DIST) {
      isAlive = false;
      pfx.spawn(pos.x, pos.y,Particles.TYPE_LIGHT, 2);
      for(int i=0;i<8;i++) {
        bombList.add(new Bomb(bombletImg,this));
      }
    } else if(pos.y>h) {
      pos.y=h;
      isAlive = false;
      switch(type) {
        case TYPE_BOMB:
        case TYPE_CLUSTER:
          pfx.spawn(pos.x, pos.y,Particles.TYPE_GLOW, 6);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_SMOKE, 1);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_DEBRIS, 4);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_LIGHT, 4);
          for(int i=0;i<5;i++) {
            pfx.spawn(pos.x+random(-35,35), pos.y+random(-19,3.5),Particles.TYPE_GLOW, 4);
            pfx.spawn(pos.x+random(-21,21), pos.y+random(-17,3.5),Particles.TYPE_SMOKE, 4);
            pfx.spawn(pos.x+random(-25,25), pos.y+random(-10,3.5),Particles.TYPE_DEBRIS, 3);
            pfx.spawn(pos.x+random(-12,12), pos.y+random(-14,3.5),Particles.TYPE_LIGHT, 3);
            shredHole(pos.x+random(-10,10),pos.y+random(-3.5,10),140,3000);
          }
          shredHole(pos.x,pos.y,140,3000);
          shakeAmt+=3.0;
          break;
        case TYPE_MISSILE:
          pfx.spawn(pos.x, pos.y,Particles.TYPE_GLOW, 3);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_SMOKE, 4);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_DEBRIS, 6);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_LIGHT, 2);
          shredHole(pos.x,pos.y,70,1400);
          shakeAmt+=1.5;
          break;
        case TYPE_BOMBLET:
          pfx.spawn(pos.x, pos.y,Particles.TYPE_GLOW, 2);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_SMOKE, 3);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_DEBRIS, 3);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_LIGHT, 0);
          shredHole(pos.x,pos.y,35,700);
          shakeAmt+=1.0;
          break;
        case TYPE_CANNON:
          pfx.spawn(pos.x, pos.y,Particles.TYPE_GLOW, 1);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_SMOKE, 1);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_LIGHT, 0);
          shredHole(pos.x,pos.y,31,40);
          shakeAmt+=0.5;
          break;
        case TYPE_NAPALM:
          pfx.spawn(pos.x, pos.y,Particles.TYPE_FIRE, 40);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_GLOW, 3);
          pfx.spawn(pos.x, pos.y,Particles.TYPE_SMOKE, 3);
          for(int i=0;i<8;i++) {
            pfx.spawn(pos.x+random(-28,28), pos.y+random(-10,3.5),Particles.TYPE_FIRE, 20);
            pfx.spawn(pos.x+random(-35,35), pos.y+random(-10,3.5),Particles.TYPE_GLOW, 1);
            pfx.spawn(pos.x+random(-21,21), pos.y+random(-17,3.5),Particles.TYPE_SMOKE, 1);
          }
          shakeAmt+=2.0;
          break;
      }
    } else if(type!=TYPE_CANNON) {
      pushMatrix();
      translate(pos.x,pos.y);
      float mang;
      if(type!=TYPE_NAPALM) {
        mang = atan2(v.y,v.x);
      } else {
        mang = pos.x/(8*PI);
      }
      rotate(mang);
      image(myImg,-myImg.width*0.5,-myImg.height*0.5);
      popMatrix();      
    }
  }
  
  Boolean finished() {
    return (isAlive==false);
  }
}
