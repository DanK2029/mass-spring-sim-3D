ArrayList<Creature> creatureList = new ArrayList<Creature>();

float gravity = -300;
float springDampeningConst = -0.3;
float viscousDampeningConst = 2;
float ballRadius = 10;
float tDelta = 0.0025;
float time = 0;
//String curIterator = "verlet";
String curIterator = "eulerForward";
float floorFriction = 0.4;
int creatureCount = 0;

boolean halfStepFirstIter = true;
boolean halfStepFirstIterSpring = true;
int draggedBallIndex = -1;

boolean singleStep = false;
boolean showMode = true;

int simIterStep = 0;

int GAPopSize = 40;
int GANumOfGens = 40;
int timeTestSpan = 8000;
float fractionToKeep = 0.2;
Creature baseCreature;
int generationCount;
int testNum = 4;

String structureFileName = "";



void setup(){
  size(1000,600, P3D);
  frameRate(1000);
  background(255);
  
  
  //structureFileName = "daintyWalker";
  //structureFileName = "daintyWalkerRods";
  structureFileName = "baseTriangleCreature";
  //structureFileName = "wheel";
  //structureFileName = "inchworm";
  
  readCreatureFile("structures/" + structureFileName + ".txt");
  baseCreature = creatureList.get(0).copyCreature();
  moveCreatureToGround(baseCreature);
  moveCreatureToGround(creatureList.get(0));
  randomSeed(0);
  if (!showMode) {
    creatureList.remove(0);
    creatureList.add(geneticAlgorithm(GAPopSize, GANumOfGens, timeTestSpan, baseCreature));
  } else {
    generationCount = GANumOfGens;
    creatureList.remove(0);
    readCreatureFile("C:\\Users\\Daniel\\Documents\\Georgia Institute of Technology\\Spring 2017\\CS 3451\\projects\\mass_spring_sim _3D\\mass_spring_sim_3D\\structures\\GenAlgoCreations\\winningCreatures\\"+ structureFileName + "\\" + "test" + testNum + "\\" + generationCount + ".txt");

    moveCreatureToGround(creatureList.get(0));
  }
  time = 0.0;
  for (int i = 0; i < creatureList.get(0).ballList.size(); i++) {
    MassBall ball = creatureList.get(0).ballList.get(i);
    camX += ball.xPos;
    camY += ball.yPos;
    camZ += ball.zPos;
  }
  camX /= creatureList.get(0).ballList.size();
  camY /= creatureList.get(0).ballList.size();
  camZ /= creatureList.get(0).ballList.size();
  
  //lights();
  //ambient(50);
  //directionalLight(50,50,50, 0.5, -0.5, 0.3);

  camera(0, 500, -500,  camX, camY, camZ,  0, -1.0, 0);
}



void draw() {
  pushMatrix();
  translate(50,50,50);
  sphere(5);
  popMatrix();
  drawLine(20,20,20, 50,50,50, 10, creatureList.get(0).creatureColor);
  displayShowMode();
}

void simStep(ArrayList<Creature> creatureList) {
  //println("sim step"+iterStep);
  simIterStep++;
  background(255);
  fill(0);
  /*text("Generation: "+generationCount, 10, 10);
  text("Creature ID: "+creatureList.get(0).id, 10, 25);
  text("Creature Name: "+structureFileName, 10, 40);
  text("Test Number: "+testNum, 10, 55);
  text("fitness: "+str(creatureList.get(0).fitness), 10, 70);
  text("Sim Iteration Step: "+simIterStep, 10, 85);
  text("Max X Pos: "+creatureList.get(0).getMaxXPos(), 10, 100);
  */
  //reset forces
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).ballList.size(); j++) {
      creatureList.get(i).ballList.get(j).xForce = 0.0;
      creatureList.get(i).ballList.get(j).yForce = 0.0;
      creatureList.get(i).ballList.get(j).zForce = 0.0;
    }
  }
  
  //satisfy rod constraints
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).rodList.size(); j++) {
      MassBall lb = creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).leftBallIndex);
      MassBall rb = creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).rightBallIndex);
      float deltaX = lb.xPos - rb.xPos;
      float deltaY = lb.yPos - rb.yPos;
      float deltaZ = lb.zPos - rb.zPos;
      float deltaLength = sqrt(deltaX*deltaX + deltaY*deltaY);
      float diff = (deltaLength - creatureList.get(i).rodList.get(j).restLength)/deltaLength;
      
      lb.xPos -= deltaX * 0.5 * diff;
      lb.yPos -= deltaY * 0.5 * diff;
      lb.zPos -= deltaZ * 0.5 * diff;
      
      rb.xPos += deltaX * 0.5 * diff;
      rb.yPos += deltaY * 0.5 * diff;
      rb.zPos += deltaZ * 0.5 * diff;
      
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).leftBallIndex).xPos = lb.xPos;
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).leftBallIndex).yPos = lb.yPos;
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).leftBallIndex).zPos = lb.zPos;
      
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).rightBallIndex).xPos = rb.xPos;
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).rightBallIndex).yPos = rb.yPos;
      creatureList.get(i).ballList.get(creatureList.get(i).rodList.get(j).rightBallIndex).zPos = rb.zPos;
    }
  }
  
  //calculate springs
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).springList.size(); j++) {
      Spring spring = creatureList.get(i).springList.get(j);
      springForceCalc(creatureList.get(i), j);
      readjustSpringRestLength(creatureList.get(i), j);
      spring.age += tDelta;      
    }
  }
  
  //apply forces to balls
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).ballList.size(); j++) {
      MassBall ball = creatureList.get(i).ballList.get(j);
      ball.yForce += gravity * ball.mass;
      ball.xForce -= viscousDampeningConst * ball.xVel;
      ball.yForce -= viscousDampeningConst * ball.yVel;
      ball.zForce -= viscousDampeningConst * ball.zVel;
    }
  }
  
  
  //calculate ball physics
  if (curIterator == "halfStep") {
    halfStep(1, tDelta, creatureList);
  } else if (curIterator == "eulerForward") {
    eulerForward(1, tDelta, creatureList);
  } else if (curIterator == "verlet") {
    verlet(1, tDelta, creatureList);
  }
  
  time += tDelta;
}

