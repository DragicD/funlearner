void draw() {
  eraseTheBackground();
  ballMove();
  ballEdgeCheck();
  ballDraw();
}

void eraseTheBackground() {
  background(0,0,255);
}

void setup() {
  size(720, 400);
}
