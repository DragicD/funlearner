class Plane {
  PVector pos,v;
  float ang;
  float alt;
  int engineSndDelay;
  int reloadSndDelay;
  Boolean isAlive;
  
  Boolean usedA;
  Boolean usedS;
  Boolean usedD;
  Boolean usedF;
  
  final int startY = 300;
  final int reloadClickInterval = 4;
  final float minSpeed = 8.0*0.7;
  final float avgSpeed = 12.5*0.7;
  final float maxSpeed = 17.5*0.7;
  
  int ammo_bomb;
  int ammo_missile;
  int ammo_cluster;
  int ammo_fire;
  int ammo_gun;
  
  float speed = avgSpeed;
  
  Plane() {
    pos = new PVector(0, startY);
    v = new PVector(speed,0);
    respawn();
  }
  
  void respawn() {
    engineSndDelay=0;
    reloadSndDelay=0;
    isAlive = true;
    pos.x = 0;
    pos.y = startY;
    speed = avgSpeed;
    v.x = speed;
    v.y = 0;
    usedA = usedS = usedD = false;
    ang = 0;
    cameraOffsetX = 0;
    
    pfx.reduceFire();
    
    ammo_bomb=3;
    ammo_missile=4;
    ammo_cluster=2;
    ammo_fire=2;
    ammo_gun=1174;
  }
  
  void handle() {
    if(isAlive==false) {
      if(holdingSpace) {
        respawn();
        holdingSpace = false; // so that the gun doesn't start firing after respawn
      } else {
        return;
      }
    }
    
    if(pos.x<0 || pos.x>WORLD_SIZE) {
      respawn();
    }

    int h=heightAt(int(pos.x));
    
    alt = h-int(pos.y);
    
    Boolean midAirCollision=false;
    
    for (int i = enemyList.size()-1; i >= 0; i--) { 
      Enemy enemy = (Enemy) enemyList.get(i);
      if(enemy.type==Enemy.TYPE_HELI && enemy.pos.dist(pos)<30) {
        midAirCollision=true;
      }
    }
    
    if(alt<0 || midAirCollision) {
      isAlive=false;
      holdingSpace = false; // so that holding the gun doesn't cause instant respawn
      sndCrash.trigger();

      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_GLOW, 6);
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_SMOKE, 5);
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_DEBRIS, 8);
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_LIGHT, 4);
      if(pos.y>landOffY && pos.y < landOffY+land.height) {            
        int alphaTrap = int(pos.x)+int((pos.y-landOffY)*WORLD_SIZE);
        pfx.spawnClump(pos.x, pos.y,8,
            int(red(land.pixels[alphaTrap])),
            int(green(land.pixels[alphaTrap])),
            int(blue(land.pixels[alphaTrap])));
      }
      for(int i=0;i<5;i++) {
        pfx.spawn(pos.x+random(-50,50), pos.y+random(-15,midAirCollision ? -10 :5),ParticleSet.TYPE_GLOW, 4);
        pfx.spawn(pos.x+random(-30,30), pos.y+random(-25,midAirCollision ? -20 :5),ParticleSet.TYPE_SMOKE, 4);
        pfx.spawn(pos.x+random(-35,35), pos.y+random(-15,midAirCollision ? -20 :5),ParticleSet.TYPE_DEBRIS, 3);
        pfx.spawn(pos.x+random(-17,17), pos.y+random(-20,midAirCollision ? -20 : 5),ParticleSet.TYPE_LIGHT, 3);
        shredHole(pos.x+random(-15,15),pos.y+random(-5,15),140,3000);
      }
      
      sndNapalm.trigger();
      if(midAirCollision) {
        for(int i=0;i<10;i++) {
          pfx.spawn(pos.x+random(-21,21), pos.y+random(0,h-pos.y),ParticleSet.TYPE_SMOKE, 1);
        }            shredHole(pos.x,pos.y,180,3000);
        shakeAmt+=2.0;
      }
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_FIRE, 40);
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_GLOW, 3);
      pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_SMOKE, 3);
      for(int i=0;i<8;i++) {
        pfx.spawn(pos.x+random(-28,28), pos.y+random(-10,midAirCollision ? -7 : 3.5),ParticleSet.TYPE_FIRE, 20);
        pfx.spawn(pos.x+random(-35,35), pos.y+random(-10,midAirCollision ? -7 : 3.5),ParticleSet.TYPE_GLOW, 1);
        pfx.spawn(pos.x+random(-21,21), pos.y+random(-17,midAirCollision ? -14 : 3.5),ParticleSet.TYPE_SMOKE, 1);
      }
      
      shredHole(pos.x,pos.y,160,3000);
      shakeAmt+=30.0;
      return;
    }
    
    if(reloadSndDelay>0) {
      reloadSndDelay=0;
    }
        
    if(holdingUp) {
      ang += 0.04;
    }
    if(holdingDown) {
      ang -= 0.04;
    }
    if(ang<-PI) {
      ang += 2*PI;
    }
    if(ang>PI) {
      ang -= 2*PI;
    }
    float newSpeed;
    if(holdingRight) {
      newSpeed = maxSpeed;
    } else if(holdingLeft) {
      newSpeed = minSpeed;
    } else {
      newSpeed = avgSpeed;
    }
    
    if(engineSndDelay--<0) {
      engineSndDelay = 2;

      if(newSpeed == maxSpeed) {
        sndEng3.trigger();
      } else if(newSpeed == minSpeed) {
        sndEng1.trigger();
      } else {
        sndEng2.trigger();
      }
    }

    
    float downAng = ang-0.5*PI;
    if(downAng<-PI) {
      downAng += 2*PI;
    }
    if(downAng>PI) {
      downAng -= 2*PI;
    }
    
    float downMatters = 1.0-(1100.0-alt)/1100.0;
    if(downMatters>1) {
      downMatters=1;
    }
    downMatters*=downMatters;
    newSpeed *= ((1.0-(abs(downAng)/PI))*downMatters+(1.0-downMatters));

    if(alt>700.0 && ang<0.0) {
      if(ang<-PI*0.5) {
        ang-=0.05;
      } else {
        ang+=0.05;
      }
    }
    
    speed = 0.8*speed+0.2*newSpeed;
    
    if(holdingA) {
      if(usedA==false) {
        if(ammo_bomb>0) {
          bombList.add(new Bomb(bombImg));
          ammo_bomb--;
        } else if(reloadSndDelay==0){
          reloadSndDelay=reloadClickInterval;
          sndEmpty.trigger();
        }
        usedA = true;
      }
    } else {
      usedA = false;
    }
    
    if(holdingS) {
      if(usedS==false) {
        if(ammo_cluster>0) {
          bombList.add(new Bomb(clusterImg));
          ammo_cluster--;
        } else if(reloadSndDelay==0){
          reloadSndDelay=reloadClickInterval;
          sndEmpty.trigger();
        }
        usedS = true;
      }
    } else {
      usedS = false;
    }
    
    if(holdingD) {
      if(usedD==false) {
        if(ammo_fire>0) {
          bombList.add(new Bomb(napalmImg));
          ammo_fire--;
        } else if(reloadSndDelay==0){
          reloadSndDelay=reloadClickInterval;
          sndEmpty.trigger();
        }
        usedD = true;
      }
    } else {
      usedD = false;
    }
      
    if(holdingF) {
      if(usedF==false) {
        if(ammo_missile>0) {
          bombList.add(new Bomb(missileImg));
          ammo_missile--;
        } else if(reloadSndDelay==0){
          reloadSndDelay=reloadClickInterval;
          sndEmpty.trigger();
        }
        usedF = true;
      }
    } else {
      usedF = false;
    }
    
    if(holdingSpace) {
      if(ammo_gun>0) {
        pfx.spawn(pos.x, pos.y,ParticleSet.TYPE_CANNON_TRAIL, 1);
        ammo_gun-=int(1+random(5));
        if(ammo_gun<0) {
          ammo_gun=0;
        }
        bombList.add(new Bomb(smokeImg));
      } else if(reloadSndDelay==0){
        reloadSndDelay=reloadClickInterval>>1;
        sndEmpty.trigger();
      }
    }
    
    v.x = cos(ang)*speed;
    v.y = sin(ang)*speed;
    
    if(speed<5) {
      v.y += 3*(5-speed);
    }
    
    pos.add(v);

    pushMatrix();
    translate(pos.x,pos.y);
    rotate(ang);
    image(planeImg,-planeImg.width*0.5,-planeImg.height*0.5);
    popMatrix();      
  }
}
