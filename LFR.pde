class LFR {
  float x, y;
  float rot;
  float speed;
  float maxSpeed;
  float friction;
  float time;
  float acceleration;
  float enabled;
  int distance;
  Sensor[] sensors;

  LFR(float f, float a, float m) {
    x = 989;
    y = 202;
    rot = 0;
    distance = 0;
    speed = 0;
    time = 0;
    enabled = 1;
    
    friction = f;
    acceleration = a;
    maxSpeed = m;

    sensors = new Sensor[4];
    int[][] sensorPos = { {-10, 20}, {-2, 12}, {2, 12}, {10, 20} };

    for (int i = 0; i < sensors.length; i++) {
      sensors[i] = new Sensor(sensorPos[i][0], sensorPos[i][1]);
    }
  }

  void show() {
    pushMatrix();
    translate(x, y);
    noFill();
    //circle(0, 0, 60);
    //text(distance, 30, 30);
    //text(speed, 30, 40);
    //text(rot, 30, 50);
    rotate(radians(rot));
    triangle(0, 20, -20, -20, 20, -20);
    for (int i = 0; i < sensors.length; i++) {
      sensors[i].show();
    }
    popMatrix();
  }  

  void update() {
    pushMatrix();
    translate(x, y);

    for (int i = 0; i < sensors.length; i++) {
      float u = sensors[i].x * cos(radians(rot)) - sensors[i].y * sin(radians(rot)) + x;
      float v = sensors[i].x * sin(radians(rot)) + sensors[i].y * cos(radians(rot)) + y;
      //text(red(get((int)u, (int)v))/255.0, 40, 10 + 12 * i);
      sensors[i].setValue(red(get((int)u, (int)v))/255.0);
    }
    
    if (sensors[0].val && sensors[3].val) {
      if (acceleration < 0) acceleration *= -1;
    } else if (sensors[0].val || sensors[3].val) {
      if (acceleration > 0) acceleration *= -1; 
      if (sensors[2].val && sensors[3].val) {
        changeRot(-6);
      } else if (sensors[2].val || sensors[3].val) {
        changeRot(-3);
      } 
      if (sensors[0].val && sensors[1].val) {
        changeRot(6);
      } else if (sensors[0].val || sensors[1].val) {
        changeRot(3);
      }
    } else {
      if (acceleration < 0) acceleration *= -1;
    }
    speed = constrain(speed + acceleration + friction, 0, maxSpeed);
    if (speed == 0) changeRot((random(1) < 0.5)?1:-1);
    
    rotate(radians(rot));

    x += speed * cos(radians(rot + 90));
    y += speed * sin(radians(rot + 90));

    popMatrix();
  }

  void changeRot(float delta) {
    rot += delta;
  }

  void reset() {
    x = 989;
    y = 202;
    rot = 0;
    distance = 0;
  }
}
