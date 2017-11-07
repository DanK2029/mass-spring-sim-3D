class Creature {
  ArrayList<MassBall> ballList;
  ArrayList<MassBall> tempBallList = new ArrayList<MassBall>();
  
  ArrayList<Spring> springList;
  ArrayList<Rod> rodList;
  
  float fitness = 0.0;
  int id = creatureCount;
  
  color creatureColor = color(0,0,0);
  
  Creature() {
    this.ballList = new ArrayList<MassBall>();
    this.tempBallList = new ArrayList<MassBall>();
    this.springList = new ArrayList<Spring>();
    this.rodList = new ArrayList<Rod>();
  }
  
  //Creature(ArrayList<MassBall> ballList, ArrayList<Spring> springList) {
  //  this.id = creatureCount;
  //  this.ballList = ballList;
  //  for (int i = 0; i < ballList.size(); i++) {
  //    MassBall copiedBall = ballList.get(i).copyMassBall();
  //    if (tempBallList == null) {
  //      println("tempBallList is null");
  //    }
  //    this.tempBallList.add(copiedBall);
  //  }
    
  //  this.springList = springList;
  //}
  
  Creature(ArrayList<MassBall> ballList, ArrayList<Spring> springList, ArrayList<Rod> rodList) {
    this.id = creatureCount;
    this.ballList = ballList;
    for (int i = 0; i < ballList.size(); i++) {
      MassBall copiedBall = ballList.get(i).copyMassBall();
      if (tempBallList == null) {
        println("tempBallList is null");
      }
      this.tempBallList.add(copiedBall);
    }
    
    this.springList = springList;
    this.rodList = rodList;
  }
  
  Creature copyCreature() {
    ArrayList<MassBall> copiedBallList = new ArrayList<MassBall>();
    ArrayList<MassBall> copiedTempBallList = new ArrayList<MassBall>();
    ArrayList<Spring> copiedSpringList = new ArrayList<Spring>();
    ArrayList<Rod> copiedRodList = new ArrayList<Rod>();
    
    for (int i = 0; i < this.ballList.size(); i++) {
      copiedBallList.add(this.ballList.get(i).copyMassBall());
    }
    for (int i = 0; i < this.tempBallList.size(); i++) {
      copiedTempBallList.add(this.tempBallList.get(i).copyMassBall());
    }
    for (int i = 0; i < this.springList.size(); i++) {
      copiedSpringList.add(this.springList.get(i).copySpring());
    }
    for (int i = 0; i < this.rodList.size(); i++) {
      copiedRodList.add(this.rodList.get(i).copyRod());
    }
    Creature copiedCreature = new Creature(copiedBallList, copiedSpringList, copiedRodList);
    return copiedCreature;
  }
  
  void mutate() {
    // changes magnitude and phase
    id = creatureCount;
    float scaler = 0.1;
    for (int i = 0; i < springList.size()-1; i++) {
      float sParameterDecider = random(0,1);
      if (sParameterDecider < 0.33) {
        float dPhase = random(-0.1, 0.1) * scaler;
        springList.get(i).phase += dPhase;
      } if (sParameterDecider > 0.33 && sParameterDecider < 0.66) {
        float dMagnitude = random(-5, 5) * scaler;
        springList.get(i).magnitude += dMagnitude;
        if (springList.get(i).magnitude > 35.0) {
          springList.get(i).magnitude = 35.0;
        }
        if (springList.get(i).magnitude < -35.0) {
          springList.get(i).magnitude = -35.0;
        }
      }
    }
    for (int i = 0; i < ballList.size(); i++) {
      float bParameterDecider = random(0,1);
      if (bParameterDecider < 0.66) {
        float dFriction = random(-2.0, 2.0) * scaler;
        ballList.get(i).friction += dFriction;
        if (ballList.get(i).friction < 0.0) {
          ballList.get(i).friction = 0.0;
        }
      }
    }
  }
  
  void printCreatureAttributes() {
    this.printCreaturePhases();
    this.printCreatureMagnitudes();
    this.printCreatureBallPos();
    this.printCreatureBallVel();
    this.printCreatureBallAcc();
    this.printCreatureBallFrictions();
    this.printCreatureBallForces();
    this.printCreatureRestLengths();
  }
  
  void printCreaturePhases() {
    println();
    print("Phases: ");
    for (int i = 0; i < this.springList.size(); i++) {
      print(springList.get(i).phase+", ");
    }
  }
  
  void printCreatureMagnitudes() {
    println();
    print("Magnitudes: ");
    for (int i = 0; i < this.springList.size(); i++) {
      print(springList.get(i).magnitude+", ");
    }
  }
  
  void printCreatureBallPos() {
    println();
    print("Ball Positions: ");
    for (int i = 0; i < ballList.size(); i++) {
      print("[" + ballList.get(i).xPos + ", " + ballList.get(i).yPos+"], ");
    }
  }
  
  void printCreatureBallVel() {
    println();
    print("Ball Vel: ");
    for (int i = 0; i < ballList.size(); i++) {
      print("[" + ballList.get(i).xVel + ", " + ballList.get(i).yVel+"], ");
    }
  }
  
  void printCreatureBallAcc() {
    println();
    print("Ball Acc: ");
    for (int i = 0; i < ballList.size(); i++) {
      print("[" + ballList.get(i).xAcc + ", " + ballList.get(i).yAcc+"], ");
    }
  }
  
  void printCreatureBallFrictions() {
    println();
    print("Ball Frictions: ");
    for (int i = 0; i < ballList.size(); i++) {
      print(ballList.get(i).friction + ", ");
    }
  }
  
  void printCreatureBallForces() {
    println();
    print("Ball Forces: ");
    for (int i = 0; i < ballList.size(); i++) {
      print("[" + ballList.get(i).xForce + ", " + ballList.get(i).yForce+"]");
    }
  }
  
  void printCreatureRestLengths() {
    println();
    print("Ball Rest Lengths: ");
    for (int i = 0; i < springList.size(); i++) {
      print(springList.get(i).restLength+", ");
    }
  }
  
  float evaluateCreature() {
    float score = 0.0;
    for (int i = 0; i < this.ballList.size(); i++) {
      score += this.ballList.get(i).xPos;
    }
    return (float) (score/this.ballList.size());
  }
  
  float[] getAveragePos() {
    float[] avg = new float[3];
    for (int i = 0; i < this.ballList.size(); i++) {
      avg[0] += this.ballList.get(i).xPos;
      avg[1] += this.ballList.get(i).yPos;
      avg[2] += this.ballList.get(i).zPos;
    }
    
    avg[0] /= this.ballList.size();
    avg[1] /= this.ballList.size();
    avg[2] /= this.ballList.size();
    
    return avg;
  }
  
  float getMaxXPos() {
    float maxXPos = 0.0;
    for (int i = 0; i < ballList.size(); i++) {
      if (ballList.get(i).xPos > maxXPos) {
        maxXPos = ballList.get(i).xPos;
      }
    }
    return maxXPos;
  }
  
  void translateCreature(float dX, float dY) {
    for (int i = 0; i < this.ballList.size(); i++) {
      this.ballList.get(i).prevXPos += dX;
      this.ballList.get(i).prevYPos += dY;
      this.ballList.get(i).xPos += dX;
      this.ballList.get(i).yPos += dY;
    }
  }
  
  public int compareTo(Creature c) {
    return (int) (fitness - c.fitness);
  }
  
}



