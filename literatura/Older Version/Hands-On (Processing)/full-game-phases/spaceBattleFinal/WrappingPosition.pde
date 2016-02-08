class WrappingPosition {
  protected float x, y;

  protected void updateWrap() {
    // wrap if off screen edge
    if (x < 0) {
      x += width;
    }
    if (y < 0) {
      y += height;
    }
    if (x > width) {
      x -= width;
    }
    if (y > height) {
      y -= height;
    }
  }
}

