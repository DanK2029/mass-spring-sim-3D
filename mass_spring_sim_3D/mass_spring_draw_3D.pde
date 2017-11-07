ArrayList camCreaturePosList = new ArrayList<float[]>();
float camRadiusFromCreature = 20.0;
float camOX, camOY, camOZ = 0.0;
float camX, camY, camZ = 0.0;

void updateCamera() {
  float[] newPos = creatureList.get(0).getAveragePos();
  if (camCreaturePosList.size() >= 10) {
    camCreaturePosList.remove(0);
  }
  camCreaturePosList.add(newPos);
  if (camCreaturePosList.size() > 10) {
    println("camera pos list is greater than 10!");
  }
  
  camX = 0;
  camY = 0;
  camZ = 0;
  
  for (int i = 0; i < camCreaturePosList.size(); i++) {
    float[] curPos = (float[]) camCreaturePosList.get(i);
    camX += curPos[0];
    camY += curPos[1];
    camZ += curPos[2];
  }
  
  camX /= camCreaturePosList.size();
  camY /= camCreaturePosList.size();
  camZ /= camCreaturePosList.size();
 
  
  camOX = camX;
  camOY = camY + 50;
  camOZ = camZ - 50;
  
}

void drawFitnessLine() {
  stroke(255,0,0);
  line(creatureList.get(0).fitness, 0, creatureList.get(0).fitness, height);
  noStroke();
}

void  displayShowMode() {
  if (singleStep) {
    simStep(creatureList);
  }
  //lights();
  //ambient(50);
  //directionalLight(50,50,50, 0.5, -0.5, 0.3);
  updateCamera();
  drawFloor();
  drawCreatures();
  drawFitnessLine();
}

void drawCreature(Creature c) {
  // draw creature's springs
  fill(c.creatureColor);
  stroke(c.creatureColor);
  for (int j = 0; j < c.springList.size(); j++) {
    Spring spring = c.springList.get(j);
    MassBall lb = c.ballList.get(spring.leftBallIndex);
    MassBall rb = c.ballList.get(spring.rightBallIndex);
    strokeWeight(ballRadius/1.5);
    stroke(c.creatureColor);
    line(lb.xPos, lb.yPos, rb.xPos, rb.yPos);
  }
  // draw creature's rods
  for (int i = 0; i < c.rodList.size(); i++) {
    Rod rod = c.rodList.get(i);
    MassBall lb = c.ballList.get(rod.leftBallIndex);
    MassBall rb = c.ballList.get(rod.rightBallIndex);
    strokeWeight(ballRadius/1.5);
    stroke(c.creatureColor);
    line(lb.xPos, lb.yPos, lb.zPos, rb.xPos, rb.yPos, lb.zPos);
  }
  // draw creature's balls
  noStroke();
  for (int j = 0; j < c.ballList.size(); j++) {
      MassBall ball = c.ballList.get(j);
      float xBall = ball.xPos;
      float yBall = ball.yPos;
      float zBall = ball.zPos;
      fill(c.creatureColor);
      pushMatrix();
      translate(xBall, yBall, zBall);
      sphere(2*ballRadius);
      popMatrix();    
  }
}

void drawCreatures() {
  //draw creatures
  for (int i = 0; i < creatureList.size(); i++) {
    drawCreature(creatureList.get(i));
  }  
}

void drawFloor() {
  
  PImage checkeredTex = loadImage("checkeredTexture.png");
  fill(0, 0, 255);
  noStroke();
  //drawCylinder(20, 0,0,0, 0,1000,0);
  stroke(0);
  beginShape();
  texture(checkeredTex);
  vertex(1000, 0, 1000, 0, 0);
  vertex(1000, 0, -1000, 0, 1200);
  vertex(-1000, 0, -1000, 1200, 1200);
  vertex(-1000, 0, 1000, 1200, 0);
  endShape(CLOSE);
}

void drawLine ( float x1, float y1, float z1,  float x2, float y2, float z2,  float r, color strokeColour) {
// drawLine programmed by James Carruthers
// see http://processing.org/discourse/yabb2/num_1262458611.html#9
// It is a 3D-replacement for the Line from x1,y1,z1 to xy,y2,z2 with 
// weight and strokeColour. 

 float[] v = {x2-x1, y2-y1, z2-z1};
 float dist = sqrt(sq(v[0]) + sq(v[1]) +sq(v[2]));
 float yTheta = acos(v[2]/dist);
 float zTheta = atan2(v[1],v[0]);
 
 v[0] /= 2;
 v[1] /= 2;
 v[2] /= 2;

 pushMatrix();
 translate(x1,y1,z1);
 translate(v[0], v[1], v[2]);
 rotateZ(zTheta);
 rotateY(yTheta);
 noStroke();
 fill(strokeColour);
 //scale(r/2, dist, r/2);
 //box(r, r, dist);
 
 
 int sides = 32;
  float x_1 = 1;
  float y_1 = 0;
  for (int i = 0; i < sides; i++) {
    float theta = ((i+1) * 2 * PI) / sides;
    float x_2 = r * cos(theta);
    float y_2 = r * sin(theta);
    beginShape();
    normal (x_1, 0, y_1);
    vertex (x_1, 1, y_1);
    vertex (x_1, -1, y_1);
    normal (x_2, 0, y_2);
    vertex (x_2, -1, y_1);
    vertex (x_2, 1, y_2);
    endShape(CLOSE);
    x_1 = x_2;
    y_1 = y_2;
  }
  
 popMatrix();

}