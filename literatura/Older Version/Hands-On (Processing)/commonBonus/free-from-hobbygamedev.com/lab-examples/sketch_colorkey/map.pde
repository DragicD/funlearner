PImage colormap;
PImage prettymap;

final int UNDER_TYPE_WHITE = 0;
final int UNDER_TYPE_RED = 1;
final int UNDER_TYPE_GREEN = 2;
final int UNDER_TYPE_BLUE = 3;
final int UNDER_TYPE_BLACK = 4;

void loadBackground() {
  colormap = loadImage("worldmap.png");
  prettymap = loadImage("pretty.png");
}

int underHere(int thisX,int thisY) {
  color underMe = colormap.get(thisX,thisY);
  if(red(underMe)<5 && green(underMe)<5 && blue(underMe)<5) {
    return UNDER_TYPE_BLACK;
  }
  if(red(underMe)>250 && green(underMe)>250 && blue(underMe)>250) {
    return UNDER_TYPE_WHITE;
  }
  if(red(underMe)>250) {
    return UNDER_TYPE_RED;
  }
  if(green(underMe)>250) {
    return UNDER_TYPE_GREEN;
  }
  if(blue(underMe)>250) {
    return UNDER_TYPE_BLUE;
  }
  return -1;
}

void drawBackground() {
  image(prettymap,0,0);
}