void readjustSpringRestLength(Creature creature, int springIndex){
  float frequency = 5;
  float phase = creature.springList.get(springIndex).phase;
  float magnitude = creature.springList.get(springIndex).magnitude;
  
  creature.springList.get(springIndex).restLength = creature.springList.get(springIndex).originalRestLength + magnitude*sin(time*frequency + phase*(2*PI));
  }

void springForceCalc(Creature creature, int springIndex) {
  //calculates the forces applied to all balls attatched to springs
  float Ks = creature.springList.get(springIndex).springConst;
  float Kd = springDampeningConst;
  float r = creature.springList.get(springIndex).restLength;
  
  MassBall rightBall = creature.ballList.get(creature.springList.get(springIndex).rightBallIndex);
  MassBall leftBall = creature.ballList.get(creature.springList.get(springIndex).leftBallIndex);
  
  float springLength = sqrt(sq(rightBall.xPos - leftBall.xPos) + sq(rightBall.yPos - leftBall.yPos));
  
  float ballXPosDif = (leftBall.xPos - rightBall.xPos);
  float ballYPosDif = (leftBall.yPos - rightBall.yPos);
  float ballZPosDif = (leftBall.zPos - rightBall.zPos);
  
  float ballXVelDif = (leftBall.xVel - rightBall.xVel);
  float ballYVelDif = (leftBall.yVel - rightBall.yVel);
  float ballZVelDif = (leftBall.zVel - rightBall.zVel);
  
  float ballPosDotVel = (ballXPosDif * ballXVelDif) + (ballYPosDif * ballYVelDif) + (ballZPosDif * ballZVelDif); 
  
  float fx = -((Ks * (r - springLength)) + (Kd * (ballPosDotVel)/springLength)) * (ballXPosDif/springLength);
  float fy = -((Ks * (r - springLength)) + (Kd * (ballPosDotVel)/springLength)) * (ballYPosDif/springLength);
  float fz = -((Ks * (r - springLength)) + (Kd * (ballPosDotVel)/springLength)) * (ballZPosDif/springLength);
  
  rightBall.xForce += fx;
  rightBall.yForce += fy;
  rightBall.zForce += fz;
  
  leftBall.xForce -= fx;
  leftBall.yForce -= fy;
  leftBall.zForce -= fz;
  
}

void applyFrictionAndBounceForce(MassBall ball) { 
  // applying friction force to balls touching floor or wall
  // reverses ball's verticle velocity when hiting floor or wall
  float restitution = -0.1;
  if (ball.yPos-ballRadius <= 0.0) {
    if (ball.yVel <= 0.0) {
      ball.yVel = restitution * ball.yVel;
    }
  }
    
  if (ball.yPos < ballRadius+0.1) {
      float xfricForce = -(ball.friction) * ball.xVel;
      float zfricForce = -(ball.friction) * ball.zVel;
      
      ball.xForce += xfricForce;
      ball.zForce += zfricForce;
  }
}


void boundCheck(MassBall ball) {
  // resets balls who have gone outside the walls or floor to just inside
  if (ball.yPos-ballRadius <= 0.0) {
    ball.yPos = ballRadius;
  }
  
  /*if (ball.xPos+ballRadius > width) {
    ball.xPos = width - ballRadius;
  }*/
  
  if (ball.xPos-ballRadius < 0.0) {
    ball.xPos = ballRadius;
  }
}

void moveCreatureToGround(Creature c) {
  // function to move a creature so that its lowest ball is touching the floor
  float lowestBallYPos = Float.MAX_VALUE;
  for (int i = 0; i < c.ballList.size(); i++) {
    if (c.ballList.get(i).yPos < lowestBallYPos) {
      lowestBallYPos = c.ballList.get(i).yPos;
    }
  }
  for (int i = 0; i < c.ballList.size(); i++) {
    c.ballList.get(i).yPos -= lowestBallYPos - ballRadius;
  }
}