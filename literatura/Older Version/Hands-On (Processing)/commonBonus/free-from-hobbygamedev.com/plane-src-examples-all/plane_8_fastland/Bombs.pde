
class Bomb {
  PVector pos,v;
  Boolean isAlive;

  Bomb() {
    isAlive = true;
    pos = new PVector(pl.pos.x,pl.pos.y);
    v = new PVector(3,2);
  }
  
  void handle() {
    int h=0,bx=int(pos.x);
    
    if(bx<0 || bx>=land.width) {
      isAlive = false;
      return;
    }   
    
    h = heightAt(bx);
    
    v.x *= 0.95;
    v.y += 0.5;
    
    pos.add(v);
    
    if(pos.x < 0 || pos.x >= land.width ||
       pos.y < 0) {
      isAlive = false;
    } else if(pos.y>h) {
      pos.y=h;
      
      isAlive = false;
      shredHole(pos.x,pos.y,90,6000);
      shakeAmt += 5.0;
    } else {
      pushMatrix();
      translate(pos.x,pos.y);
      float mang;
      mang = atan2(v.y,v.x);
      rotate(mang);
      image(bombImg,0,0);
      popMatrix();      
    }
  }
  
  Boolean finished() {
    return (isAlive==false);
  }
}
