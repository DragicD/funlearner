actor Player = new actor(false);
ArrayList badguys = new ArrayList();

void setup() {
  size(640,480);
  loadBackground();
  for(int i=0;i<20;i++) {
    badguys.add( new actor(true) );
  }
}

void draw() {
  drawBackground();
  for(int i=0;i<badguys.size();i++) {
    actor eachBadguy = (actor)badguys.get(i);
    eachBadguy.moveMe();
    eachBadguy.drawMe();
  }
  Player.moveMe();
  Player.drawMe();
}
