import java.awt.event.KeyEvent;
import java.util.Arrays;
import java.util.Comparator;

// Changeable variables
int lfrcount = 45;
float mutationRate = 0.01;
float diffa , diffm, preva, prevm;

// End


LFR[] lfrs;
float time;
int generation;
float[][] distPoints;

float fitness(LFR lfr) {
  return lfr.distance + lfr.time/time;
}


// do stuff
LFR crossover(LFR A, LFR B) {
  LFR C = new LFR((A.friction + B.friction)*(0.5 + (random(1)<mutationRate?0.05:0) * (random(1)<0.5?1:-1)), (A.acceleration + B.acceleration)*(0.5 + (random(1)<mutationRate?0.05:0) * (random(1)<0.5?1:-1)), (A.maxSpeed + B.maxSpeed)*(0.5 + (random(1)<mutationRate?0.05:0) * (random(1)<0.5?1:-1)));
  return C;
}

void setup() {
  size(1280, 720);
  lfrs = new LFR[lfrcount];
  //distPoints = new float[][]{ { 639, 387 }, { 639, 423 }, { 639, 475 }, { 641, 547 }, { 637, 600 }, { 599, 600 }, { 529, 600 }, { 454, 598 }, { 394, 598 }, { 347, 600 }, { 289, 598 }, { 219, 600 }, { 201, 572 }, { 202, 502 }, { 199, 438 }, { 202, 358 }, { 202, 293 }, { 202, 225 }, { 202, 138 }, { 202, 100 }, { 239, 125 }, { 284, 150 }, { 331, 177 }, { 382, 208 }, { 442, 242 }, { 486, 272 }, { 542, 302 }, { 587, 330 } };
  distPoints = new float[][]{ { 989, 202 }, { 1036, 335 }, { 1039, 523 }, { 974, 635 }, { 759, 635 }, { 544, 670 }, { 392, 650 }, { 372, 520 }, { 514, 488 }, { 639, 532 }, { 766, 525 }, { 826, 408 }, { 777, 255 }, { 487, 248 }, { 274, 238 }, { 114, 267 }, { 79, 435 }, { 106, 590 }, { 181, 652 }, { 244, 620 }, { 276, 548 }, { 286, 450 }, { 294, 115 }, { 360, 70 }, { 779, 83 }, { 989, 80 } };
  for (int i = 0; i < lfrs.length; i++) {
    lfrs[i] = new LFR(random(-1, 0), random(0, 1), random(1, 7));
  }
  generation = 1;
  time = 1.0/30.0;
  smooth();
  fill(213, 78, 78);
  noFill();
  textAlign(LEFT, TOP);
  frameRate(60);
  textSize(15);
}

void draw() {
  background(255);
  strokeWeight(7);
  //noLoop();

  beginShape();
  for (int i = 0; i < distPoints.length + 3; i++) {
    curveVertex(distPoints[i%distPoints.length][0], distPoints[i%distPoints.length][1]);
  }
  endShape();
  //line(width/2, height/2, width/2, 600);
  //line(width/2, 600, 200, 600);
  //line(200, 600, 200, 100);
  //line(200, 100, width/2, height/2);
  //strokeWeight(3);
  stroke(0, 255, 0);
  strokeWeight(1);
  for (int i = 0; i < distPoints.length; i++) {
    point((float)distPoints[i][0], (float)distPoints[i][1]);
  }
  stroke(0);
  //noFill();
  //bezier(width/2, height/2, 400, 500, 650, 230, 100, 100);
  //circle(width/2, height/2, 400);
  //fill(213, 78, 78);

  for (int i = 0; i < lfrs.length; i++) {
    lfrs[i].update();
    if (dist(lfrs[i].x, lfrs[i].y, distPoints[lfrs[i].distance%distPoints.length][0], distPoints[lfrs[i].distance%distPoints.length][1]) < 25.0) {
      lfrs[i].distance += 1;
      lfrs[i].time = time;
    }
  }

  for (int i = 0; i < lfrs.length; i++) {
    lfrs[i].show();
  }
  time += 1.0/30.0;
  text("Generation: " + generation, 1100, 40);
  text("Time elapsed: " + time, 1100, 70);
  text("Framerate: " + frameRate, 1100, 100);

  if (time > 60) {
    generation += 1;

    //sort based on fitness

    Arrays.sort(lfrs, new Comparator<LFR>() {
      public int compare(LFR A, LFR B) {
        return Double.compare(A.distance + A.time/time, B.distance + A.time/time);
        //return Double.compare(A.distance, B.distance);
      }
    }
    );

    //for (int i = 0; i < lfrs.length; i++) {
    //  System.out.format("%.2f ", lfrs[i].distance + lfrs[i].distance/time);
    //}
    //System.out.println();

    System.out.println("Acceleration: " + lfrs[44].acceleration);
    System.out.println("Friction: " + lfrs[44].friction);
    System.out.println("Max speed: " + lfrs[44].maxSpeed);
    
    if(generation>2){
      diffa = abs(preva - lfrs[44].acceleration);
      diffm = abs(prevm - lfrs[44].maxSpeed);
      if( diffa<0.0002 && diffm<0.002 && m==3){  
        noLoop();
       
        text("Optimised Acceleration: " + lfrs[44].acceleration, 545, 374);
        text("Optimised maxSpeed: " + lfrs[44].maxSpeed, 545, 409);
        
      }
      else if(diffa<0.0002 && diffm<0.0002){
      m++;
      }
      else m=0;
    
    }
    preva=lfrs[44].acceleration;
    prevm=lfrs[44].maxSpeed;
    
    //noLoop();
    //generate 30 new children using crossover function + mutation
    for (int i = 0; i < 30; i++) {
      lfrs[i] = crossover(lfrs[floor(random(30, 45))], lfrs[floor(random(30, 45))]);
    }
    //reset start positions of all LFRs
    for (int i = 0; i < lfrs.length; i++) {
      lfrs[i].reset();
    }
    time = 1.0/30.0;
    
  }
}

void mouseClicked() {
  System.out.print("{ " + str(mouseX) + ", " + str(mouseY) + " }, ");
  point(mouseX, mouseY);
}

//void keyPressed() {
//  if (keyCode == KeyEvent.VK_D) {
//    for (int i = 0; i < lfrs.length; i++) {
//      lfrs[i].changeRot(4);
//    }
//  } else if (keyCode == KeyEvent.VK_A) {
//    for (int i = 0; i < lfrs.length; i++) {
//      lfrs[i].changeRot(-4);
//    }
//  }
//}
