class Sensor {
  float x, y;
  boolean val;
  
  Sensor(float startx, float starty) {
    x = startx;
    y = starty;
    val = false;
  }
  
  void show() {
    strokeWeight(3);
    stroke(255, 10, 10);
    point(x, y);
    stroke(0, 0, 0);
    strokeWeight(1);
    //System.out.print(val + " ");
  }
  
  void setValue(float v) {
    val = (v < 0.5);
  }
}