class MassBall {
  
  float xForce, yForce, zForce;
  
  float prevXPos, prevYPos, prevZPos;
  
  float xPos, yPos, zPos;
  float xVel, yVel, zVel;
  float xAcc, yAcc, zAcc;
  
  boolean dragged = false;
  boolean pinned = false;
  
  float mass;
  
  float friction;
  
  MassBall () {
  }
  
  MassBall (float x, float y, float z, float f) {
    xPos = x;
    yPos = y;
    zPos = z;
    prevXPos = x;
    prevYPos = y;
    prevZPos = z;
    friction = f;
    mass = 1.0;
  }
  
  MassBall (float x, float y, float z, float f, float m) {    
    xPos = x;
    yPos = y;
    zPos = z;
    prevXPos = x;
    prevYPos = y;
    prevZPos = z;
    friction = f;
    mass = m;
  }
  
  MassBall copyMassBall() {
    MassBall copiedMassBall = new MassBall(xPos, yPos, friction, mass);
    
    copiedMassBall.xForce = this.xForce;
    copiedMassBall.yForce = this.yForce;
    copiedMassBall.zForce = this.zForce;
    
    copiedMassBall.xAcc = this.xAcc;
    copiedMassBall.yAcc = this.yAcc;
    copiedMassBall.zAcc = this.zAcc;
    
    copiedMassBall.xVel = this.xVel;
    copiedMassBall.yVel = this.yVel;
    copiedMassBall.zVel = this.zVel;
    
    copiedMassBall.xPos = this.xPos;
    copiedMassBall.yPos = this.yPos;
    copiedMassBall.zPos = this.zPos;
    
    copiedMassBall.prevXPos = this.prevXPos;
    copiedMassBall.prevYPos = this.prevYPos;
    copiedMassBall.prevZPos = this.prevZPos;
    
    copiedMassBall.friction = this.friction;
    copiedMassBall.mass = this.mass;
    
    return copiedMassBall;
  }
  
}

class Spring {
  float restLength;
  float springConst;
  
  float phase;
  float magnitude;
  
  
  
  int rightBallIndex;
  int leftBallIndex;
  
  float age = 0.0;
  float originalRestLength;
  
  Spring (float k, float r, float p, float mag, int lbIndex, int rbIndex) {
    springConst = k;
    rightBallIndex = rbIndex;
    leftBallIndex = lbIndex;
    restLength = r;    
    originalRestLength = r;
    phase = p;
    magnitude = mag;
  }
  
  Spring copySpring() {
    Spring copiedSpring = new Spring(springConst, restLength, phase, magnitude, leftBallIndex, rightBallIndex);
    copiedSpring.originalRestLength = originalRestLength;
    return copiedSpring;
  }
}

class Rod {
  float restLength;
  
  int rightBallIndex;
  int leftBallIndex;
  
  Rod(float r, int rbIndex, int lbIndex) {
    this.restLength = r;
    this.rightBallIndex = rbIndex;
    this.leftBallIndex = lbIndex;
  }
  
  Rod copyRod() {
    Rod copiedRod = new Rod(this.restLength, this.leftBallIndex, this.rightBallIndex);
    return copiedRod;
  }

}