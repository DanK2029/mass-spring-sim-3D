void eulerForward(int n, float tDelta, ArrayList<Creature> creatureList) {
  
  for (int c = 0; c < creatureList.size(); c++) {
    
    for (int i = 0; i < n; i++) {
      
      creatureList.get(c).tempBallList = realCopyMassBallList(creatureList.get(c).ballList);    
      
      for (int j = 0; j < creatureList.get(c).tempBallList.size(); j++) {
        //println(iterStep);
        //iterStep++;
        MassBall tempBall = creatureList.get(c).tempBallList.get(j);
        
        applyFrictionAndBounceForce(tempBall);
        
        float newXAcc = tempBall.xForce / tempBall.mass;
        float newYAcc = tempBall.yForce / tempBall.mass;
        float newZAcc = tempBall.zForce / tempBall.mass;
        
        float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
        float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
        float newZVel = tempBall.zVel + (tDelta * tempBall.zAcc);
        
        float newXPos = tempBall.xPos + (tDelta * tempBall.xVel);
        float newYPos = tempBall.yPos + (tDelta * tempBall.yVel);
        float newZPos = tempBall.zPos + (tDelta * tempBall.zVel);        
        
        
        creatureList.get(c).ballList.get(j).xAcc = newXAcc;
        creatureList.get(c).ballList.get(j).yAcc = newYAcc;
        creatureList.get(c).ballList.get(j).zAcc = newZAcc;
        
        creatureList.get(c).ballList.get(j).xVel = newXVel;
        creatureList.get(c).ballList.get(j).yVel = newYVel;
        creatureList.get(c).ballList.get(j).zVel = newZVel;
        
        creatureList.get(c).ballList.get(j).xPos = newXPos;
        creatureList.get(c).ballList.get(j).yPos = newYPos;
        creatureList.get(c).ballList.get(j).zPos = newZPos;
        
        boundCheck(creatureList.get(c).ballList.get(j));
      }
    }
  }
}

void halfStep(int n, float tDelta, ArrayList<Creature> creatureList) {
  for (int c = 0; c < creatureList.size(); c++) {
    for (int i = 0; i < n; i++) {
      creatureList.get(c).tempBallList = realCopyMassBallList(creatureList.get(c).ballList);
      for (int j = 0; j < creatureList.get(c).tempBallList.size(); j++) {
        
        if (draggedBallIndex != j) {
          MassBall tempBall = creatureList.get(c).tempBallList.get(j);
          applyFrictionAndBounceForce(tempBall);
        
          float newXAcc = tempBall.xForce / tempBall.mass;
          float newYAcc = tempBall.yForce / tempBall.mass;
          float newZAcc = tempBall.zForce / tempBall.mass;
          
          float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
          float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
          float newZVel = tempBall.zVel + (tDelta * tempBall.zAcc);
          
          float newXPos = tempBall.xPos + (tDelta*(tempBall.xVel + newXVel)/2.0);
          float newYPos = tempBall.yPos + (tDelta*(tempBall.yVel + newYVel)/2.0);
          float newZPos = tempBall.zPos + (tDelta*(tempBall.zVel + newZVel)/2.0);
          
          creatureList.get(c).ballList.get(j).xAcc = newXAcc;
          creatureList.get(c).ballList.get(j).yAcc = newYAcc;
          creatureList.get(c).ballList.get(j).zAcc = newZAcc;
          
          creatureList.get(c).ballList.get(j).xVel = newXVel;
          creatureList.get(c).ballList.get(j).yVel = newYVel;
          creatureList.get(c).ballList.get(j).zVel = newZVel;
          
          creatureList.get(c).ballList.get(j).xPos = newXPos;
          creatureList.get(c).ballList.get(j).yPos = newYPos;
          creatureList.get(c).ballList.get(j).yPos = newZPos;
          
          boundCheck(creatureList.get(c).ballList.get(j));
        }
      }  
    }
  }
}

void verlet(int n, float tDelta, ArrayList<Creature> creatureList) {
  
  for (int c = 0; c < creatureList.size(); c++) {
    
    for (int i = 0; i < n; i++) {
      
      creatureList.get(c).tempBallList = realCopyMassBallList(creatureList.get(c).ballList);    
      
      for (int j = 0; j < creatureList.get(c).tempBallList.size(); j++) {
        
        MassBall tempBall = creatureList.get(c).tempBallList.get(j);
        
        applyFrictionAndBounceForce(tempBall);
        
        float newXAcc = tempBall.xForce / tempBall.mass;
        float newYAcc = tempBall.yForce / tempBall.mass;
        float newZAcc = tempBall.zForce / tempBall.mass;
        
        float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
        float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
        float newZVel = tempBall.zVel + (tDelta * tempBall.zAcc);
        
        float newXPos = (2.0 * tempBall.xPos - tempBall.prevXPos) + (tempBall.xAcc * tDelta * tDelta);
        float newYPos = (2.0 * tempBall.yPos - tempBall.prevYPos) + (tempBall.yAcc * tDelta * tDelta);
        float newZPos = (2.0 * tempBall.zPos - tempBall.prevZPos) + (tempBall.zAcc * tDelta * tDelta);
        
        float xPos = tempBall.xPos;
        float yPos = tempBall.yPos;
        float zPos = tempBall.zPos;

        
        creatureList.get(c).ballList.get(j).xAcc = newXAcc;
        creatureList.get(c).ballList.get(j).yAcc = newYAcc;
        creatureList.get(c).ballList.get(j).zAcc = newZAcc;
        
        creatureList.get(c).ballList.get(j).xVel = newXVel;
        creatureList.get(c).ballList.get(j).yVel = newYVel;
        creatureList.get(c).ballList.get(j).zVel = newZVel;
        
        creatureList.get(c).ballList.get(j).xPos = newXPos;
        creatureList.get(c).ballList.get(j).yPos = newYPos;
        creatureList.get(c).ballList.get(j).zPos = newZPos;
        
        creatureList.get(c).ballList.get(j).prevXPos = xPos;
        creatureList.get(c).ballList.get(j).prevYPos = yPos;
        creatureList.get(c).ballList.get(j).prevZPos = zPos;

        boundCheck(creatureList.get(c).ballList.get(j));
      }
    }
  }
}

ArrayList<MassBall> realCopyMassBallList(ArrayList<MassBall> ballList) {
  ArrayList<MassBall> copiedBallList = new ArrayList<MassBall>();
  for (int i = 0; i < ballList.size(); i++) {
    MassBall copiedBall = ballList.get(i).copyMassBall();
    copiedBallList.add(copiedBall);
  }
  return copiedBallList;
}